#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Function to get Spotify info
get_spotify_info() {
    local state=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
    if [[ "$state" == "playing" ]]; then
        local artist=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
        local track=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
        echo "playing|$artist|$track"
    elif [[ "$state" == "paused" ]]; then
        echo "paused"
    else
        echo "stopped"
    fi
}

# Function to get Apple Music info
get_apple_music_info() {
    local state=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
    if [[ "$state" == "playing" ]]; then
        local artist=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)
        local track=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
        echo "playing|$artist|$track"
    elif [[ "$state" == "paused" ]]; then
        echo "paused"
    else
        echo "stopped"
    fi
}

# Check Spotify first, then Apple Music
SPOTIFY_INFO=$(get_spotify_info)
APPLE_MUSIC_INFO=$(get_apple_music_info)

if [[ "$SPOTIFY_INFO" == "playing|"* ]]; then
    # Spotify is playing - show the item
    sketchybar --set "$NAME" drawing=on
    ICON="󰓇"
    COLOR=$ACCENT_SECONDARY
    IFS='|' read -r state artist track <<< "$SPOTIFY_INFO"
    if [[ ${#track} -gt 20 ]]; then
        LABEL="${track:0:20}..."
    else
        LABEL="$track"
    fi
elif [[ "$APPLE_MUSIC_INFO" == "playing|"* ]]; then
    # Apple Music is playing - show the item
    sketchybar --set "$NAME" drawing=on
    ICON="󰎆"
    COLOR=$ACCENT_QUATERNARY
    IFS='|' read -r state artist track <<< "$APPLE_MUSIC_INFO"
    if [[ ${#track} -gt 20 ]]; then
        LABEL="${track:0:20}..."
    else
        LABEL="$track"
    fi
elif [[ "$SPOTIFY_INFO" == "paused" ]] || [[ "$APPLE_MUSIC_INFO" == "paused" ]]; then
    # Music is paused - show paused state
    sketchybar --set "$NAME" drawing=on
    ICON="󰏤"
    COLOR=$ACCENT_TERTIARY
    LABEL="Paused"
else
    # No music playing - hide the item completely
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Update the Now Playing item (only if we're showing it)
sketchybar --set "$NAME" icon="$ICON" \
                        icon.color="$COLOR" \
                        label="$LABEL" \
                        label.color=$WHITE \
                        label.font="SF Pro:Medium:12.0" 