#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Detect package manager
detect_package_manager() {
    if command_exists apt; then
        echo "apt"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists yum; then
        echo "yum"
    elif command_exists pacman; then
        echo "pacman"
    else
        print_error "No supported package manager found"
        exit 1
    fi
}

# Install package based on package manager
install_package() {
    local pkg=$1
    local pkg_manager=$(detect_package_manager)
    
    case $pkg_manager in
        apt)
            sudo apt update
            sudo apt install -y $pkg
            ;;
        dnf)
            sudo dnf install -y $pkg
            ;;
        yum)
            sudo yum install -y $pkg
            ;;
        pacman)
            sudo pacman -S --noconfirm $pkg
            ;;
    esac
}

install_git() {
    print_status "Installing Git..."
    if ! command_exists git; then
        install_package git
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
        # Install using the official installation script
        curl -s https://raw.githubusercontent.com/jesseduffield/lazygit/master/install.sh | bash
    else
        print_status "LazyGit already installed"
    fi
}

install_github_cli() {
    print_status "Installing GitHub CLI..."
    if ! command_exists gh; then
        local pkg_manager=$(detect_package_manager)
        case $pkg_manager in
            apt)
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install -y gh
                ;;
            dnf|yum)
                sudo dnf install -y 'dnf-command(copr)'
                sudo dnf copr enable -y varlad/gh
                sudo dnf install -y gh
                ;;
            pacman)
                sudo pacman -S --noconfirm github-cli
                ;;
        esac
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
        local pkg_manager=$(detect_package_manager)
        case $pkg_manager in
            apt)
                curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
                sudo apt install -y git-lfs
                ;;
            dnf|yum)
                sudo dnf install -y git-lfs
                ;;
            pacman)
                sudo pacman -S --noconfirm git-lfs
                ;;
        esac
        git lfs install
    else
        print_status "Git LFS already installed"
    fi
}

install_git_tools() {
    print_status "Installing additional Git tools..."
    
    # Install Git Credential Manager
    if ! command_exists git-credential-manager; then
        local pkg_manager=$(detect_package_manager)
        case $pkg_manager in
            apt)
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install -y git-credential-manager
                ;;
            dnf|yum)
                sudo dnf install -y git-credential-manager
                ;;
            pacman)
                sudo pacman -S --noconfirm git-credential-manager
                ;;
        esac
    fi

    # Install Git Extensions
    if ! command_exists gitextensions; then
        local pkg_manager=$(detect_package_manager)
        case $pkg_manager in
            apt)
                sudo apt install -y mono-complete
                wget https://github.com/gitextensions/gitextensions/releases/download/v4.2.1/GitExtensions-4.2.1-154-0c2c1c9c4_Mono.zip
                unzip GitExtensions-4.2.1-154-0c2c1c9c4_Mono.zip -d /opt/
                sudo ln -s /opt/GitExtensions/GitExtensions.exe /usr/local/bin/gitextensions
                ;;
            dnf|yum)
                sudo dnf install -y mono-complete
                wget https://github.com/gitextensions/gitextensions/releases/download/v4.2.1/GitExtensions-4.2.1-154-0c2c1c9c4_Mono.zip
                unzip GitExtensions-4.2.1-154-0c2c1c9c4_Mono.zip -d /opt/
                sudo ln -s /opt/GitExtensions/GitExtensions.exe /usr/local/bin/gitextensions
                ;;
            pacman)
                sudo pacman -S --noconfirm mono git-extensions
                ;;
        esac
    fi
}

# Main execution
print_status "Select Git tools to install:"
echo "1) Git (required)"
echo "2) LazyGit (terminal UI for Git)"
echo "3) GitHub CLI (official GitHub command line tool)"
echo "4) Git LFS (Large File Storage)"
echo "5) Additional Git Tools (Git Credential Manager, Git Extensions)"
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
print_status "  - If you installed Git Extensions, you can find it in your applications menu"
print_status "  - You may need to restart your terminal for some tools to be available" 