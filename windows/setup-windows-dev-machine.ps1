# PowerShell script for Windows development machine setup

# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\common\utils.ps1"

# Function to print status messages
function Write-Status {
    param([string]$Message)
    Write-Host "[*] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

# Function to check if a command exists
function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command -Name $Command -ErrorAction SilentlyContinue)
}

# Function to prompt for user input
function Read-UserInput {
    param([string]$Prompt)
    return Read-Host -Prompt $Prompt
}

# Install Chocolatey if not installed
Write-Status "Checking for Chocolatey..."
if (-not (Test-CommandExists "choco")) {
    Write-Status "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Status "Chocolatey already installed"
}

# Install Git
Write-Status "Installing Git..."
if (-not (Test-CommandExists "git")) {
    choco install git -y
} else {
    Write-Status "Git already installed"
}

# Configure Git
Write-Status "Configuring Git..."
$git_name = Read-UserInput "Enter your Git name"
$git_email = Read-UserInput "Enter your Git email"

git config --global user.name "$git_name"
git config --global user.email "$git_email"

# Generate SSH key for GitHub (optional)
Write-Status "Would you like to generate an SSH key for GitHub? (y/n)"
$ssh_choice = Read-UserInput "Enter your choice (y/n)"

if ($ssh_choice -eq "y" -or $ssh_choice -eq "Y") {
    Write-Status "Setting up SSH for GitHub..."
    if (-not (Test-Path "$env:USERPROFILE\.ssh\id_ed25519")) {
        ssh-keygen -t ed25519 -C "$git_email"
        Write-Status "SSH key generated. Please add it to your GitHub account."
        Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
        Write-Warning "Please add the above SSH key to your GitHub account before continuing."
        Read-Host "Press Enter to continue after adding the key to GitHub..."
    } else {
        Write-Status "SSH key already exists"
    }
} else {
    Write-Status "Skipping SSH key generation"
}

# Install Volta
Write-Status "Installing Volta..."
if (-not (Test-CommandExists "volta")) {
    choco install volta -y
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
} else {
    Write-Status "Volta already installed"
}

# Install AWS CLI and aws-vault
Write-Status "Installing AWS CLI and aws-vault..."
if (-not (Test-CommandExists "aws")) {
    choco install awscli -y
} else {
    Write-Status "AWS CLI already installed"
}

if (-not (Test-CommandExists "aws-vault")) {
    choco install aws-vault -y
} else {
    Write-Status "aws-vault already installed"
}

# Prompt for code editor choices
Write-Status "Select your preferred code editors (you can choose multiple):"
Write-Host "1) VSCode"
Write-Host "2) Cursor"
Write-Host "3) WebStorm"
Write-Host "4) None"
Write-Host "Enter your choices as comma-separated numbers (e.g., 1,3):"
$editor_choices = Read-UserInput "Your choices"

# Convert comma-separated input to array
$EDITOR_ARRAY = $editor_choices -split ','

# Install selected editors
foreach ($choice in $EDITOR_ARRAY) {
    switch ($choice.Trim()) {
        "1" {
            Write-Status "Installing VSCode..."
            choco install vscode -y
        }
        "2" {
            Write-Status "Installing Cursor..."
            choco install cursor -y
        }
        "3" {
            Write-Status "Installing WebStorm..."
            choco install webstorm -y
        }
        "4" {
            Write-Status "Skipping code editor installation"
        }
        default {
            Write-Error "Invalid choice: $choice"
        }
    }
}

# Prompt for terminal choice
Write-Status "Select your preferred terminal:"
Write-Host "1) Windows Terminal"
Write-Host "2) None"
$terminal_choice = Read-UserInput "Enter your choice (1-2)"

switch ($terminal_choice) {
    "1" {
        Write-Status "Installing Windows Terminal..."
        choco install microsoft-windows-terminal -y
    }
    "2" {
        Write-Status "Skipping terminal installation"
    }
    default {
        Write-Error "Invalid choice. Skipping terminal installation."
    }
}

# Install LazyVim
Write-Status "Installing LazyVim..."
if (-not (Test-CommandExists "nvim")) {
    choco install neovim -y
}

# Clone LazyVim starter
if (-not (Test-Path "$env:LOCALAPPDATA\nvim")) {
    git clone https://github.com/LazyVim/starter "$env:LOCALAPPDATA\nvim"
    Write-Status "LazyVim installed. Please run 'nvim' to complete the setup."
} else {
    Write-Status "LazyVim already installed"
}

# Install Docker and Kubernetes tools
Write-Status "Installing Docker and Kubernetes tools..."
if (-not (Test-CommandExists "docker")) {
    choco install docker-desktop -y
    Write-Warning "Docker Desktop needs to be started manually after installation"
}

if (-not (Test-CommandExists "kubectl")) {
    choco install kubernetes-cli -y
}

if (-not (Test-CommandExists "k9s")) {
    choco install k9s -y
}

# Install Python and Go
Write-Status "Installing Python and Go..."
if (-not (Test-CommandExists "python")) {
    choco install python -y
}

if (-not (Test-CommandExists "go")) {
    choco install golang -y
}

# Install and configure zsh
Write-Status "Installing and configuring zsh..."
if (-not (Test-CommandExists "zsh")) {
    choco install zsh -y
}

# Install oh-my-zsh if not already installed
if (-not (Test-Path "$env:USERPROFILE\.oh-my-zsh")) {
    # Install oh-my-zsh
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.ps1')
    
    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions "$env:USERPROFILE\.oh-my-zsh\custom\plugins\zsh-autosuggestions"
    
    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$env:USERPROFILE\.oh-my-zsh\custom\plugins\zsh-syntax-highlighting"
    
    # Update .zshrc with plugins
    $zshrcPath = "$env:USERPROFILE\.zshrc"
    if (Test-Path $zshrcPath) {
        $content = Get-Content $zshrcPath
        $content = $content -replace 'plugins=\(git\)', 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)'
        $content | Set-Content $zshrcPath
    }
}

# Install DBeaver
Write-Status "Would you like to install DBeaver? (y/n)"
$dbeaver_choice = Read-UserInput "Enter your choice (y/n)"

if ($dbeaver_choice -eq "y" -or $dbeaver_choice -eq "Y") {
    if (-not (Test-CommandExists "dbeaver")) {
        choco install dbeaver -y
    } else {
        Write-Status "DBeaver already installed"
    }
} else {
    Write-Status "Skipping DBeaver installation"
}

Write-Host "`nSetup complete! Please review the following steps:" -ForegroundColor Green
Write-Host "1. Git Configuration:" -ForegroundColor Cyan
Write-Host "   - Verify your Git configuration with: git config --list"
Write-Host "   - If you need to update your Git credentials, run:"
Write-Host "     git config --global user.name 'Your Name'"
Write-Host "     git config --global user.email 'your.email@example.com'"

Write-Host "`n2. GitHub SSH Key:" -ForegroundColor Cyan
Write-Host "   - If you generated a new SSH key, make sure to add it to your GitHub account"
Write-Host "   - You can view your public key with: cat ~/.ssh/id_ed25519.pub"
Write-Host "   - Add this key to GitHub: https://github.com/settings/keys"

Write-Host "`n3. LazyVim Setup:" -ForegroundColor Cyan
Write-Host "   - Run 'nvim' to complete the LazyVim setup"
Write-Host "   - Wait for the plugins to install"
Write-Host "   - You may need to restart nvim after the initial setup"

Write-Host "`n4. AWS Configuration:" -ForegroundColor Cyan
Write-Host "   - Configure AWS CLI with: aws configure"
Write-Host "   - Set up aws-vault with: aws-vault add your-profile"
Write-Host "   - You'll need your AWS Access Key ID and Secret Access Key"

Write-Host "`n5. Docker Desktop:" -ForegroundColor Cyan
Write-Host "   - Start Docker Desktop from the Start menu"
Write-Host "   - Wait for Docker to initialize (you'll see the whale icon in the system tray)"
Write-Host "   - Verify Docker is working by opening a new terminal and running: docker run hello-world"
Write-Host "   - If you see any WSL 2 installation prompts, follow them to complete the setup"

Write-Host "`n6. WSL Setup:" -ForegroundColor Cyan
Write-Host "   - If you installed WSL, you may need to restart your computer"
Write-Host "   - After restart, open Ubuntu from the Start menu to complete its setup"
Write-Host "   - Set up your WSL username and password when prompted"
Write-Host "   - You can verify WSL is working with: wsl --list --verbose"

Write-Host "`n7. Additional Steps:" -ForegroundColor Cyan
Write-Host "   - Make sure all your chosen IDEs are properly configured"
Write-Host "   - Check that all installed tools are in your PATH"
Write-Host "   - You may need to restart your computer for some changes to take effect"
Write-Host "   - If you installed VS Code, you may need to install additional extensions"
Write-Host "   - If you installed JetBrains IDEs, you may need to configure them"

Write-Host "`nNeed help? Check the documentation for each tool or run the script again to reinstall components." -ForegroundColor Yellow

# Function to run a category installation script
function Run-Category {
    param (
        [string]$category
    )
    
    $scriptPath = Join-Path $PSScriptRoot "$category\install.ps1"
    
    if (Test-Path $scriptPath) {
        Write-Status "Running $category installation..."
        & $scriptPath
    } else {
        Write-Error "Installation script for $category not found at $scriptPath"
    }
}

# Main menu
Write-Status "Windows Development Machine Setup"
Write-Host "Available categories:"
Write-Host "1) Baseline (Chocolatey, Volta)"
Write-Host "2) Git (Git, LazyGit, GitHub CLI, Git LFS, GitKraken)"
Write-Host "3) Docker (Docker Desktop, Kubernetes Tools)"
Write-Host "4) IDE (VSCode, WebStorm, LazyVim)"
Write-Host "5) Terminal (Windows Terminal, PowerShell Core)"
Write-Host "6) All Categories"
Write-Host "7) Exit"
Write-Host "Enter your choices as comma-separated numbers (e.g., 1,3):"
$choices = Read-Host "Your choices"

# Convert comma-separated input to array
$choiceArray = $choices -split ','

# Process choices
foreach ($choice in $choiceArray) {
    switch ($choice.Trim()) {
        "1" { Run-Category "baseline" }
        "2" { Run-Category "git" }
        "3" { Run-Category "docker" }
        "4" { Run-Category "ide" }
        "5" { Run-Category "terminal" }
        "6" {
            Run-Category "baseline"
            Run-Category "git"
            Run-Category "docker"
            Run-Category "ide"
            Run-Category "terminal"
        }
        "7" {
            Write-Status "Exiting setup"
            exit 0
        }
        default {
            Write-Error "Invalid choice: $choice"
        }
    }
}

Write-Status "Setup complete!"
Write-Status "Next steps:"
Write-Status "  - Review the installation logs for any errors"
Write-Status "  - Restart your terminal to ensure all changes take effect"
Write-Status "  - Configure your newly installed tools as needed" 