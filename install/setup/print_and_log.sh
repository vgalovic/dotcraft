#!/bin/bash

LOG_FILE="$HOME/.dotfiles/install/output.log"

# Function to print messages in color to the terminal and log them with a timestamp
print_msg() {
    local msg="$1"
    # Print in color to the terminal
    echo -e "\e[1;32m$msg\e[0m"
    # Add timestamp and log to file
    local timestamp
    timestamp=$(date "+%d.%m.%Y. %H:%M:%S")  # Current timestamp
    echo "[$timestamp] $msg" >> "$LOG_FILE"
}

# Function to print warning messages in color
print_warning() {
    local msg="$1"
    echo -e "\e[1;33mWarning: $msg\e[0m"
    # Add timestamp and log to file
    local timestamp
    timestamp=$(date "+%d.%m.%Y. %H:%M:%S")  # Current timestamp
    echo "[$timestamp] Warning: $msg" >> "$LOG_FILE"
}

# Function to print error messages in color to the terminal and log them with a timestamp
print_error() {
    local msg="$1"
    # Print in color to the terminal
    echo -e "\e[1;31mError: $msg\e[0m"
    # Add timestamp and log to file
    local timestamp
    timestamp=$(date "+%d.%m.%Y. %H:%M:%S")  # Current timestamp
    echo "[$timestamp] Error: $msg" >> "$LOG_FILE"
}

# Function for a user prompt defaulting to 'Yes'
prompt_yes_default() {
    local prompt="$1"
    local choice
    read -p "$prompt (Y/n): " choice
    [[ -z "$choice" || "${choice,,}" == "y" ]]
}

# Function to run a setup script without prompting
must_execute_script() {
    local script="$1"
    print_msg "Running $script..."
    if [ -x "$SETUP_DIR/$script.sh" ]; then
        if "$SETUP_DIR/$script.sh"; then
            print_msg "Successfully ran $script_name."
        else
            print_error "Failed to run $script_name."
        fi
    else
        print_error "$script is not executable or not found."
    fi
}

# Function to execute a script with a user prompt
execute_script() {
    local script="$1"
    if prompt_yes_default "Do you want to run $script?"; then
        if "$SETUP_DIR/$script.sh"; then
            print_msg "Successfully ran $script."
        else
            print_error "Failed to run $script."
        fi
    else
        print_msg "Skipping execution of $script."
    fi
}
