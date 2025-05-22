#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Function to uninstall Cursor
uninstall_cursor() {
    print_status "Uninstalling Cursor..."
    if [ -f /usr/local/bin/cursor ]; then
        sudo rm /usr/local/bin/cursor
    fi
    if [ -f ~/.local/share/applications/cursor.desktop ]; then
        rm ~/.local/share/applications/cursor.desktop
    fi
    if [ -f ~/.local/share/icons/cursor.png ]; then
        rm ~/.local/share/icons/cursor.png
    fi
    print_status "Cursor uninstalled"
}

# Function to uninstall VSCode
uninstall_vscode() {
    print_status "Uninstalling VSCode..."
    if command_exists apt-get; then
        sudo apt-get remove -y code
        sudo apt-get autoremove -y
    elif command_exists dnf; then
        sudo dnf remove -y code
    elif command_exists pacman; then
        sudo pacman -R --noconfirm code
    fi
    print_status "VSCode uninstalled"
}

# Function to uninstall WebStorm
uninstall_webstorm() {
    print_status "Uninstalling WebStorm..."
    if command_exists snap; then
        sudo snap remove webstorm
    fi
    print_status "WebStorm uninstalled"
}

# Function to uninstall IntelliJ IDEA
uninstall_intellij() {
    print_status "Uninstalling IntelliJ IDEA..."
    if command_exists snap; then
        sudo snap remove intellij-idea-community
    fi
    print_status "IntelliJ IDEA uninstalled"
}

# Function to uninstall PyCharm
uninstall_pycharm() {
    print_status "Uninstalling PyCharm..."
    if command_exists snap; then
        sudo snap remove pycharm-community
    fi
    print_status "PyCharm uninstalled"
}

# Function to uninstall Sublime Text
uninstall_sublime_text() {
    print_status "Uninstalling Sublime Text..."
    if command_exists apt-get; then
        sudo apt-get remove -y sublime-text
        sudo apt-get autoremove -y
    elif command_exists dnf; then
        sudo dnf remove -y sublime-text
    elif command_exists pacman; then
        sudo pacman -R --noconfirm sublime-text
    fi
    print_status "Sublime Text uninstalled"
}

# Function to uninstall LazyVim
uninstall_lazyvim() {
    print_status "Uninstalling LazyVim..."
    if [ -d "$HOME/.config/nvim" ]; then
        rm -rf "$HOME/.config/nvim"
    fi
    if command_exists apt-get; then
        sudo apt-get remove -y neovim
        sudo apt-get autoremove -y
    elif command_exists dnf; then
        sudo dnf remove -y neovim
    elif command_exists pacman; then
        sudo pacman -R --noconfirm neovim
    fi
    print_status "LazyVim uninstalled"
}

# Main execution
print_status "Starting IDE uninstallation..."

# Get user selections
echo -e "\n${BOLD}Select IDEs and code editors to uninstall:${NC}"
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
        1) uninstall_vscode ;;
        2) uninstall_cursor ;;
        3) uninstall_webstorm ;;
        4) uninstall_lazyvim ;;
        5) uninstall_intellij ;;
        6) uninstall_pycharm ;;
        7) uninstall_sublime_text ;;
        8)
            uninstall_vscode
            uninstall_cursor
            uninstall_webstorm
            uninstall_lazyvim
            uninstall_intellij
            uninstall_pycharm
            uninstall_sublime_text
            ;;
        *)
            print_warning "Invalid choice: $choice"
            ;;
    esac
done

print_status "IDE uninstallation complete!" 