#!/bin/bash

# MENU FUNCTIONS
# Function to display the main menu
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

# Function to run the main menu loop
# Function to run the main menu loop
run_menu() {
    while true; do
        clear
        draw_title_bar

        draw_box_top
        draw_centered_text "Main Menu"
        draw_box_middle

        # List available apps
        local index=1
        for title in "${APP_TITLES[@]}"; do
            draw_left_text "$index. $title"
            ((index++))
        done

        draw_box_middle
        draw_left_text "W. Create a new app"
        draw_left_text "A. Add 'config' alias"
        draw_left_text "R. Remove 'config' alias"
        draw_left_text "Q. Quit"
        draw_box_bottom

        read -p "> " choice

        case "$choice" in
            [1-9]|[1-9][0-9])
                # Convert to zero-based index
                local app_index=$((choice - 1))
                if [ "$app_index" -lt "${#APP_SCRIPTS[@]}" ]; then
                    run_app "${APP_SCRIPTS[$app_index]}"
                else
                    draw_error "Invalid selection. Please try again."
                    display_message
                fi
                ;;
            [Ww])
                create_new_app
                ;;
            [Aa])
                add_config_alias
                ;;
            [Rr])
                remove_config_alias
                ;;
            [Qq])
                clear
                exit 0
                ;;
            *)
                draw_error "Invalid selection. Please try again."
                display_message
                ;;
        esac
    done
}