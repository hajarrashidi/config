#!/bin/zsh
# TITLE: Helix Editor Configuration

# Function to print success message with green checkmark
print_success() {
    local text="$1"
    # Remove any trailing spaces from the input text
    text=$(echo "$text" | sed 's/[[:space:]]*$//')
    echo "✅ $text" | fold -s
}

# Function to print warning/error message with warning symbol
print_warning() {
    local text="$1"
    # Remove any trailing spaces from the input text
    text=$(echo "$text" | sed 's/[[:space:]]*$//')
    echo "⚠️ $text" | fold -s
}

# Function to print text, with proper wrapping (no emoji)
print_line() {
    local text="$1"
    # Remove any trailing spaces from the input text
    text=$(echo "$text" | sed 's/[[:space:]]*$//')
    # Simple output without borders
    echo "$text" | fold -s
}

# Function to print an empty line
print_empty() {
    echo ""
}

# Start of the output
print_line "Helix Configuration Script"

# Get the directory where this script is located
SCRIPT_DIR="$(dirname "$0")"

# Navigate to the script's directory
cd "$SCRIPT_DIR" || {
    print_warning "Error: Could not change to '$SCRIPT_DIR'"
    exit 1
}

# Ensure the ~/.config/helix directory exists
mkdir -p ~/.config/helix
if [ $? -eq 0 ]; then
    print_success "Ensured ~/.config/helix exists"
else
    print_warning "Failed to create ~/.config/helix directory"
    exit 1
fi

# Create theme.toml if it doesn't exist
THEME_FILE="theme.toml"
if [ ! -f "$THEME_FILE" ]; then
    cat > "$THEME_FILE" << 'EOL'
# Basic theme configuration
"ui.background" = { bg = "black" }
"ui.text" = { fg = "white" }
"ui.cursor" = { fg = "black", bg = "white" }
"ui.selection" = { bg = "#3b4261" }
"ui.statusline" = { fg = "white", bg = "#2d3343" }
"ui.linenr" = { fg = "#545c7e" }
EOL
    if [ $? -eq 0 ]; then
        print_success "Created default theme.toml"
    else
        print_warning "Failed to create theme.toml"
        exit 1
    fi
fi

# Copy theme.toml to ~/.config/helix/theme.toml
mkdir -p ~/.config/helix/themes
if [ $? -ne 0 ]; then
    print_warning "Failed to create ~/.config/helix/themes directory"
    exit 1
fi

cp "$THEME_FILE" ~/.config/helix/themes/theme.toml
if [ $? -eq 0 ]; then
    print_success "Copied theme.toml to ~/.config/helix/themes"
else
    print_warning "Error: Could not copy theme.toml to ~/.config/helix/themes"
    exit 1
fi

# Define the config file path
CONFIG_FILE=~/.config/helix/config.toml

# Check if config.toml exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo 'theme = "theme"' > "$CONFIG_FILE"
    if [ $? -eq 0 ]; then
        print_success "Created $CONFIG_FILE with theme = \"theme\""
    else
        print_warning "Failed to create $CONFIG_FILE"
        exit 1
    fi
else
    if grep -q "^theme\s*=\s*\".*\"$" "$CONFIG_FILE"; then
        sed -i '' 's/^theme\s*=\s*".*"/theme = "theme"/' "$CONFIG_FILE" 2>/dev/null ||
        sed -i 's/^theme\s*=\s*".*"/theme = "theme"/' "$CONFIG_FILE"
        if [ $? -eq 0 ]; then
            print_success "Updated theme to \"theme\" in $CONFIG_FILE"
        else
            print_warning "Failed to update theme in $CONFIG_FILE"
            exit 1
        fi
    else
        echo 'theme = "theme"' >> "$CONFIG_FILE"
        if [ $? -eq 0 ]; then
            print_success "Added theme = \"theme\" to $CONFIG_FILE"
        else
            print_warning "Failed to add theme setting to $CONFIG_FILE"
            exit 1
        fi
    fi
fi

print_empty
print_success "Helix configuration completed"