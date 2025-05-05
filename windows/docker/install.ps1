# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\..\common\utils.ps1"

function Install-DockerDesktop {
    Write-Status "Installing Docker Desktop..."
    if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
        choco install docker-desktop -y
        refreshenv
        Write-Status "Docker Desktop installed. Please start Docker Desktop manually."
    } else {
        Write-Status "Docker Desktop already installed"
    }
}

function Install-KubernetesTools {
    Write-Status "Installing Kubernetes tools..."
    
    # Install kubectl
    if (!(Get-Command kubectl -ErrorAction SilentlyContinue)) {
        choco install kubernetes-cli -y
        refreshenv
    } else {
        Write-Status "kubectl already installed"
    }

    # Install k9s
    if (!(Get-Command k9s -ErrorAction SilentlyContinue)) {
        choco install k9s -y
        refreshenv
    } else {
        Write-Status "k9s already installed"
    }
}

# Main execution
Write-Status "Select your container runtime:"
Write-Host "1) Docker Desktop"
Write-Host "2) None"
$containerChoice = Read-Host "Enter your choice (1-2)"

switch ($containerChoice) {
    "1" {
        Install-DockerDesktop
        Install-KubernetesTools
    }
    "2" {
        Write-Status "Skipping container runtime installation"
    }
    default {
        Write-Error "Invalid choice. Skipping container runtime installation."
        exit 1
    }
}

Write-Status "Docker setup complete!"
Write-Status "If you installed Docker Desktop:"
Write-Status "  - Start Docker Desktop from the Start menu"
Write-Status "  - Wait for Docker to finish starting up"
Write-Status "  - Verify installation by running 'docker run hello-world'"
Write-Status "For Kubernetes tools:"
Write-Status "  - kubectl is ready to use"
Write-Status "  - k9s is ready to use" 