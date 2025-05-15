#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_nerd_fonts() {
    print_status "Installing Nerd Fonts..."
    
    # Install MesloLGM Nerd Font
    if ! brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        print_status "Installing MesloLGM Nerd Font..."
        brew tap homebrew/cask-fonts
        brew install --cask font-meslo-lg-nerd-font
    else
        print_status "MesloLGM Nerd Font already installed"
    fi
}

configure_terminal() {
    print_status "Configuring Terminal.app..."
    
    # Get the path to the MesloLGM Nerd Font
    FONT_PATH="/Library/Fonts/MesloLGMNerdFont-Regular.ttf"
    
    if [ -f "$FONT_PATH" ]; then
        # Create a temporary plist file with the desired settings
        cat > /tmp/terminal_settings.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Font</key>
    <data>
        $(base64 -i "$FONT_PATH")
    </data>
    <key>FontAntialias</key>
    <true/>
    <key>FontWidthSpacing</key>
    <real>1.0</real>
    <key>ProfileCurrentVersion</key>
    <real>2.08</real>
    <key>Shell</key>
    <string>/bin/zsh</string>
    <key>TerminalType</key>
    <string>xterm-256color</string>
    <key>WindowSettings</key>
    <dict>
        <key>TitleBits</key>
        <integer>7</integer>
    </dict>
</dict>
</plist>
EOF
        
        # Apply the settings to Terminal.app
        defaults write com.apple.Terminal "Startup Window Settings" -string "MesloLGMNerdFont"
        defaults write com.apple.Terminal "Default Window Settings" -string "MesloLGMNerdFont"
        defaults import com.apple.Terminal /tmp/terminal_settings.plist
        
        # Clean up
        rm /tmp/terminal_settings.plist
        
        print_status "Terminal.app configured to use MesloLGM Nerd Font"
    else
        print_warning "MesloLGM Nerd Font not found at $FONT_PATH"
    fi
}

install_vscode() {
    print_status "Checking for VSCode..."
    if ! command_exists code; then
        print_status "Installing VSCode..."
        brew install --cask visual-studio-code
    else
        print_status "VSCode already installed"
    fi
}

install_cursor() {
    print_status "Checking for Cursor..."
    if ! command_exists cursor; then
        print_status "Installing Cursor..."
        brew install --cask cursor
    else
        print_status "Cursor already installed"
    fi
}

install_webstorm() {
    print_status "Checking for WebStorm..."
    if ! command_exists webstorm; then
        print_status "Installing WebStorm..."
        brew install --cask webstorm
    else
        print_status "WebStorm already installed"
    fi
}

install_intellij() {
    print_status "Checking for IntelliJ IDEA..."
    if ! command_exists idea; then
        print_status "Installing IntelliJ IDEA..."
        brew install --cask intellij-idea
    else
        print_status "IntelliJ IDEA already installed"
    fi
}

install_pycharm() {
    print_status "Checking for PyCharm..."
    if ! command_exists pycharm; then
        print_status "Installing PyCharm..."
        brew install --cask pycharm
    else
        print_status "PyCharm already installed"
    fi
}

install_sublime_text() {
    print_status "Checking for Sublime Text..."
    if ! command_exists subl; then
        print_status "Installing Sublime Text..."
        brew install --cask sublime-text
    else
        print_status "Sublime Text already installed"
    fi
}

install_lazyvim_dependencies() {
    print_status "Installing LazyVim dependencies..."
    
    # Install ripgrep
    if ! command_exists rg; then
        print_status "Installing ripgrep..."
        brew install ripgrep
    fi
    
    # Install fd
    if ! command_exists fd; then
        print_status "Installing fd..."
        brew install fd
    fi
    
    # Install fzf
    if ! command_exists fzf; then
        print_status "Installing fzf..."
        brew install fzf
        # Install fzf key bindings and fuzzy completion
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
    fi
    
    # Install lazygit
    if ! command_exists lazygit; then
        print_status "Installing lazygit..."
        brew install lazygit
    fi
    
    # Install tree-sitter
    if ! command_exists tree-sitter; then
        print_status "Installing tree-sitter..."
        brew install tree-sitter
    fi
    
    # Install xclip (for clipboard support)
    if ! command_exists xclip; then
        print_status "Installing xclip..."
        brew install xclip
    fi
}

install_lazyvim() {
    print_status "Checking for Neovim..."
    if ! command_exists nvim; then
        print_status "Installing Neovim..."
        brew install neovim
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
configure_terminal

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
print_status "Next steps:"
print_status "  - For LazyVim: Run 'nvim' to complete the setup and wait for plugins to install"
print_status "  - For VSCode: Install your preferred extensions"
print_status "  - For WebStorm/IntelliJ/PyCharm: Configure your preferred settings"
print_status "  - Restart your terminal to apply the new font settings"

# Check if Volta is properly installed
if [ ! -d "$HOME/.volta" ]; then
    print_warning "Volta is not properly installed. Please check the output of 'ls -la ~/.volta'"
fi

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

ln -s "$(pyenv which python3)" "$HOME/.pyenv/shims/python"
pyenv rehash

which python
python --version
python -c "from distutils.version import StrictVersion; print('distutils is available')" 