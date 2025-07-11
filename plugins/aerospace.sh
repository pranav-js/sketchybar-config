#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Get current workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
WORKSPACE_ID="$1"

# Check if any windows exist in this workspace
WORKSPACE_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l)

# Only show workspace if it's active OR has windows
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ] || [ "$WORKSPACE_WINDOWS" -gt 0 ]; then
    # Show the workspace item
    sketchybar --set "$NAME" drawing=on
    
    if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
        # Active workspace styling - more noticeable text
        sketchybar --set "$NAME" \
                   background.drawing=on \
                   background.color=$BACKGROUND_2 \
                   background.corner_radius=6 \
                   background.height=26 \
                   background.border_width=0 \
                   icon.color=$WHITE \
                   icon.font="SF Pro:Semibold:14.0" \
                   label.color=$WHITE
    else
        # Workspace with windows but not focused - subtle styling
        sketchybar --set "$NAME" \
                   background.drawing=on \
                   background.color=$BACKGROUND_1 \
                   background.corner_radius=6 \
                   background.height=26 \
                   background.border_width=0 \
                   icon.color=$GREY \
                   icon.font="SF Pro:Medium:14.0" \
                   label.color=$GREY
    fi
else
    # Hide empty workspace
    sketchybar --set "$NAME" drawing=off
fi



# MAIN_COLOR=0xffa17fa7
# ACCENT_COLOR=0xffe19286
#
# echo $NAME > ~/debug_skekychybar
#
# if [ "$1" = "change-focused-window" ]; then
#     echo "change-focused-window"
#     focused_window_info=$(aerospace list-windows --focused)
#     focused_window_id=$(echo $focused_window_info | awk -F ' \\| ' '{print $1}')
#     if [ "$2" = "$focused_window_id" ]; then
#         sketchybar --set $NAME icon.color=$ACCENT_COLOR
#     else
#         sketchybar --set $NAME icon.color=$MAIN_COLOR
#     fi
# fi
#
# if [ "$1" = "change-focused-workspace" ]; then
#     echo "change-focused-workspace"
#     focused_workspace=$(aerospace list-workspaces --focused)
#     if [ "$2" = "$focused_workspace" ]; then
#         sketchybar --set $NAME label.color=$ACCENT_COLOR
#     else
#         sketchybar --set $NAME label.color=$MAIN_COLOR
#     fi
# fi
#
# if [ "$1" = "move-window-within-workspace" ]; then
#     echo "move-window-within-workspace"
#     focused_workspace=$(aerospace list-workspaces --focused)
#     if [ "$2" = "$focused_workspace" ]; then
#         sketchybar --set $NAME label.color=$ACCENT_COLOR
#     else
#         sketchybar --set $NAME label.color=$MAIN_COLOR
#     fi
# fi
