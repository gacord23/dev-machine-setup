# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\..\common\utils.ps1"

function Install-Git {
    Write-Status "Installing Git..."
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        choco install git -y
        refreshenv
    } else {
        Write-Status "Git already installed"
    }

    # Configure Git
    $gitName = Read-Host "Enter your Git name"
    $gitEmail = Read-Host "Enter your Git email"
    
    git config --global user.name "$gitName"
    git config --global user.email "$gitEmail"

    # Generate SSH key for GitHub (optional)
    $sshChoice = Read-Host "Would you like to generate an SSH key for GitHub? (y/n)"
    if ($sshChoice -eq 'y' -or $sshChoice -eq 'Y') {
        Write-Status "Setting up SSH for GitHub..."
        if (!(Test-Path "$env:USERPROFILE\.ssh\id_ed25519")) {
            ssh-keygen -t ed25519 -C "$gitEmail"
            Write-Status "SSH key generated. Please add it to your GitHub account."
            Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
            Write-Warning "Please add the above SSH key to your GitHub account before continuing."
            Read-Host "Press Enter to continue after adding the key to GitHub"
        } else {
            Write-Status "SSH key already exists"
        }
    }
}

function Install-LazyGit {
    Write-Status "Installing LazyGit..."
    if (!(Get-Command lazygit -ErrorAction SilentlyContinue)) {
        choco install lazygit -y
        refreshenv
    } else {
        Write-Status "LazyGit already installed"
    }
}

function Install-GitHubCLI {
    Write-Status "Installing GitHub CLI..."
    if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
        choco install gh -y
        refreshenv
    } else {
        Write-Status "GitHub CLI already installed"
    }

    # Authenticate with GitHub if not already authenticated
    if (!(gh auth status 2>$null)) {
        Write-Status "Authenticating with GitHub..."
        gh auth login
    }
}

function Install-GitLFS {
    Write-Status "Installing Git LFS..."
    if (!(Get-Command git-lfs -ErrorAction SilentlyContinue)) {
        choco install git-lfs -y
        refreshenv
        git lfs install
    } else {
        Write-Status "Git LFS already installed"
    }
}

function Install-GitTools {
    Write-Status "Installing additional Git tools..."
    
    # Install Git Credential Manager
    if (!(Get-Command git-credential-manager -ErrorAction SilentlyContinue)) {
        choco install git-credential-manager -y
        refreshenv
    }

    # Install Git Extensions
    if (!(Test-Path "C:\Program Files\Git Extensions")) {
        choco install gitextensions -y
        refreshenv
    }
}

# Main execution
Write-Status "Select Git tools to install:"
Write-Host "1) Git (required)"
Write-Host "2) LazyGit (terminal UI for Git)"
Write-Host "3) GitHub CLI (official GitHub command line tool)"
Write-Host "4) Git LFS (Large File Storage)"
Write-Host "5) Additional Git Tools (Git Credential Manager, Git Extensions)"
Write-Host "6) All Tools"
Write-Host "Enter your choices as comma-separated numbers (e.g., 1,3,5):"
$toolChoices = Read-Host "Your choices"

# Convert comma-separated input to array
$toolArray = $toolChoices -split ','

# Install selected tools
foreach ($choice in $toolArray) {
    switch ($choice.Trim()) {
        "1" { Install-Git }
        "2" { Install-LazyGit }
        "3" { Install-GitHubCLI }
        "4" { Install-GitLFS }
        "5" { Install-GitTools }
        "6" {
            Install-Git
            Install-LazyGit
            Install-GitHubCLI
            Install-GitLFS
            Install-GitTools
        }
        default { Write-Error "Invalid choice: $choice" }
    }
}

Write-Status "Git setup complete!"
Write-Status "Next steps:"
Write-Status "  - If you installed GitHub CLI, you can use 'gh' commands to interact with GitHub"
Write-Status "  - If you installed LazyGit, you can use 'lazygit' in your terminal"
Write-Status "  - If you installed Git Extensions, you can find it in the Start menu"
Write-Status "  - You may need to restart your terminal for some tools to be available" 