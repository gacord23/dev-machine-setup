#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_vscode() {
    print_status "Installing VSCode..."
    if ! command_exists code; then
        brew install --cask visual-studio-code
    else
        print_status "VSCode already installed"
    fi
}

install_cursor() {
    print_status "Installing Cursor..."
    if ! command_exists cursor; then
        brew install --cask cursor
    else
        print_status "Cursor already installed"
    fi
}

install_webstorm() {
    print_status "Installing WebStorm..."
    if ! command_exists webstorm; then
        brew install --cask webstorm
    else
        print_status "WebStorm already installed"
    fi
}

install_lazyvim() {
    print_status "Installing LazyVim..."
    if ! command_exists nvim; then
        brew install neovim
    fi

    if [ ! -d ~/.config/nvim ]; then
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        print_status "LazyVim installed. Please run 'nvim' to complete the setup."
    else
        print_status "LazyVim already installed"
    fi
}

# Main execution
print_status "Select your preferred code editors (you can choose multiple):"
echo "1) VSCode"
echo "2) Cursor"
echo "3) WebStorm"
echo "4) LazyVim"
echo "5) None"
echo "Enter your choices as comma-separated numbers (e.g., 1,3,4):"
read -p "Your choices: " editor_choices

# Convert comma-separated input to array
IFS=',' read -ra EDITOR_ARRAY <<< "$editor_choices"

# Install selected editors
for choice in "${EDITOR_ARRAY[@]}"; do
    case $choice in
        1)
            install_vscode
            ;;
        2)
            install_cursor
            ;;
        3)
            install_webstorm
            ;;
        4)
            install_lazyvim
            ;;
        5)
            print_status "Skipping code editor installation"
            ;;
        *)
            print_error "Invalid choice: $choice"
            ;;
    esac
done

print_status "IDE setup complete!"
print_status "For LazyVim users:"
print_status "  - Run 'nvim' to complete the setup"
print_status "  - Wait for the plugins to install"
print_status "  - You may need to restart nvim after the initial setup" 