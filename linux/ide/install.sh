#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Source baseline utilities for package manager functions
source "$(dirname "$0")/../baseline/install.sh"

install_vscode() {
    print_status "Installing VSCode..."
    case $(detect_package_manager) in
        apt)
            curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
            sudo apt-get update
            sudo apt-get install -y code
            ;;
        dnf)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
            ;;
        pacman)
            sudo pacman -S --noconfirm code
            ;;
    esac
}

install_webstorm() {
    print_status "Installing WebStorm..."
    case $(detect_package_manager) in
        apt|dnf)
            sudo snap install webstorm --classic
            ;;
        pacman)
            sudo pacman -S --noconfirm webstorm
            ;;
    esac
}

install_lazyvim() {
    print_status "Installing LazyVim..."
    if ! command_exists nvim; then
        install_package neovim
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
echo "2) WebStorm"
echo "3) LazyVim"
echo "4) None"
echo "Enter your choices as comma-separated numbers (e.g., 1,3):"
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
            install_webstorm
            ;;
        3)
            install_lazyvim
            ;;
        4)
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