#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../common/utils.sh"

# Check if running on macOS
check_os "Darwin"

print_status "Detected macOS"
print_status "Starting macOS Development Machine Setup"

# Always run baseline first
bash "$(dirname "$0")/baseline/install.sh"

# Function to display menu
display_menu() {
    echo -e "\n${BOLD}Available Categories:${NC}"
    echo "1) Baseline (Xcode CLI, Homebrew, Volta)"
    echo "2) Git (Git, LazyGit, GitHub CLI, Git LFS)"
    echo "3) Docker (Docker Desktop, Colima, Kubernetes tools)"
    echo "4) IDE (VSCode, Cursor, WebStorm, LazyVim)"
    echo "5) Terminal (iTerm2, Warp, zsh + oh-my-zsh)"
    echo "6) Imaging Tools (Vips, glib)"
    echo "7) All Categories"
    echo "8) Exit"
    echo
}

# Function to run a category installation
run_category() {
    local category="$1"
    local script_path="$(dirname "$0")/${category}/install.sh"
    
    if [ -f "$script_path" ]; then
        print_status "Running ${category} installation..."
        bash "$script_path"
    else
        print_error "Installation script not found for ${category}"
    fi
}

# Main menu loop
while true; do
    display_menu
    read -p "Enter your choice (comma-separated for multiple, e.g., 1,3,5): " choices
    
    # Handle exit
    if [[ "$choices" == "8" ]]; then
        print_status "Exiting setup"
        exit 0
    fi
    
    # Process multiple choices
    IFS=',' read -ra selected <<< "$choices"
    for choice in "${selected[@]}"; do
        case "$choice" in
            1) run_category "baseline" ;;
            2) run_category "git" ;;
            3) run_category "docker" ;;
            4) run_category "ide" ;;
            5) run_category "terminal" ;;
            6) run_category "imaging" ;;
            7)
                print_status "Installing all categories..."
                run_category "baseline"
                run_category "git"
                run_category "docker"
                run_category "ide"
                run_category "terminal"
                run_category "imaging"
                ;;
            *)
                print_warning "Invalid choice: $choice"
                ;;
        esac
    done
    
    # Ask if user wants to continue
    if ! prompt_yes_no "Do you want to install more components?"; then
        break
    fi
done

# Always run finishup/verify.sh at the end
bash "$(dirname "$0")/finishup/verify.sh"

print_status "Setup complete!"
print_status "Please review the output above for any warnings or errors."
print_status "Next steps:"
print_status "  - Restart your terminal to ensure all changes take effect"
print_status "  - If you installed Docker Desktop, start it from your Applications folder"
print_status "  - If you installed Colima, you can manage it using the 'colima' command"
print_status "  - If you installed LazyVim, run 'nvim' to complete the setup"
print_status "  - If you installed oh-my-zsh, you may want to customize your .zshrc"
print_status "  - If you installed Git tools, make sure to configure your Git identity"
print_status "  - If you installed GitHub CLI, authenticate with 'gh auth login'"
print_status "  - If you installed imaging tools, run 'source ~/.zshrc' to apply the new environment variables" 