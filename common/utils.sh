#!/bin/bash

# Source colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to prompt user for yes/no input
prompt_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -p "$prompt (y/n): " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to prompt user for input
prompt_user() {
    local prompt="$1"
    local response
    read -p "$prompt: " response
    echo "$response"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

# Function to check if running on the correct OS
check_os() {
    local required_os="$1"
    local current_os=$(uname -s)
    
    if [ "$current_os" != "$required_os" ]; then
        print_error "This script must be run on $required_os"
        exit 1
    fi
}

# Function to create a backup of a file
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "${file}.bak"
        print_status "Created backup of $file"
    fi
}

# Function to restore a file from backup
restore_file() {
    local file="$1"
    if [ -f "${file}.bak" ]; then
        mv "${file}.bak" "$file"
        print_status "Restored $file from backup"
    fi
}

# Function to check if a directory exists and create it if it doesn't
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "Created directory: $dir"
    fi
}

# Function to check if a file exists and create it if it doesn't
ensure_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        touch "$file"
        print_status "Created file: $file"
    fi
}

# Function to append a line to a file if it doesn't exist
append_if_not_exists() {
    local file="$1"
    local line="$2"
    if ! grep -q "^$line$" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
        print_status "Added line to $file"
    fi
}

# Function to check if a package is installed (for apt)
is_package_installed() {
    local package="$1"
    dpkg -l "$package" 2>/dev/null | grep -q "^ii"
}

# Function to check if a package is installed (for brew)
is_brew_package_installed() {
    local package="$1"
    brew list "$package" &>/dev/null
}

# Function to check if a package is installed (for pacman)
is_pacman_package_installed() {
    local package="$1"
    pacman -Qi "$package" &>/dev/null
}

# Function to check if a package is installed (for dnf/yum)
is_dnf_package_installed() {
    local package="$1"
    rpm -q "$package" &>/dev/null
} 