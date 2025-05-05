#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_xcode() {
    print_status "Checking for Xcode Command Line Tools..."
    if ! command_exists xcode-select; then
        print_status "Installing Xcode Command Line Tools..."
        xcode-select --install
    else
        print_status "Xcode Command Line Tools already installed"
    fi
}

install_homebrew() {
    print_status "Checking for Homebrew..."
    if ! command_exists brew; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        print_status "Homebrew already installed"
    fi
}

install_volta() {
    print_status "Installing Volta..."
    if ! command_exists volta; then
        curl https://get.volta.sh | bash
        source ~/.zshrc
    else
        print_status "Volta already installed"
    fi
}

# Main execution
install_xcode
install_homebrew
install_volta

print_status "Baseline setup complete!"
print_status "Please ensure Xcode Command Line Tools installation is complete before proceeding with other components." 