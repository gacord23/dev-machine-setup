#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_docker_desktop() {
    print_status "Installing Docker Desktop..."
    if ! command_exists docker; then
        brew install --cask docker
        print_warning "Docker Desktop needs to be started manually after installation"
    else
        print_status "Docker is already installed"
    fi
}

install_colima() {
    print_status "Installing Colima..."
    if ! command_exists colima; then
        brew install colima
        print_status "Starting Colima..."
        colima start
    else
        print_status "Colima already installed"
    fi
}

install_kubernetes_tools() {
    print_status "Installing Kubernetes tools..."
    
    if ! command_exists kubectl; then
        brew install kubectl
    else
        print_status "kubectl already installed"
    fi

    if ! command_exists k9s; then
        brew install k9s
    else
        print_status "k9s already installed"
    fi
}

# Main execution
print_status "Select your container runtime:"
echo "1) Docker Desktop"
echo "2) Colima"
read -p "Enter your choice (1-2): " container_choice

case $container_choice in
    1)
        install_docker_desktop
        ;;
    2)
        install_colima
        ;;
    *)
        print_error "Invalid choice. Skipping container runtime installation."
        exit 1
        ;;
esac

install_kubernetes_tools

print_status "Docker setup complete!"
print_status "If you installed Docker Desktop, please start it from your Applications folder"
print_status "If you installed Colima, you can manage it with:"
print_status "  - Start: colima start"
print_status "  - Stop: colima stop"
print_status "  - Status: colima status" 