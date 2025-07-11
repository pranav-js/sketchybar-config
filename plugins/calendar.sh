#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Get next calendar event
get_next_event() {
    # Get events for today and tomorrow
    local today=$(date '+%Y-%m-%d')
    local tomorrow=$(date -v+1d '+%Y-%m-%d')
    
    # Use EventKit to get calendar events
    local event_info=$(osascript << 'EOF'
tell application "Calendar"
    set currentDate to current date
    set endDate to currentDate + (2 * days)
    
    set allEvents to {}
    repeat with cal in calendars
        set calEvents to (events of cal whose start date ≥ currentDate and start date ≤ endDate)
        set allEvents to allEvents & calEvents
    end repeat
    
    if (count of allEvents) > 0 then
        set nextEvent to item 1 of allEvents
        set eventStart to start date of nextEvent
        set eventTitle to summary of nextEvent
        
        # Find the earliest event
        repeat with evt in allEvents
            if start date of evt < eventStart then
                set nextEvent to evt
                set eventStart to start date of evt
                set eventTitle to summary of evt
            end if
        end repeat
        
        # Format the time
        set eventTime to time string of eventStart
        set eventDate to date string of eventStart
        set todayDate to date string of currentDate
        
        if eventDate = todayDate then
            return "Today " & eventTime & "|" & eventTitle
        else
            return "Tomorrow " & eventTime & "|" & eventTitle
        end if
    else
        return "No events"
    end if
end tell
EOF
)
    
    echo "$event_info"
}

# Get calendar information
EVENT_INFO=$(get_next_event 2>/dev/null)

if [[ "$EVENT_INFO" == "No events" ]] || [[ -z "$EVENT_INFO" ]]; then
    # No upcoming events
    ICON="󰸗"
    COLOR=$GREY
    LABEL="No Events"
else
    # Parse event information
    IFS='|' read -r event_time event_title <<< "$EVENT_INFO"
    
    # Set icon and color
    if [[ "$event_time" == "Today"* ]]; then
        ICON="󰃭"
        COLOR=$ACCENT_PRIMARY
    else
        ICON="󰸗"
        COLOR=$ACCENT_QUATERNARY
    fi
    
    # Truncate long event titles
    if [[ ${#event_title} -gt 15 ]]; then
        event_title="${event_title:0:15}..."
    fi
    
    # Format with line break (time on first row, event on second)
    LABEL="$event_time\n$event_title"
fi

# Update the Calendar item
sketchybar --set "$NAME" icon="$ICON" \
                        icon.color="$COLOR" \
                        label="$LABEL" \
                        label.color=$WHITE \
                        label.font="SF Pro:Medium:10.0" \
                        label.max_chars=20
