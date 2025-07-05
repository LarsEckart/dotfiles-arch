#!/bin/bash
# Keyboard backlight control script for MacBook Pro
# Usage: kbd-backlight.sh [on|off|toggle|brightness_level]

KBD_BACKLIGHT_PATH="/sys/class/leds/smc::kbd_backlight/brightness"
KBD_MAX_BRIGHTNESS_PATH="/sys/class/leds/smc::kbd_backlight/max_brightness"
STATE_FILE="/tmp/kbd_backlight_state"

# Check if keyboard backlight exists
if [[ ! -f "$KBD_BACKLIGHT_PATH" ]]; then
    echo "Error: Keyboard backlight not found at $KBD_BACKLIGHT_PATH"
    exit 1
fi

# Get max brightness
MAX_BRIGHTNESS=$(cat "$KBD_MAX_BRIGHTNESS_PATH" 2>/dev/null || echo "255")

# Get current brightness
get_current_brightness() {
    cat "$KBD_BACKLIGHT_PATH" 2>/dev/null || echo "0"
}

# Set brightness
set_brightness() {
    local brightness=$1
    if [[ $brightness -gt $MAX_BRIGHTNESS ]]; then
        brightness=$MAX_BRIGHTNESS
    elif [[ $brightness -lt 0 ]]; then
        brightness=0
    fi
    
    echo "$brightness" | sudo tee "$KBD_BACKLIGHT_PATH" >/dev/null
    echo "$brightness" > "$STATE_FILE"
}

# Save current state before turning off
save_state() {
    local current=$(get_current_brightness)
    if [[ $current -gt 0 ]]; then
        echo "$current" > "$STATE_FILE"
    fi
}

# Restore previous state
restore_state() {
    local saved_brightness
    if [[ -f "$STATE_FILE" ]]; then
        saved_brightness=$(cat "$STATE_FILE")
        # Default to 100 if saved state is 0 or invalid
        if [[ ! "$saved_brightness" =~ ^[0-9]+$ ]] || [[ $saved_brightness -eq 0 ]]; then
            saved_brightness=100
        fi
    else
        saved_brightness=100
    fi
    set_brightness "$saved_brightness"
}

case "$1" in
    "on")
        restore_state
        ;;
    "off")
        save_state
        set_brightness 0
        ;;
    "toggle")
        current=$(get_current_brightness)
        if [[ $current -eq 0 ]]; then
            restore_state
        else
            save_state
            set_brightness 0
        fi
        ;;
    [0-9]*)
        set_brightness "$1"
        ;;
    *)
        echo "Usage: $0 [on|off|toggle|brightness_level]"
        echo "Current brightness: $(get_current_brightness)/$MAX_BRIGHTNESS"
        exit 1
        ;;
esac