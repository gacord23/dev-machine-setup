# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\..\common\utils.ps1"

function Install-VSCode {
    Write-Status "Installing VSCode..."
    if (!(Get-Command code -ErrorAction SilentlyContinue)) {
        choco install vscode -y
        refreshenv
    } else {
        Write-Status "VSCode already installed"
    }
}

function Install-WebStorm {
    Write-Status "Installing WebStorm..."
    if (!(Test-Path "C:\Program Files\JetBrains\WebStorm")) {
        choco install webstorm -y
        refreshenv
    } else {
        Write-Status "WebStorm already installed"
    }
}

function Install-LazyVim {
    Write-Status "Installing LazyVim..."
    if (!(Get-Command nvim -ErrorAction SilentlyContinue)) {
        choco install neovim -y
        refreshenv
    }

    if (!(Test-Path "$env:LOCALAPPDATA\nvim")) {
        git clone https://github.com/LazyVim/starter "$env:LOCALAPPDATA\nvim"
        Write-Status "LazyVim installed. Please run 'nvim' to complete the setup."
    } else {
        Write-Status "LazyVim already installed"
    }
}

# Main execution
Write-Status "Select your preferred code editors (you can choose multiple):"
Write-Host "1) VSCode"
Write-Host "2) WebStorm"
Write-Host "3) LazyVim"
Write-Host "4) None"
Write-Host "Enter your choices as comma-separated numbers (e.g., 1,3):"
$editorChoices = Read-Host "Your choices"

# Convert comma-separated input to array
$editorArray = $editorChoices -split ','

# Install selected editors
foreach ($choice in $editorArray) {
    switch ($choice.Trim()) {
        "1" { Install-VSCode }
        "2" { Install-WebStorm }
        "3" { Install-LazyVim }
        "4" { Write-Status "Skipping code editor installation" }
        default { Write-Error "Invalid choice: $choice" }
    }
}

Write-Status "IDE setup complete!"
Write-Status "For LazyVim users:"
Write-Status "  - Run 'nvim' to complete the setup"
Write-Status "  - Wait for the plugins to install"
Write-Status "  - You may need to restart nvim after the initial setup" 