#!/bin/bash
# Auto keyboard backlight daemon for MacBook
# Monitors ambient light sensor and adjusts keyboard backlight accordingly

LIGHT_SENSOR="/sys/devices/platform/applesmc.768/light"
KBD_BACKLIGHT="/sys/class/leds/smc::kbd_backlight/brightness"
KBD_MAX_BRIGHTNESS=255

# Thresholds (adjust to taste)
DARK_THRESHOLD=5       # Below this = dark, full backlight
BRIGHT_THRESHOLD=30    # Above this = bright, no backlight
POLL_INTERVAL=2        # Seconds between checks

# Check dependencies
if [[ ! -f "$LIGHT_SENSOR" ]]; then
    echo "Error: Light sensor not found at $LIGHT_SENSOR"
    exit 1
fi

if [[ ! -f "$KBD_BACKLIGHT" ]]; then
    echo "Error: Keyboard backlight not found at $KBD_BACKLIGHT"
    exit 1
fi

get_ambient_light() {
    # Sensor returns "(left,right)" format, average both values
    local reading=$(cat "$LIGHT_SENSOR" 2>/dev/null)
    local left=$(echo "$reading" | sed 's/(\([0-9]*\),\([0-9]*\))/\1/')
    local right=$(echo "$reading" | sed 's/(\([0-9]*\),\([0-9]*\))/\2/')
    echo $(( (left + right) / 2 ))
}

set_kbd_brightness() {
    local brightness=$1
    echo "$brightness" > "$KBD_BACKLIGHT" 2>/dev/null || \
        echo "$brightness" | sudo tee "$KBD_BACKLIGHT" >/dev/null
}

calculate_kbd_brightness() {
    local ambient=$1
    
    if [[ $ambient -le $DARK_THRESHOLD ]]; then
        echo $KBD_MAX_BRIGHTNESS
    elif [[ $ambient -ge $BRIGHT_THRESHOLD ]]; then
        echo 0
    else
        # Linear interpolation between thresholds
        local range=$((BRIGHT_THRESHOLD - DARK_THRESHOLD))
        local position=$((ambient - DARK_THRESHOLD))
        local brightness=$((KBD_MAX_BRIGHTNESS - (KBD_MAX_BRIGHTNESS * position / range)))
        echo $brightness
    fi
}

echo "Starting keyboard backlight auto-adjustment daemon..."
echo "Dark threshold: $DARK_THRESHOLD, Bright threshold: $BRIGHT_THRESHOLD"

last_brightness=-1

while true; do
    ambient=$(get_ambient_light)
    target_brightness=$(calculate_kbd_brightness "$ambient")
    
    # Only update if brightness changed (avoid unnecessary writes)
    if [[ $target_brightness -ne $last_brightness ]]; then
        set_kbd_brightness "$target_brightness"
        last_brightness=$target_brightness
        echo "Ambient: $ambient -> Keyboard backlight: $target_brightness"
    fi
    
    sleep $POLL_INTERVAL
done
