 #!/bin/bash

# CONFIG FUNCTIONS
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

# Function to refresh the app list
refresh_app_list() {
    # Clear existing app lists
    APP_NAMES=()
    APP_SCRIPTS=()
    APP_TITLES=()

    # Rescan for app scripts, ignoring "config" folders
    for app_dir in "$APPS_DIR"/*; do
        if [ -d "$app_dir" ]; then
            app_name=$(basename "$app_dir")

            # Skip if the folder is named "config"
            if [ "$app_name" = "config" ]; then
                continue
            fi

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

# Initialize the apps directory if it doesn't exist
initialize_apps_dir() {
    if [ ! -d "$APPS_DIR" ]; then
        mkdir -p "$APPS_DIR"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create $APPS_DIR."
            return 1
        fi
        echo "Created apps directory: $APPS_DIR"
    fi
    return 0
}