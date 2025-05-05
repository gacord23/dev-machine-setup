#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    print_status "Detected macOS"
    if [ -f "macos/setup-mac-dev-machine.sh" ]; then
        chmod +x "macos/setup-mac-dev-machine.sh"
        ./macos/setup-mac-dev-machine.sh
    else
        print_error "macOS setup script not found"
        exit 1
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    print_status "Detected Linux"
    if [ -f "linux/setup-linux-dev-machine.sh" ]; then
        chmod +x "linux/setup-linux-dev-machine.sh"
        ./linux/setup-linux-dev-machine.sh
    else
        print_error "Linux setup script not found"
        exit 1
    fi
else
    print_error "Unsupported operating system: $OSTYPE"
    print_error "Please use setup.ps1 for Windows"
    exit 1
fi 