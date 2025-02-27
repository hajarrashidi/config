#!/bin/bash

# Define the apps directory relative to main.sh's location
APPS_DIR="$(dirname "$0")/apps"

# Set a fixed width for the terminal output
TERMINAL_WIDTH=80

# Function to draw a box border
draw_box_top() {
    printf "┌%s┐\n" "$(printf '─%.0s' $(seq 1 $((TERMINAL_WIDTH-2))))"
}

draw_box_bottom() {
    printf "└%s┘\n" "$(printf '─%.0s' $(seq 1 $((TERMINAL_WIDTH-2))))"
}

draw_box_middle() {
    printf "├%s┤\n" "$(printf '─%.0s' $(seq 1 $((TERMINAL_WIDTH-2))))"
}

draw_centered_text() {
    local text="$1"
    local padding_width=$(( (TERMINAL_WIDTH - 2 - ${#text}) / 2 ))
    local left_padding="$(printf ' %.0s' $(seq 1 $padding_width))"
    local right_padding="$left_padding"

    # Adjust for odd lengths
    if [ $(( (TERMINAL_WIDTH - 2 - ${#text}) % 2 )) -ne 0 ]; then
        right_padding="$right_padding "
    fi

    printf "│%s%s%s│\n" "$left_padding" "$text" "$right_padding"
}

draw_left_text() {
    local text="$1"
    local remaining_width=$((TERMINAL_WIDTH - 3 - ${#text}))
    local right_padding="$(printf ' %.0s' $(seq 1 $remaining_width))"
    printf "│ %s%s│\n" "$text" "$right_padding"
}

# Function to extract title from app script
extract_title() {
    local script_path="$1"
    local app_name="$2"
    local title

    # Try to extract title from the script file
    title=$(grep -i "^# TITLE:" "$script_path" | sed 's/^# TITLE:[[:space:]]*//')

    # If no title found, use app name as fallback
    if [ -z "$title" ]; then
        title="$app_name"
    fi

    echo "$title"
}

# Check if the apps directory exists
if [ ! -d "$APPS_DIR" ]; then
    echo "Error: $APPS_DIR does not exist."
    exit 1
fi

# Use arrays instead of associative arrays for compatibility
APP_NAMES=()
APP_SCRIPTS=()
APP_TITLES=()

echo "Scanning $APPS_DIR for app scripts..."
for app_dir in "$APPS_DIR"/*; do
    if [ -d "$app_dir" ]; then
        app_name=$(basename "$app_dir")
        script="$app_dir/$app_name.sh"
        if [ -f "$script" ]; then
            echo "Found script: $script"
            chmod +x "$script" || {
                echo "Warning: Could not make $script executable."
                continue
            }
            APP_NAMES+=("$app_name")
            APP_SCRIPTS+=("$script")
            APP_TITLES+=("$(extract_title "$script" "$app_name")")
        fi
    fi
done

if [ ${#APP_NAMES[@]} -eq 0 ]; then
    echo "No app scripts found in $APPS_DIR."
    exit 1
fi

show_menu() {
    draw_box_top
    draw_centered_text "Available Applications"
    draw_box_middle
    for i in "${!APP_NAMES[@]}"; do
        draw_left_text "$(printf "%2d) %s" $((i + 1)) "${APP_TITLES[$i]}")"
    done
    draw_box_bottom
    echo "Enter the number of the app to run (or 'q' to quit):"
}

while true; do
    show_menu
    read -p "> " choice
    if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
        echo "Exiting..."
        exit 0
    fi
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid number or 'q'."
        continue
    fi
    choice=$((choice - 1)) # Convert to 0-based index
    if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#APP_NAMES[@]}" ]; then
        echo "Error: Choice out of range. Pick a number between 1 and ${#APP_NAMES[@]}."
        continue
    fi

    selected_name="${APP_NAMES[$choice]}"
    selected_script="${APP_SCRIPTS[$choice]}"
    selected_title="${APP_TITLES[$choice]}"

    # Display execution header
    draw_box_top
    draw_centered_text "Running $selected_title"
    draw_box_middle

    # Capture the output of the script
    output=$("$selected_script")

    # Display the output with proper formatting
    IFS=$'\n'
    for line in $output; do
        draw_left_text "$line"
    done
    unset IFS

    # Display execution footer
    draw_box_middle
    draw_centered_text "$selected_title execution completed"
    draw_box_bottom

    echo "Press Enter to continue..."
    read -r
done