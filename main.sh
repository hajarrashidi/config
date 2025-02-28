#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Get the project root directory using git (if available) or fallback to script location
get_project_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        dirname "$(readlink -f "${BASH_SOURCE[0]}")"
    fi
}

# Initialize essential variables
readonly PROJECT_ROOT="$(get_project_root)"
readonly SCRIPT_DIR="${PROJECT_ROOT}/scripts"
readonly LOG_DIR="${PROJECT_ROOT}/logs"
readonly LOG_FILE="${LOG_DIR}/app_launcher.log"

# Define the apps directory relative to main.sh's location
readonly MAIN_DIR="$(dirname "$(readlink -f "$0")")"
readonly APPS_DIR="${MAIN_DIR}/apps"
readonly CONFIG_DIR="${APPS_DIR}/config"

# Set a fixed width for the terminal output
readonly TERMINAL_WIDTH=80

# Arrays to store app information
APP_NAMES=()
APP_SCRIPTS=()
APP_TITLES=()

# Create logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[${timestamp}] [${level}] ${message}" | tee -a "$LOG_FILE"
}

# Function to check if required directories exist
check_requirements() {
    # Create log directory if it doesn't exist
    if [[ ! -d "$LOG_DIR" ]]; then
        mkdir -p "$LOG_DIR"
    fi
}

# Source component files
source "${CONFIG_DIR}/ui_functions.sh"
source "${CONFIG_DIR}/app_config.sh"
source "${CONFIG_DIR}/app_management.sh"
source "${CONFIG_DIR}/alias_setup.sh"
source "${CONFIG_DIR}/menu_functions.sh"

# Function to check if alias is configured
is_alias_configured() {
    if [[ -f "${HOME}/.bash_aliases" ]] && grep -q "# App Launcher Alias" "${HOME}/.bash_aliases"; then
        return 0  # True
    else
        return 1  # False
    fi
}

# Function to check if zsh alias is configured (for macOS)
is_zsh_alias_configured() {
    if [[ -f "${HOME}/.zshrc" ]] && grep -q "# App Launcher Alias" "${HOME}/.zshrc"; then
        return 0  # True
    else
        return 1  # False
    fi
}

# Function to remove zsh alias configuration
remove_zsh_alias() {
    if is_zsh_alias_configured; then
        # Create a temporary file
        local temp_file=$(mktemp)
        
        # Filter out the App Launcher Alias section
        grep -v "# App Launcher Alias" "${HOME}/.zshrc" > "$temp_file"
        
        # Replace the original file
        mv "$temp_file" "${HOME}/.zshrc"
        
        log "INFO" "Removed App Launcher alias from .zshrc"
        return 0
    else
        log "INFO" "No App Launcher alias found in .zshrc"
        return 1
    fi
}

# Initialize the application
init_application() {
    log "INFO" "Initializing App Launcher..."
    log "INFO" "Configuration loaded successfully"
}

# Main execution
main() {
    # Check requirements before proceeding
    check_requirements

    # Initialize the application
    init_application

    # Display welcome message
    log "INFO" "Welcome to the App Launcher"
    log "INFO" "Scanning ${APPS_DIR} for app scripts..."

    # Initialize apps directory (with error handling)
    if ! initialize_apps_dir; then
        log "ERROR" "Failed to initialize apps directory"
        exit 1
    fi

    # Scan for app scripts (with error handling)
    if ! refresh_app_list; then
        log "ERROR" "Failed to refresh app list"
        exit 1
    fi

    log "INFO" "Found ${#APP_NAMES[@]:-0} apps"

    # Run the main menu (with error handling)
    if ! run_menu; then
        log "ERROR" "Menu system encountered an error"
        exit 1
    fi
}

# Call main function
main "$@"