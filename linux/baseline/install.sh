#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Function to detect package manager
detect_package_manager() {
    if command_exists apt-get; then
        echo "apt"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists yum; then
        echo "yum"
    elif command_exists pacman; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Function to install packages based on package manager
install_package() {
    local pkg_manager=$(detect_package_manager)
    case $pkg_manager in
        apt)
            sudo apt-get update
            sudo apt-get install -y "$1"
            ;;
        dnf)
            sudo dnf install -y "$1"
            ;;
        yum)
            sudo yum install -y "$1"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$1"
            ;;
        *)
            print_error "Unsupported package manager"
            exit 1
            ;;
    esac
}

install_build_essentials() {
    print_status "Installing build essentials and required packages..."
    case $(detect_package_manager) in
        apt)
            sudo apt-get update
            sudo apt-get install -y build-essential curl file git
            ;;
        dnf)
            sudo dnf groupinstall -y "Development Tools"
            sudo dnf install -y curl file git
            ;;
        yum)
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y curl file git
            ;;
        pacman)
            sudo pacman -S --noconfirm base-devel curl file git
            ;;
    esac
}

install_volta() {
    print_status "Installing Volta..."
    if ! command_exists volta; then
        curl https://get.volta.sh | bash
        source ~/.bashrc
    else
        print_status "Volta already installed"
    fi
}

# Ensure jq is installed
if ! command_exists jq; then
    print_status "Installing jq..."
    case $(detect_package_manager) in
        apt)
            sudo apt-get update
            sudo apt-get install -y jq
            ;;
        dnf)
            sudo dnf install -y jq
            ;;
        yum)
            sudo yum install -y jq
            ;;
        pacman)
            sudo pacman -S --noconfirm jq
            ;;
        *)
            print_error "Unsupported package manager for jq installation"
            exit 1
            ;;
    esac
else
    print_status "jq already installed"
fi

# Main execution
install_build_essentials
install_volta

print_status "Baseline setup complete!"
print_status "Your system is now ready for development tools installation." 