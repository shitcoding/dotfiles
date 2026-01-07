#!/bin/bash
#
# Watches for windows from specific apps and applies square borders to them.
# Reads app names from square_apps.txt in the same directory.
#

# Prevent duplicate instances
PID_FILE="/tmp/borders_watcher.pid"
if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "Another instance is already running. Exiting."
    exit 1
fi
echo $$ > "$PID_FILE"
trap "rm -f '$PID_FILE'" EXIT

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/square_apps.txt"
SWIFT_HELPER="$SCRIPT_DIR/get_windows.swift"
BORDERS_BIN="/opt/homebrew/bin/borders"
POLL_INTERVAL=1
STYLED_WINDOWS_FILE="/tmp/borders_styled_windows.txt"
BORDERS_PID_FILE="/tmp/borders_last_pid.txt"

# Clear styled windows on startup (styles are lost when borders restarts)
> "$STYLED_WINDOWS_FILE"

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
        > "$STYLED_WINDOWS_FILE"
        echo "$current_pid" > "$BORDERS_PID_FILE"
    fi
}

load_square_apps() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo ""
        return
    fi
    grep -v '^#' "$CONFIG_FILE" | grep -v '^$' | tr '\n' '|' | sed 's/|$//'
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
    > "$temp_file"
    while read -r wid; do
        if echo "$current_ids" | grep -q "^${wid}:"; then
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

    SQUARE_APPS=$(load_square_apps)

    if [[ -z "$SQUARE_APPS" ]]; then
        sleep "$POLL_INTERVAL"
        continue
    fi

    # Get current windows
    WINDOWS=$(swift "$SWIFT_HELPER" 2>/dev/null)

    # Process each window
    echo "$WINDOWS" | while IFS=: read -r window_id app_name; do
        [[ -z "$window_id" ]] && continue

        # Check if app is in our list
        if echo "$app_name" | grep -qE "^($SQUARE_APPS)$"; then
            if ! is_styled "$window_id"; then
                $BORDERS_BIN apply-to=$window_id style=square
                mark_styled "$window_id"
                echo "Applied square border to $app_name (window $window_id)"
            fi
        fi
    done

    # Cleanup old window IDs
    cleanup_styled "$WINDOWS"

    sleep "$POLL_INTERVAL"
done
