# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\..\common\utils.ps1"

function Install-WindowsTerminal {
    Write-Status "Installing Windows Terminal..."
    if (!(Get-Command wt -ErrorAction SilentlyContinue)) {
        choco install microsoft-windows-terminal -y
        refreshenv
    } else {
        Write-Status "Windows Terminal already installed"
    }
}

function Install-PowerShellCore {
    Write-Status "Installing PowerShell Core..."
    if (!(Get-Command pwsh -ErrorAction SilentlyContinue)) {
        choco install powershell-core -y
        refreshenv
    } else {
        Write-Status "PowerShell Core already installed"
    }
}

function Install-OhMyPosh {
    Write-Status "Installing Oh My Posh..."
    if (!(Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        choco install oh-my-posh -y
        refreshenv
    } else {
        Write-Status "Oh My Posh already installed"
    }

    # Configure PowerShell profile
    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force
    }

    # Add Oh My Posh configuration to profile if not already present
    $profileContent = Get-Content $PROFILE
    if ($profileContent -notcontains "oh-my-posh init pwsh | Invoke-Expression") {
        Add-Content $PROFILE "`noh-my-posh init pwsh | Invoke-Expression"
    }
}

# Main execution
Write-Status "Select your preferred terminal setup:"
Write-Host "1) Windows Terminal + PowerShell Core + Oh My Posh"
Write-Host "2) Windows Terminal only"
Write-Host "3) PowerShell Core + Oh My Posh"
Write-Host "4) None"
$terminalChoice = Read-Host "Enter your choice (1-4)"

switch ($terminalChoice) {
    "1" {
        Install-WindowsTerminal
        Install-PowerShellCore
        Install-OhMyPosh
    }
    "2" {
        Install-WindowsTerminal
    }
    "3" {
        Install-PowerShellCore
        Install-OhMyPosh
    }
    "4" {
        Write-Status "Skipping terminal installation"
    }
    default {
        Write-Error "Invalid choice"
        exit 1
    }
}

Write-Status "Terminal setup complete!"
Write-Status "Next steps:"
Write-Status "  - If you installed Windows Terminal, you can find it in the Start menu"
Write-Status "  - If you installed PowerShell Core, you can run it with 'pwsh'"
Write-Status "  - If you installed Oh My Posh, restart your terminal to see the new prompt"
Write-Status "  - You may want to customize your Windows Terminal settings and PowerShell profile" 