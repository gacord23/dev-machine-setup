#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_vips() {
    print_status "Checking for Vips..."
    if ! command_exists vips; then
        print_status "Installing Vips..."
        brew install vips
        print_status "Linking Vips..."
        brew link vips
    else
        print_status "Vips already installed"
        # Ensure it's linked even if already installed
        print_status "Ensuring Vips is properly linked..."
        brew link vips
    fi
}

install_glib() {
    print_status "Checking for glib..."
    if ! command_exists glib-compile-resources; then
        print_status "Installing glib..."
        brew install glib
    else
        print_status "glib already installed"
    fi
}

# Main execution
install_vips
install_glib

print_status "Imaging tools setup complete!"
print_status "Please restart your terminal or run 'source ~/.zshrc' in a zsh shell to apply the new environment variables." 