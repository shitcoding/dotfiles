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
SWIFT_HELPER="$SCRIPT_DIR/get_windows.swift"
BORDERS_BIN="/opt/homebrew/bin/borders"
POLL_INTERVAL=1
STYLED_WINDOWS_FILE="/tmp/borders_styled_windows.txt"
BORDERS_PID_FILE="/tmp/borders_last_pid.txt"

# Clear styled windows on startup (styles are lost when borders restarts)
: > "$STYLED_WINDOWS_FILE"

get_borders_pid() {
    pgrep -x borders 2>/dev/null | head -1
}

# Detect borders restart and clear style cache if needed
check_borders_restart() {
    local current_pid
    current_pid=$(get_borders_pid)
    [[ -z "$current_pid" ]] && return 0

    local last_pid=""
    [[ -f "$BORDERS_PID_FILE" ]] && last_pid=$(cat "$BORDERS_PID_FILE")

    if [[ "$current_pid" != "$last_pid" ]]; then
        echo "Borders restarted (was: ${last_pid:-none}, now: $current_pid). Re-applying styles."
        : > "$STYLED_WINDOWS_FILE"
        echo "$current_pid" > "$BORDERS_PID_FILE"
    fi
}

# Read non-empty, non-comment lines from the config file.
load_square_specs() {
    [[ -f "$CONFIG_FILE" ]] || return
    grep -v '^[[:space:]]*#' "$CONFIG_FILE" | grep -v '^[[:space:]]*$'
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
    local window_id="$1"
    grep -q "^${window_id}$" "$STYLED_WINDOWS_FILE" 2>/dev/null
}

mark_styled() {
    local window_id="$1"
    echo "$window_id" >> "$STYLED_WINDOWS_FILE"
}

cleanup_styled() {
    local current_ids="$1"
    local temp_file="/tmp/borders_styled_temp.txt"

    [[ ! -f "$STYLED_WINDOWS_FILE" ]] && return
    : > "$temp_file"
    while read -r wid; do
        # Numeric guard before grep — wid is interpolated into a regex.
        [[ "$wid" =~ ^[0-9]+$ ]] || continue
        # `current_ids` is the raw `swift get_windows.swift` output: one row
        # per line, fields tab-separated. A window ID matches if it appears
        # at start-of-line followed by a TAB.
        if printf '%s\n' "$current_ids" | grep -q "^${wid}"$'\t'; then
            echo "$wid" >> "$temp_file"
        fi
    done < "$STYLED_WINDOWS_FILE"
    mv "$temp_file" "$STYLED_WINDOWS_FILE" 2>/dev/null
}

echo "Borders watcher started"
echo "Config: $CONFIG_FILE"
echo "Poll interval: ${POLL_INTERVAL}s"

# Store initial borders PID
get_borders_pid > "$BORDERS_PID_FILE"

while true; do
    check_borders_restart

    # Cache specs once per cycle: avoids forking grep twice per window AND
    # gives the loop a consistent view if the config changes mid-cycle.
    SPECS=$(load_square_specs)
    if [[ -z "$SPECS" ]]; then
        sleep "$POLL_INTERVAL"
        continue
    fi

    # Get current windows: window_id<TAB>app_name<TAB>owner_pid<TAB>title.
    WINDOWS=$(swift "$SWIFT_HELPER" 2>/dev/null)

    # Process each window. Here-string keeps the loop in the main shell so
    # we could share state across iterations if needed.
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
