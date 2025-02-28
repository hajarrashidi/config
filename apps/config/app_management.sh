 #!/bin/bash

# APP MANAGEMENT FUNCTIONS
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
            display_message
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
        display_message
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

    display_message

    # Refresh app list
    refresh_app_list
    return 0
}