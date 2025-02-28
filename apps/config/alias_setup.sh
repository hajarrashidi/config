#!/bin/bash

# Function to add the "config" command alias in ZSH
add_config_alias() {
    # Get the absolute path to the main script
    MAIN_SCRIPT="$MAIN_DIR/main.sh"

    # Check if alias already exists in .zshrc
    if grep -q "alias config=" ~/.zshrc; then
        draw_box_top
        draw_centered_text "Config Alias Setup"
        draw_box_middle
        draw_left_text "The 'config' alias already exists in your .zshrc file."
        draw_box_bottom
        display_message
        return 0
    fi

    # Add the alias to the user's .zshrc file
    echo "# Added by main.sh on $(date)" >> ~/.zshrc
    echo "alias config='$MAIN_SCRIPT'" >> ~/.zshrc

    draw_box_top
    draw_centered_text "Config Command Setup"
    draw_box_middle
    draw_left_text "✅ The 'config' command has been added to your .zshrc file."
    draw_left_text "After restarting your terminal or running 'source ~/.zshrc',"
    draw_left_text "you can use the 'config' command from anywhere to run this script."
    draw_box_middle
    draw_left_text "Do you want to apply the change now? (y/n)"
    draw_box_bottom

    read -p "> " apply_now

    if [[ "$apply_now" =~ ^[Yy] ]]; then
        source ~/.zshrc 2>/dev/null || {
            draw_box_top
            draw_left_text "Note: Couldn't apply changes automatically."
            draw_left_text "Please run this command to apply changes:"
            draw_left_text "source ~/.zshrc"
            draw_box_bottom
        }
    else
        draw_box_top
        draw_left_text "You can apply the changes later by restarting your terminal"
        draw_left_text "or running this command: source ~/.zshrc"
        draw_box_bottom
    fi

    display_message
}

# Function to set up the "config" command alias in ZSH
setup_config_alias() {
    add_config_alias
}

# Check if the alias is already set up
check_and_setup_alias() {
    # Only set up the alias if the script is being executed directly (not sourced)
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        # Check if the alias exists in .zshrc
        if ! grep -q "alias config=" ~/.zshrc 2>/dev/null; then
            # Ask user if they want to set up the alias
            draw_box_top
            draw_centered_text "Config Command Setup"
            draw_box_middle
            draw_left_text "Would you like to set up a 'config' command to run this script"
            draw_left_text "from anywhere in the terminal? (y/n)"
            draw_box_bottom

            read -p "> " setup_cmd

            if [[ "$setup_cmd" =~ ^[Yy] ]]; then
                setup_config_alias
            fi
        fi
    fi
}

# Function to remove the "config" command alias
remove_config_alias() {
    local zsh_removed=false
    local bash_removed=false

    # Remove from .zshrc if it exists
    if grep -q "alias config=" ~/.zshrc 2>/dev/null; then
        # Create a temporary file
        local temp_file=$(mktemp)

        # Filter out the config alias line
        grep -v "alias config=" ~/.zshrc > "$temp_file"

        # Also remove the comment that was added with it
        grep -v "# Added by main.sh" "$temp_file" > ~/.zshrc

        # Clean up
        rm "$temp_file"
        zsh_removed=true
    fi

    # Remove from .bashrc or .bash_aliases if they exist
    for bash_file in ~/.bashrc ~/.bash_aliases; do
        if [[ -f "$bash_file" ]] && grep -q "alias config=" "$bash_file" 2>/dev/null; then
            # Create a temporary file
            local temp_file=$(mktemp)

            # Filter out the config alias line
            grep -v "alias config=" "$bash_file" > "$temp_file"

            # Also remove the comment that was added with it
            grep -v "# Added by main.sh" "$temp_file" > "$bash_file"

            # Clean up
            rm "$temp_file"
            bash_removed=true
        fi
    done

    # Display results
    draw_box_top
    draw_centered_text "Config Alias Removal"
    draw_box_middle

    if $zsh_removed || $bash_removed; then
        draw_left_text "✅ The 'config' alias has been removed from your shell configuration."
        draw_left_text "Changes will take effect after restarting your terminal or running:"
        draw_left_text "source ~/.zshrc (for Zsh users)"
        draw_left_text "source ~/.bashrc (for Bash users)"
    else
        draw_left_text "No 'config' alias was found in your shell configurations."
    fi

    draw_box_bottom
    display_message
}