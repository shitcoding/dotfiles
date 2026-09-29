#!/bin/bash
#
# Watches for windows from specific apps and applies square borders to them.
# Reads matching rules from square_apps.txt in the same directory.
#
# Config format (one rule per line):
#   AppName              → match any window of AppName.
#   AppName:substring    → match windows of AppName whose window title
#                           contains `substring` (case-sensitive), OR whose
#                           owning process command-line contains `substring`
#                           (case-insensitive — a fallback for cases where
#                           the swift helper can't read window titles due to
#                           the macOS Screen Recording permission).
#
# Example: `kitty:Vimput` matches the kitty window whose title is "Vimput",
# or — if titles aren't readable — the kitty process launched with
# `--instance-group vimput`. Other kitty windows get the default rounded
# border.
#

# Prevent duplicate instances
PID_FILE="/tmp/borders_watcher.pid"
if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "Another instance is already running. Exiting."
    exit 1
fi
echo $$ > "$PID_FILE"
# shellcheck disable=SC2064  # PID_FILE is set once at startup; expanding now is intentional
trap "rm -f '$PID_FILE'" EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/square_apps.txt"
SWIFT_SRC="$SCRIPT_DIR/get_windows.swift"
# Compiled once at startup: `swift get_windows.swift` JIT-compiles the script on every
# call (~0.25 s CPU, 170 MB peak), which at one call per second was a fifth of a core.
# Lives outside the repo (public, and a build artifact). Edits to the .swift source need
# a watcher restart; square_apps.txt edits are still picked up live.
HELPER_BIN="${XDG_CACHE_HOME:-$HOME/.cache}/borders/get_windows"
BORDERS_BIN="/opt/homebrew/bin/borders"
POLL_INTERVAL=1

# Everything below runs every second, so the loop sticks to bash builtins: each fork
# costs a Gatekeeper/trustd round-trip on macOS 27. Per cycle it only runs the helper
# and `sleep`. The styled-window set lives in memory, newline-delimited with a leading
# and trailing newline so a membership test is one glob match.
STYLED=$'\n'
SPECS=""

if [[ ! -x "$HELPER_BIN" || "$SWIFT_SRC" -nt "$HELPER_BIN" ]]; then
    echo "Compiling $SWIFT_SRC -> $HELPER_BIN"
    mkdir -p "$(dirname "$HELPER_BIN")"
    swiftc -O "$SWIFT_SRC" -o "$HELPER_BIN" || { echo "swiftc failed"; exit 1; }
fi

get_borders_pid() {
    pgrep -x borders 2>/dev/null | head -1
}

BORDERS_PID=$(get_borders_pid)

# Detect borders restart and clear style cache if needed. `kill -0` is a builtin, so
# pgrep only runs when the known borders pid is gone.
check_borders_restart() {
    [[ -n "$BORDERS_PID" ]] && kill -0 "$BORDERS_PID" 2>/dev/null && return 0

    local current_pid
    current_pid=$(get_borders_pid)
    [[ -z "$current_pid" ]] && return 0

    echo "Borders restarted (was: ${BORDERS_PID:-none}, now: $current_pid). Re-applying styles."
    STYLED=$'\n'
    BORDERS_PID=$current_pid
}

# Read non-empty, non-comment lines from the config file into SPECS.
load_square_specs() {
    SPECS=""
    [[ -f "$CONFIG_FILE" ]] || return 0
    local line skip='^[[:space:]]*(#|$)'
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ $skip ]] && continue
        SPECS+="$line"$'\n'
    done < "$CONFIG_FILE"
    SPECS=${SPECS%$'\n'}
}

# Lowercase a string. Bash 3.2 (system bash on macOS) has no ${var,,}, so
# fall back to tr.
to_lower() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

# Decide whether a given (app, pid, title) should get a square border.
# Iterates each rule in the config; first match wins.
#
# Match strategy per rule with `AppName:substring`:
#   * Title path: if the swift helper provided a non-empty window title,
#     match the rule's substring against the title (case-sensitive). The
#     command-line fallback is NOT consulted when a title is available —
#     this prevents a title that fails to match from being "saved" by a
#     coincidental cmdline hit (e.g. unrelated kitty windows from the
#     Vimput-launched process).
#   * Cmdline fallback: only when title is empty (typically because the
#     swift helper lacks Screen Recording permission). Case-insensitive
#     substring match against `ps -ww` cmdline of the window's owning PID.
#     This catches the Vimput case where the kitty PID's cmdline contains
#     `--instance-group vimput`.
should_square() {
    local app="$1"
    local pid="$2"
    local title="$3"
    local specs="$4"

    local line spec_app spec_pattern cmdline=""

    while IFS= read -r line; do
        if [[ "$line" == *:* ]]; then
            spec_app="${line%%:*}"
            spec_pattern="${line#*:}"
        else
            spec_app="$line"
            spec_pattern=""
        fi

        [[ "$app" != "$spec_app" ]] && continue

        if [[ -z "$spec_pattern" ]]; then
            return 0  # rule with no substring → match any window of this app
        fi

        if [[ -n "$title" ]]; then
            # Title is authoritative when present. Match or move on.
            if [[ "$title" == *"$spec_pattern"* ]]; then
                return 0
            fi
            continue
        fi

        # Title empty → cmdline fallback.
        if [[ -z "$cmdline" ]]; then
            # Validate PID is purely numeric before passing to ps.
            if [[ "$pid" =~ ^[0-9]+$ ]]; then
                # -ww: don't truncate to terminal width; kitty's full cmdline
                # is long enough to be cut off otherwise, hiding our marker.
                cmdline=$(ps -ww -p "$pid" -o command= 2>/dev/null)
            fi
        fi
        local lower_cmdline lower_pattern
        lower_cmdline=$(to_lower "$cmdline")
        lower_pattern=$(to_lower "$spec_pattern")
        if [[ -n "$lower_cmdline" && "$lower_cmdline" == *"$lower_pattern"* ]]; then
            return 0
        fi
    done <<< "$specs"
    return 1
}

is_styled() {
    [[ "$STYLED" == *$'\n'"$1"$'\n'* ]]
}

mark_styled() {
    STYLED+="$1"$'\n'
}

# Drop styled IDs that are no longer in the current window list. `$1` is the raw
# helper output: one row per line, fields tab-separated, so a live window ID sits
# at start-of-line followed by a TAB.
cleanup_styled() {
    local current=$'\n'"$1" kept=$'\n' wid
    while IFS= read -r wid; do
        [[ -n "$wid" && "$current" == *$'\n'"$wid"$'\t'* ]] && kept+="$wid"$'\n'
    done <<< "$STYLED"
    STYLED=$kept
}

echo "Borders watcher started"
echo "Config: $CONFIG_FILE"
echo "Poll interval: ${POLL_INTERVAL}s"

while true; do
    check_borders_restart

    # Reload specs once per cycle: config edits apply live, and the loop gets a
    # consistent view if the file changes mid-cycle.
    load_square_specs
    if [[ -z "$SPECS" ]]; then
        sleep "$POLL_INTERVAL"
        continue
    fi

    # Get current windows: window_id<TAB>app_name<TAB>owner_pid<TAB>title.
    WINDOWS=$("$HELPER_BIN" 2>/dev/null)

    # Process each window. The here-string keeps the loop in the main shell,
    # which mark_styled relies on: a piped loop would update a subshell's copy.
    while IFS=$'\t' read -r window_id app_name owner_pid title; do
        [[ -z "$window_id" ]] && continue
        if should_square "$app_name" "$owner_pid" "$title" "$SPECS"; then
            if ! is_styled "$window_id"; then
                # Only mark styled when the apply actually succeeds — a failed
                # apply (transient IPC error, daemon restart, stale window)
                # should be retried next cycle instead of leaving a sticky
                # mark that suppresses retries.
                if "$BORDERS_BIN" apply-to="$window_id" style=square; then
                    mark_styled "$window_id"
                    if [[ -n "$title" ]]; then
                        echo "Applied square border to $app_name [$title] (window $window_id, pid $owner_pid)"
                    else
                        echo "Applied square border to $app_name (window $window_id, pid $owner_pid)"
                    fi
                else
                    echo "borders apply-to=$window_id failed; will retry next cycle"
                fi
            fi
        fi
    done <<< "$WINDOWS"

    # Cleanup old window IDs no longer in the current window list.
    cleanup_styled "$WINDOWS"

    sleep "$POLL_INTERVAL"
done
