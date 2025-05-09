#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

# Source baseline utilities for package manager functions
source "$(dirname "$0")/../baseline/install.sh"

install_docker_engine() {
    print_status "Installing Docker Engine..."
    case $(detect_package_manager) in
        apt)
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            sudo chmod a+r /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        dnf)
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        pacman)
            sudo pacman -S --noconfirm docker
            ;;
    esac
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    print_warning "You need to log out and back in for Docker group changes to take effect"
}

install_colima() {
    print_status "Installing Colima..."
    case $(detect_package_manager) in
        apt)
            sudo apt-get update
            sudo apt-get install -y colima
            ;;
        dnf)
            sudo dnf install -y colima
            ;;
        pacman)
            sudo pacman -S --noconfirm colima
            ;;
    esac
    print_status "Starting Colima..."
    colima start

    # Ensure Docker CLI and Compose plugin are installed
    case $(detect_package_manager) in
        apt)
            sudo apt-get install -y docker-ce-cli docker-compose-plugin
            ;;
        dnf)
            sudo dnf install -y docker-ce-cli docker-compose-plugin
            ;;
        pacman)
            sudo pacman -S --noconfirm docker docker-compose
            ;;
    esac
}

install_kubernetes_tools() {
    print_status "Installing Kubernetes tools..."
    
    if ! command_exists kubectl; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    else
        print_status "kubectl already installed"
    fi

    if ! command_exists k9s; then
        case $(detect_package_manager) in
            apt|dnf|yum)
                curl -sS https://webinstall.dev/k9s | bash
                ;;
            pacman)
                sudo pacman -S --noconfirm k9s
                ;;
        esac
    else
        print_status "k9s already installed"
    fi
}

# Main execution
print_status "Select your container runtime:"
echo "1) Docker Engine"
echo "2) Colima"
read -p "Enter your choice (1-2): " container_choice

case $container_choice in
    1)
        install_docker_engine
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
print_status "If you installed Docker Engine:"
print_status "  - Start: sudo systemctl start docker"
print_status "  - Stop: sudo systemctl stop docker"
print_status "  - Status: sudo systemctl status docker"
print_status "If you installed Colima:"
print_status "  - Start: colima start"
print_status "  - Stop: colima stop"
print_status "  - Status: colima status"
print_status "Note: You may need to log out and back in for Docker group changes to take effect" 