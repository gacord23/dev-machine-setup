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

    # Install thefuck
    print_status "Installing thefuck..."
    if command_exists apt-get; then
        sudo apt-get install -y python3-dev python3-pip python3-setuptools
        sudo pip3 install thefuck
    elif command_exists dnf; then
        sudo dnf install -y python3-devel python3-pip python3-setuptools
        sudo pip3 install thefuck
    elif command_exists pacman; then
        sudo pacman -S --noconfirm python-pip
        sudo pip install thefuck
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

        # Update .zshrc with plugins and thefuck
        if [ -f ~/.zshrc ]; then
            # Add thefuck alias
            echo 'eval $(thefuck --alias)' >> ~/.zshrc
            # Update plugins
            sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting thefuck)/' ~/.zshrc
        fi
    else
        print_status "oh-my-zsh already installed"
        # Add thefuck alias if not already present
        if ! grep -q "thefuck --alias" ~/.zshrc; then
            echo 'eval $(thefuck --alias)' >> ~/.zshrc
        fi
        # Add thefuck to plugins if not already present
        if ! grep -q "thefuck" ~/.zshrc; then
            sed -i 's/plugins=(git/plugins=(git thefuck/' ~/.zshrc
        fi
    fi
}

install_nerd_fonts() {
    print_status "Installing Nerd Fonts..."
    
    # Check if we're on a Debian-based system
    if command_exists apt-get; then
        if ! dpkg -l | grep -q fonts-nerd-font; then
            print_status "Installing MesloLGM Nerd Font..."
            sudo apt-get update
            sudo apt-get install -y fonts-nerd-font
        else
            print_status "Nerd Fonts already installed"
        fi
    # Check if we're on a Red Hat-based system
    elif command_exists dnf; then
        if ! rpm -q nerd-fonts-meslo; then
            print_status "Installing MesloLGM Nerd Font..."
            sudo dnf install -y nerd-fonts-meslo
        else
            print_status "Nerd Fonts already installed"
        fi
    # Check if we're on an Arch-based system
    elif command_exists pacman; then
        if ! pacman -Q nerd-fonts-meslo; then
            print_status "Installing MesloLGM Nerd Font..."
            sudo pacman -S --noconfirm nerd-fonts-meslo
        else
            print_status "Nerd Fonts already installed"
        fi
    else
        print_warning "Could not determine package manager for Nerd Fonts installation"
    fi
}

install_konsole() {
    print_status "Checking for Konsole..."
    if ! command_exists konsole; then
        print_status "Installing Konsole..."
        if command_exists apt-get; then
            sudo apt-get install -y konsole
        elif command_exists dnf; then
            sudo dnf install -y konsole
        elif command_exists pacman; then
            sudo pacman -S --noconfirm konsole
        fi
    else
        print_status "Konsole already installed"
    fi
    
    # Configure Konsole to use MesloLGM Nerd Font
    if [ -f "$HOME/.config/konsolerc" ]; then
        print_status "Configuring Konsole font..."
        sed -i 's/Font=.*/Font=MesloLGM Nerd Font,12,-1,5,50,0,0,0,0,0/' "$HOME/.config/konsolerc"
    fi
}

install_alacritty() {
    print_status "Checking for Alacritty..."
    if ! command_exists alacritty; then
        print_status "Installing Alacritty..."
        if command_exists apt-get; then
            sudo apt-get install -y alacritty
        elif command_exists dnf; then
            sudo dnf install -y alacritty
        elif command_exists pacman; then
            sudo pacman -S --noconfirm alacritty
        fi
    else
        print_status "Alacritty already installed"
    fi
    
    # Configure Alacritty to use MesloLGM Nerd Font
    mkdir -p "$HOME/.config/alacritty"
    cat > "$HOME/.config/alacritty/alacritty.yml" << EOF
font:
  normal:
    family: "MesloLGM Nerd Font"
    style: Regular
  size: 12.0
EOF
}

# Main execution
print_status "Starting terminal emulator installation..."

# Install Nerd Fonts first
install_nerd_fonts

# Get user selections
echo -e "\n${BOLD}Select terminal emulator to install:${NC}"
echo "1) GNOME Terminal"
echo "2) Konsole"
echo "3) Alacritty"
echo "4) Kitty"
echo "5) All"
echo

read -p "Enter your choices (comma-separated, e.g., 1,3): " choices

# Process choices
IFS=',' read -ra selected <<< "$choices"
for choice in "${selected[@]}"; do
    case "$choice" in
        1) install_gnome_terminal ;;
        2) install_konsole ;;
        3) install_alacritty ;;
        4) install_kitty ;;
        5)
            install_gnome_terminal
            install_konsole
            install_alacritty
            install_kitty
            ;;
        *)
            print_warning "Invalid choice: $choice"
            ;;
    esac
done

print_status "Terminal emulator installation complete!"
print_status "Next steps:"
print_status "  - For Alacritty/Kitty: The configuration files have been created in ~/.config/"

# Ask about zsh configuration
read -p "Would you like to configure zsh with oh-my-zsh? (y/n): " configure_zsh_choice
if [[ $configure_zsh_choice =~ ^[Yy]$ ]]; then
    configure_zsh
    print_status "Reloading shell to apply changes..."
    exec zsh
else
    print_status "Terminal setup complete!"
    print_status "Next steps:"
    print_status "  - If you installed a new terminal, you may need to log out and back in"
    print_status "  - If you configured zsh, you may need to run 'chsh -s $(which zsh)' to set it as your default shell"
    print_status "  - After setting zsh as default, log out and back in for changes to take effect"
fi 