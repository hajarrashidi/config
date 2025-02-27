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

# Function to create a new app
create_new_app() {
    draw_box_top
    draw_centered_text "Create a New Application"
    draw_box_middle

    # Check if the apps directory exists, create if not
    if [ ! -d "$APPS_DIR" ]; then
        mkdir -p "$APPS_DIR"
        if [ $? -ne 0 ]; then
            draw_left_text "Error: Failed to create apps directory."
            draw_box_bottom
            echo "Press Enter to continue..."
            read -r
            return 1
        fi
        draw_left_text "Created apps directory: $APPS_DIR"
    fi

    # Prompt for app name
    local app_name=""
    while [ -z "$app_name" ]; do
        draw_left_text "Enter a name for your new app (letters, numbers, hyphens only):"
        draw_box_middle
        read -p "> " app_name

        # Validate app name (allow only letters, numbers, and hyphens)
        if ! [[ "$app_name" =~ ^[a-zA-Z0-9-]+$ ]]; then
            draw_left_text "Error: Invalid app name. Use only letters, numbers, and hyphens."
            app_name=""
            continue
        fi

        # Check if app already exists
        if [ -d "$APPS_DIR/$app_name" ]; then
            draw_left_text "Error: An app with this name already exists."
            app_name=""
            continue
        fi
    done

    # Create app directory
    mkdir -p "$APPS_DIR/$app_name"
    if [ $? -ne 0 ]; then
        draw_left_text "Error: Failed to create app directory."
        draw_box_bottom
        echo "Press Enter to continue..."
        read -r
        return 1
    fi

    # Create a simple hello world script
    cat > "$APPS_DIR/$app_name/$app_name.sh" << EOL
#!/bin/bash
# TITLE: $app_name App

# Print a welcome message
echo "Hello World from $app_name!"
echo "This is a custom app created by $(whoami) on $(date)"
echo ""
echo "You can customize this script at:"
echo "$APPS_DIR/$app_name/$app_name.sh"
EOL

    # Make the script executable
    chmod +x "$APPS_DIR/$app_name/$app_name.sh"
    if [ $? -ne 0 ]; then
        draw_left_text "Warning: Could not make script executable."
    fi

    # Success message
    draw_box_middle
    draw_left_text "✅ App '$app_name' created successfully!"
    draw_left_text "Location: $APPS_DIR/$app_name/$app_name.sh"
    draw_left_text "You can now run your app from the main menu."
    draw_box_bottom

    echo "Press Enter to continue..."
    read -r

    # Refresh app list
    refresh_app_list
    return 0
}

# Function to refresh the app list
refresh_app_list() {
    # Clear existing app lists
    APP_NAMES=()
    APP_SCRIPTS=()
    APP_TITLES=()

    # Rescan for app scripts
    for app_dir in "$APPS_DIR"/*; do
        if [ -d "$app_dir" ]; then
            app_name=$(basename "$app_dir")
            script="$app_dir/$app_name.sh"
            if [ -f "$script" ]; then
                chmod +x "$script" 2>/dev/null
                APP_NAMES+=("$app_name")
                APP_SCRIPTS+=("$script")
                APP_TITLES+=("$(extract_title "$script" "$app_name")")
            fi
        fi
    done
}

# Check if the apps directory exists
if [ ! -d "$APPS_DIR" ]; then
    mkdir -p "$APPS_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create $APPS_DIR."
        exit 1
    fi
    echo "Created apps directory: $APPS_DIR"
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

show_menu() {
    draw_box_top
    draw_centered_text "Available Applications"
    draw_box_middle

    # Show numbered apps
    for i in "${!APP_NAMES[@]}"; do
        draw_left_text "$(printf "%2d) %s" $((i + 1)) "${APP_TITLES[$i]}")"
    done

    # Add create new app option
    draw_box_middle
    draw_left_text "W) Create a new app"
    draw_left_text "Q) Quit"

    draw_box_bottom
    echo "Enter your choice (number, W to create a new app, or Q to quit):"
}

while true; do
    show_menu
    read -p "> " choice

    # Handle quit option
    if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
        echo "Exiting..."
        exit 0
    fi

    # Handle create new app option
    if [ "$choice" = "w" ] || [ "$choice" = "W" ]; then
        create_new_app
        continue
    fi

    # Handle numbered options
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid number, W, or Q."
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