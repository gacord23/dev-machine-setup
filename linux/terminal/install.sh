#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Source baseline utilities for package manager functions
source "$(dirname "$0")/../baseline/install.sh"

install_terminator() {
    print_status "Installing Terminator..."
    install_package terminator
}

install_kitty() {
    print_status "Installing Kitty..."
    case $(detect_package_manager) in
        apt)
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
            ;;
        dnf)
            sudo dnf install -y kitty
            ;;
        pacman)
            sudo pacman -S --noconfirm kitty
            ;;
    esac
}

install_gnome_terminal() {
    print_status "Installing GNOME Terminal..."
    case $(detect_package_manager) in
        apt)
            install_package gnome-terminal
            ;;
        dnf)
            install_package gnome-terminal
            ;;
        pacman)
            install_package gnome-terminal
            ;;
    esac
}

configure_zsh() {
    print_status "Configuring zsh..."
    if ! command_exists zsh; then
        install_package zsh
    fi

    if [ ! -d ~/.oh-my-zsh ]; then
        print_status "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

        # Install zsh-autosuggestions
        if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        fi

        # Install zsh-syntax-highlighting
        if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        fi

        # Update .zshrc with plugins
        if [ -f ~/.zshrc ]; then
            sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
        fi
    else
        print_status "oh-my-zsh already installed"
    fi
}

# Main execution
print_status "Select your preferred terminal:"
echo "1) Terminator"
echo "2) Kitty"
echo "3) GNOME Terminal"
echo "4) None"
read -p "Your choice (1-4): " terminal_choice

case $terminal_choice in
    1)
        install_terminator
        ;;
    2)
        install_kitty
        ;;
    3)
        install_gnome_terminal
        ;;
    4)
        print_status "Skipping terminal installation"
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

# Ask about zsh configuration
read -p "Would you like to configure zsh with oh-my-zsh? (y/n): " configure_zsh_choice
if [[ $configure_zsh_choice =~ ^[Yy]$ ]]; then
    configure_zsh
fi

print_status "Terminal setup complete!"
print_status "Next steps:"
print_status "  - If you installed a new terminal, you may need to log out and back in"
print_status "  - If you configured zsh, you may need to run 'chsh -s $(which zsh)' to set it as your default shell"
print_status "  - After setting zsh as default, log out and back in for changes to take effect" 