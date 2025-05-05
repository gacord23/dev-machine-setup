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

configure_terminal_app() {
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

install_iterm2() {
    print_status "Checking for iTerm2..."
    if ! command_exists iterm2; then
        print_status "Installing iTerm2..."
        brew install --cask iterm2
    else
        print_status "iTerm2 already installed"
    fi
}

install_warp() {
    print_status "Checking for Warp..."
    if ! command_exists warp; then
        print_status "Installing Warp..."
        brew install --cask warp
    else
        print_status "Warp already installed"
    fi
}

# Main execution
print_status "Starting terminal emulator installation..."

# Install Nerd Fonts first
install_nerd_fonts

# Get user selections
echo -e "\n${BOLD}Select terminal emulator to install:${NC}"
echo "1) Terminal.app (configure with MesloLGM Nerd Font)"
echo "2) iTerm2"
echo "3) Warp"
echo "4) All"
echo

read -p "Enter your choices (comma-separated, e.g., 1,3): " choices

# Process choices
IFS=',' read -ra selected <<< "$choices"
for choice in "${selected[@]}"; do
    case "$choice" in
        1) configure_terminal_app ;;
        2) install_iterm2 ;;
        3) install_warp ;;
        4)
            configure_terminal_app
            install_iterm2
            install_warp
            ;;
        *)
            print_warning "Invalid choice: $choice"
            ;;
    esac
done

print_status "Terminal emulator installation complete!"
print_status "Next steps:"
print_status "  - For Terminal.app: Restart to apply the new font settings"
print_status "  - For iTerm2: Configure your preferred theme and settings"
print_status "  - For Warp: Configure your preferred theme and settings" 