#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../common/utils.sh"

# Function to run a category installation script
run_category() {
    local category=$1
    local script_path="$(dirname "$0")/$category/install.sh"
    
    if [ -f "$script_path" ]; then
        print_status "Running $category installation..."
        bash "$script_path"
    else
        print_error "Installation script not found for $category"
    fi
}

# Main menu
while true; do
    print_status "Select installation categories:"
    echo "1) Baseline (Build essentials, curl, git)"
    echo "2) Git (Git, LazyGit, GitHub CLI, Git LFS, GitKraken)"
    echo "3) Docker (Docker Engine or Colima)"
    echo "4) IDE (VSCode, Cursor, WebStorm, LazyVim)"
    echo "5) Terminal (Terminal emulators, shell configuration)"
    echo "6) All Categories"
    echo "7) Exit"
    echo "Enter your choices as comma-separated numbers (e.g., 1,3,5):"
    read -p "Your choices: " choices

    # Convert comma-separated input to array
    IFS=',' read -ra CHOICE_ARRAY <<< "$choices"

    # Process each choice
    for choice in "${CHOICE_ARRAY[@]}"; do
        case $choice in
            1)
                run_category "baseline"
                ;;
            2)
                run_category "git"
                ;;
            3)
                run_category "docker"
                ;;
            4)
                run_category "ide"
                ;;
            5)
                run_category "terminal"
                ;;
            6)
                run_category "baseline"
                run_category "git"
                run_category "docker"
                run_category "ide"
                run_category "terminal"
                ;;
            7)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice: $choice"
                ;;
        esac
    done

    print_status "Setup complete!"
    print_status "Next steps:"
    print_status "  - Restart your terminal to ensure all changes take effect"
    print_status "  - If you installed Docker Engine, make sure the service is running"
    print_status "  - If you installed Colima, you can manage it using the 'colima' command"
    print_status "  - If you installed LazyVim, run 'nvim' to complete the setup"
    print_status "  - If you installed oh-my-zsh, you may want to customize your .zshrc"
    print_status "  - If you installed Git tools, make sure to configure your Git identity"
    print_status "  - If you installed GitHub CLI, authenticate with 'gh auth login'"
    exit 0
done 