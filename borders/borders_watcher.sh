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
POLL_INTERVAL=1
STYLED_WINDOWS_FILE="/tmp/borders_styled_windows.txt"

# Clear styled windows on startup (styles are lost when borders restarts)
> "$STYLED_WINDOWS_FILE"

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

    > "$temp_file"
    while read -r wid; do
        if echo "$current_ids" | grep -q "^${wid}:"; then
            echo "$wid" >> "$temp_file"
        fi
    done < "$STYLED_WINDOWS_FILE"
    mv "$temp_file" "$STYLED_WINDOWS_FILE"
}

echo "Borders watcher started"
echo "Config: $CONFIG_FILE"
echo "Poll interval: ${POLL_INTERVAL}s"

while true; do
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
                borders "apply-to=$window_id" style=square 2>/dev/null
                mark_styled "$window_id"
                echo "Applied square border to $app_name (window $window_id)"
            fi
        fi
    done

    # Cleanup old window IDs
    cleanup_styled "$WINDOWS"

    sleep "$POLL_INTERVAL"
done
