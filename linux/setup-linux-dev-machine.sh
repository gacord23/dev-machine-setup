#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../common/utils.sh"

# Function to run a category installation script
run_category() {
    local category=$1
    local action=$2
    local script_path="$(dirname "$0")/$category/install.sh"
    local uninstall_script_path="$(dirname "$0")/$category/uninstall.sh"
    
    if [ "$action" = "uninstall" ]; then
        if [ -f "$uninstall_script_path" ]; then
            print_status "Running $category uninstallation..."
            bash "$uninstall_script_path"
        else
            print_error "Uninstallation script not found for $category"
        fi
    else
        if [ -f "$script_path" ]; then
            print_status "Running $category installation..."
            bash "$script_path"
        else
            print_error "Installation script not found for $category"
        fi
    fi
}

# Parse command line arguments
UNINSTALL=false
while getopts "u" opt; do
    case $opt in
        u)
            UNINSTALL=true
            ;;
        \?)
            print_error "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

# Present menu for other categories (excluding baseline)
while true; do
    if [ "$UNINSTALL" = true ]; then
        print_status "Select categories to uninstall:"
    else
        print_status "Select installation categories:"
    fi
    echo "1) Git (Git, LazyGit, GitHub CLI, Git LFS, GitKraken)"
    echo "2) Docker (Docker Engine or Colima)"
    echo "3) IDE (VSCode, Cursor, WebStorm, LazyVim)"
    echo "4) Terminal (Terminal emulators, shell configuration)"
    echo "5) All Categories"
    echo "6) Exit"
    echo "Enter your choices as comma-separated numbers (e.g., 1,3,5):"
    read -p "Your choices: " choices

    # Convert comma-separated input to array
    IFS=',' read -ra CHOICE_ARRAY <<< "$choices"

    # Process each choice
    for choice in "${CHOICE_ARRAY[@]}"; do
        case $choice in
            1)
                run_category "git" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                ;;
            2)
                run_category "docker" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                ;;
            3)
                run_category "ide" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                ;;
            4)
                run_category "terminal" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                ;;
            5)
                run_category "git" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                run_category "docker" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                run_category "ide" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                run_category "terminal" $([ "$UNINSTALL" = true ] && echo "uninstall" || echo "install")
                ;;
            6)
                print_status "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice: $choice"
                ;;
        esac
    done

    # Ask if user wants to install/uninstall more categories
    if [ "$UNINSTALL" = true ]; then
        read -p "Would you like to uninstall more categories? (y/n): " more_choice
    else
        read -p "Would you like to install more categories? (y/n): " more_choice
    fi
    
    if [[ ! $more_choice =~ ^[Yy]$ ]]; then
        if [ "$UNINSTALL" = true ]; then
            print_status "Uninstallation complete!"
        else
            print_status "Setup complete!"
            print_status "Next steps:"
            print_status "  - Restart your terminal to ensure all changes take effect"
            print_status "  - If you installed Docker Engine, make sure the service is running"
            print_status "  - If you installed Colima, you can manage it using the 'colima' command"
            print_status "  - If you installed LazyVim, run 'nvim' to complete the setup"
            print_status "  - If you installed oh-my-zsh, you may want to customize your .zshrc"
            print_status "  - If you installed Git tools, make sure to configure your Git identity"
            print_status "  - If you installed GitHub CLI, authenticate with 'gh auth login'"

            # Always run finishup/verify.sh at the end (but only for installation)
            bash "$(dirname "$0")/finishup/verify.sh"
        fi
        exit 0
    fi
done 