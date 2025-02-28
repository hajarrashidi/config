 #!/bin/bash

# UI FUNCTIONS

draw_title_bar() {
    local title="${1:-App Launcher}"
    local width="${2:-$TERMINAL_WIDTH}"

    printf "┌%s┐\n" "$(printf '─%.0s' $(seq 1 $((width-2))))"

    # Center the title
    local padding_width=$(( (width - 2 - ${#title}) / 2 ))
    local left_padding="$(printf ' %.0s' $(seq 1 $padding_width))"
    local right_padding="$left_padding"

    # Adjust for odd lengths
    if [ $(( (width - 2 - ${#title}) % 2 )) -ne 0 ]; then
        right_padding="$right_padding "
    fi

    printf "│%s%s%s│\n" "$left_padding" "$title" "$right_padding"
    printf "└%s┘\n" "$(printf '─%.0s' $(seq 1 $((width-2))))"
}

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

# Function to display a message and wait for Enter
display_message() {
    echo "Press Enter to continue..."
    read -r
}