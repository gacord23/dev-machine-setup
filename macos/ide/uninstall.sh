#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Function to uninstall VSCode
uninstall_vscode() {
    print_status "Uninstalling VSCode..."
    if [ -d "/Applications/Visual Studio Code.app" ]; then
        rm -rf "/Applications/Visual Studio Code.app"
    fi
    if [ -d "$HOME/Library/Application Support/Code" ]; then
        rm -rf "$HOME/Library/Application Support/Code"
    fi
    if [ -d "$HOME/.vscode" ]; then
        rm -rf "$HOME/.vscode"
    fi
    print_status "VSCode uninstalled"
}

# Function to uninstall Cursor
uninstall_cursor() {
    print_status "Uninstalling Cursor..."
    if [ -d "/Applications/Cursor.app" ]; then
        rm -rf "/Applications/Cursor.app"
    fi
    if [ -d "$HOME/Library/Application Support/Cursor" ]; then
        rm -rf "$HOME/Library/Application Support/Cursor"
    fi
    print_status "Cursor uninstalled"
}

# Function to uninstall WebStorm
uninstall_webstorm() {
    print_status "Uninstalling WebStorm..."
    if [ -d "/Applications/WebStorm.app" ]; then
        rm -rf "/Applications/WebStorm.app"
    fi
    if [ -d "$HOME/Library/Application Support/JetBrains/WebStorm*" ]; then
        rm -rf "$HOME/Library/Application Support/JetBrains/WebStorm*"
    fi
    print_status "WebStorm uninstalled"
}

# Function to uninstall IntelliJ IDEA
uninstall_intellij() {
    print_status "Uninstalling IntelliJ IDEA..."
    if [ -d "/Applications/IntelliJ IDEA.app" ]; then
        rm -rf "/Applications/IntelliJ IDEA.app"
    fi
    if [ -d "$HOME/Library/Application Support/JetBrains/IntelliJIdea*" ]; then
        rm -rf "$HOME/Library/Application Support/JetBrains/IntelliJIdea*"
    fi
    print_status "IntelliJ IDEA uninstalled"
}

# Function to uninstall PyCharm
uninstall_pycharm() {
    print_status "Uninstalling PyCharm..."
    if [ -d "/Applications/PyCharm.app" ]; then
        rm -rf "/Applications/PyCharm.app"
    fi
    if [ -d "$HOME/Library/Application Support/JetBrains/PyCharm*" ]; then
        rm -rf "$HOME/Library/Application Support/JetBrains/PyCharm*"
    fi
    print_status "PyCharm uninstalled"
}

# Function to uninstall Sublime Text
uninstall_sublime_text() {
    print_status "Uninstalling Sublime Text..."
    if [ -d "/Applications/Sublime Text.app" ]; then
        rm -rf "/Applications/Sublime Text.app"
    fi
    if [ -d "$HOME/Library/Application Support/Sublime Text" ]; then
        rm -rf "$HOME/Library/Application Support/Sublime Text"
    fi
    print_status "Sublime Text uninstalled"
}

# Function to uninstall LazyVim
uninstall_lazyvim() {
    print_status "Uninstalling LazyVim..."
    if [ -d "$HOME/.config/nvim" ]; then
        rm -rf "$HOME/.config/nvim"
    fi
    if command_exists brew; then
        brew uninstall neovim
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