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
