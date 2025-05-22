#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Source baseline utilities for package manager functions
source "$(dirname "$0")/../baseline/install.sh"

install_nerd_fonts() {
    print_status "Installing Nerd Fonts..."
    
    # Check if we're on a Debian-based system
    if command_exists apt-get; then
        if ! dpkg -l | grep -q fonts-nerd-font; then
            print_status "Installing MesloLGM Nerd Font..."
            sudo apt-get update
            sudo apt-get install -y fonts-nerd-font-meslo
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

install_vscode() {
    print_status "Checking for VSCode..."
    if ! command_exists code; then
        print_status "Installing VSCode..."
        if command_exists apt-get; then
            # Debian/Ubuntu
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            sudo apt-get update
            sudo apt-get install -y code
            rm packages.microsoft.gpg
        elif command_exists dnf; then
            # Fedora/RHEL
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf install -y code
        elif command_exists pacman; then
            # Arch Linux
            sudo pacman -S --noconfirm code
        else
            print_warning "Could not determine package manager for VSCode installation"
        fi
    else
        print_status "VSCode already installed"
    fi
}

install_cursor() {
    print_status "Checking for Cursor..."
    if ! command_exists cursor; then
        print_status "Installing Cursor..."
        if command_exists apt-get; then
            # Debian/Ubuntu
            print_status "Downloading Cursor AppImage..."
            wget https://download.cursor.sh/linux/appImage/x64/cursor-latest.AppImage -O /tmp/cursor.AppImage
            chmod +x /tmp/cursor.AppImage
            sudo mv /tmp/cursor.AppImage /usr/local/bin/cursor
            print_status "Cursor installed successfully"
        elif command_exists dnf; then
            # Fedora/RHEL
            print_status "Downloading Cursor AppImage..."
            wget https://download.cursor.sh/linux/appImage/x64/cursor-latest.AppImage -O /tmp/cursor.AppImage
            chmod +x /tmp/cursor.AppImage
            sudo mv /tmp/cursor.AppImage /usr/local/bin/cursor
            print_status "Cursor installed successfully"
        elif command_exists pacman; then
            # Arch Linux
            yay -S --noconfirm cursor
        else
            print_warning "Could not determine package manager for Cursor installation"
        fi
    else
        print_status "Cursor already installed"
    fi
}

install_webstorm() {
    print_status "Checking for WebStorm..."
    if ! command_exists webstorm; then
        print_status "Installing WebStorm..."
        if command_exists snap; then
            sudo snap install webstorm --classic
        else
            print_warning "Snap not available. Please install WebStorm manually from https://www.jetbrains.com/webstorm/download/"
        fi
    else
        print_status "WebStorm already installed"
    fi
}

install_intellij() {
    print_status "Checking for IntelliJ IDEA..."
    if ! command_exists idea; then
        print_status "Installing IntelliJ IDEA..."
        if command_exists snap; then
            sudo snap install intellij-idea-community --classic
        else
            print_warning "Snap not available. Please install IntelliJ IDEA manually from https://www.jetbrains.com/idea/download/"
        fi
    else
        print_status "IntelliJ IDEA already installed"
    fi
}

install_pycharm() {
    print_status "Checking for PyCharm..."
    if ! command_exists pycharm; then
        print_status "Installing PyCharm..."
        if command_exists snap; then
            sudo snap install pycharm-community --classic
        else
            print_warning "Snap not available. Please install PyCharm manually from https://www.jetbrains.com/pycharm/download/"
        fi
    else
        print_status "PyCharm already installed"
    fi
}

install_sublime_text() {
    print_status "Checking for Sublime Text..."
    if ! command_exists subl; then
        print_status "Installing Sublime Text..."
        if command_exists apt-get; then
            # Debian/Ubuntu
            wget -qO- https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt-get update
            sudo apt-get install -y sublime-text
        elif command_exists dnf; then
            # Fedora/RHEL
            sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo dnf install -y sublime-text
        elif command_exists pacman; then
            # Arch Linux
            sudo pacman -S --noconfirm sublime-text
        else
            print_warning "Could not determine package manager for Sublime Text installation"
        fi
    else
        print_status "Sublime Text already installed"
    fi
}

install_lazyvim_dependencies() {
    print_status "Installing LazyVim dependencies..."
    
    # Install ripgrep
    if ! command_exists rg; then
        print_status "Installing ripgrep..."
        if command_exists apt-get; then
            sudo apt-get install -y ripgrep
        elif command_exists dnf; then
            sudo dnf install -y ripgrep
        elif command_exists pacman; then
            sudo pacman -S --noconfirm ripgrep
        fi
    fi
    
    # Install fd
    if ! command_exists fd; then
        print_status "Installing fd..."
        if command_exists apt-get; then
            sudo apt-get install -y fd-find
            sudo ln -s $(which fdfind) /usr/local/bin/fd
        elif command_exists dnf; then
            sudo dnf install -y fd-find
        elif command_exists pacman; then
            sudo pacman -S --noconfirm fd
        fi
    fi
    
    # Install fzf
    if ! command_exists fzf; then
        print_status "Installing fzf..."
        if command_exists apt-get; then
            sudo apt-get install -y fzf
        elif command_exists dnf; then
            sudo dnf install -y fzf
        elif command_exists pacman; then
            sudo pacman -S --noconfirm fzf
        fi
        # Install fzf key bindings and fuzzy completion
        $(which fzf)/install --key-bindings --completion --no-update-rc
    fi
    
    # Install lazygit
    if ! command_exists lazygit; then
        print_status "Installing lazygit..."
        if command_exists apt-get; then
            sudo apt-get install -y lazygit
        elif command_exists dnf; then
            sudo dnf install -y lazygit
        elif command_exists pacman; then
            sudo pacman -S --noconfirm lazygit
        fi
    fi
    
    # Install tree-sitter
    if ! command_exists tree-sitter; then
        print_status "Installing tree-sitter..."
        if command_exists apt-get; then
            sudo apt-get install -y tree-sitter
        elif command_exists dnf; then
            sudo dnf install -y tree-sitter
        elif command_exists pacman; then
            sudo pacman -S --noconfirm tree-sitter
        fi
    fi
}

install_lazyvim() {
    print_status "Checking for Neovim..."
    if ! command_exists nvim; then
        print_status "Installing Neovim..."
        if command_exists apt-get; then
            sudo apt-get install -y neovim
        elif command_exists dnf; then
            sudo dnf install -y neovim
        elif command_exists pacman; then
            sudo pacman -S --noconfirm neovim
        fi
    else
        print_status "Neovim already installed"
    fi
    
    # Install LazyVim dependencies
    install_lazyvim_dependencies
    
    # Check if LazyVim is already installed
    if [ ! -d "$HOME/.config/nvim" ]; then
        print_status "Installing LazyVim..."
        # Backup existing Neovim config if it exists
        if [ -d "$HOME/.config/nvim" ]; then
            mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
        fi
        
        # Clone LazyVim starter
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
    else
        print_status "LazyVim already installed"
    fi
}

# Main execution
print_status "Starting IDE installation..."

# Install Nerd Fonts first
install_nerd_fonts

# Get user selections
echo -e "\n${BOLD}Select IDEs and code editors to install:${NC}"
echo "1) VSCode"
echo "2) Cursor"
echo "3) WebStorm"
echo "4) LazyVim"
echo "5) IntelliJ IDEA"
echo "6) PyCharm"
echo "7) Sublime Text"
echo "8) All"
echo

read -p "Enter your choices (comma-separated, e.g., 1,3,4): " choices

# Process choices
IFS=',' read -ra selected <<< "$choices"
for choice in "${selected[@]}"; do
    case "$choice" in
        1) install_vscode ;;
        2) install_cursor ;;
        3) install_webstorm ;;
        4) install_lazyvim ;;
        5) install_intellij ;;
        6) install_pycharm ;;
        7) install_sublime_text ;;
        8)
            install_vscode
            install_cursor
            install_webstorm
            install_lazyvim
            install_intellij
            install_pycharm
            install_sublime_text
            ;;
        *)
            print_warning "Invalid choice: $choice"
            ;;
    esac
done

print_status "IDE installation complete!" 