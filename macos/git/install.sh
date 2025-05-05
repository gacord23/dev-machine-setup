#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_git() {
    print_status "Installing Git..."
    if ! command_exists git; then
        brew install git
    else
        print_status "Git already installed"
    fi

    # Configure Git
    read -p "Enter your Git name: " git_name
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    # Generate SSH key for GitHub (optional)
    read -p "Would you like to generate an SSH key for GitHub? (y/n): " ssh_choice
    if [[ $ssh_choice =~ ^[Yy]$ ]]; then
        print_status "Setting up SSH for GitHub..."
        if [ ! -f ~/.ssh/id_ed25519 ]; then
            ssh-keygen -t ed25519 -C "$git_email"
            print_status "SSH key generated. Please add it to your GitHub account."
            cat ~/.ssh/id_ed25519.pub
            print_warning "Please add the above SSH key to your GitHub account before continuing."
            read -p "Press Enter to continue after adding the key to GitHub..."
        else
            print_status "SSH key already exists"
        fi
    fi
}

install_lazygit() {
    print_status "Installing LazyGit..."
    if ! command_exists lazygit; then
        brew install lazygit
    else
        print_status "LazyGit already installed"
    fi
}

install_github_cli() {
    print_status "Installing GitHub CLI..."
    if ! command_exists gh; then
        brew install gh
    else
        print_status "GitHub CLI already installed"
    fi

    # Authenticate with GitHub if not already authenticated
    if ! gh auth status &>/dev/null; then
        print_status "Authenticating with GitHub..."
        gh auth login
    fi
}

install_git_lfs() {
    print_status "Installing Git LFS..."
    if ! command_exists git-lfs; then
        brew install git-lfs
        git lfs install
    else
        print_status "Git LFS already installed"
    fi
}

install_git_tools() {
    print_status "Installing additional Git tools..."
    
    # Install Git Credential Manager
    if ! command_exists git-credential-manager; then
        brew install --cask git-credential-manager
    fi

    # Install Git Extensions (not available on macOS, but we can install SourceTree as an alternative)
    if ! command_exists sourcetree; then
        brew install --cask sourcetree
    fi
}

# Main execution
print_status "Select Git tools to install:"
echo "1) Git (required)"
echo "2) LazyGit (terminal UI for Git)"
echo "3) GitHub CLI (official GitHub command line tool)"
echo "4) Git LFS (Large File Storage)"
echo "5) Additional Git Tools (Git Credential Manager, SourceTree)"
echo "6) All Tools"
echo "Enter your choices as comma-separated numbers (e.g., 1,3,5):"
read -p "Your choices: " tool_choices

# Convert comma-separated input to array
IFS=',' read -ra TOOL_ARRAY <<< "$tool_choices"

# Install selected tools
for choice in "${TOOL_ARRAY[@]}"; do
    case $choice in
        1)
            install_git
            ;;
        2)
            install_lazygit
            ;;
        3)
            install_github_cli
            ;;
        4)
            install_git_lfs
            ;;
        5)
            install_git_tools
            ;;
        6)
            install_git
            install_lazygit
            install_github_cli
            install_git_lfs
            install_git_tools
            ;;
        *)
            print_error "Invalid choice: $choice"
            ;;
    esac
done

print_status "Git setup complete!"
print_status "Next steps:"
print_status "  - If you installed GitHub CLI, you can use 'gh' commands to interact with GitHub"
print_status "  - If you installed LazyGit, you can use 'lazygit' in your terminal"
print_status "  - If you installed SourceTree, you can find it in your Applications folder"
print_status "  - You may need to restart your terminal for some tools to be available" 