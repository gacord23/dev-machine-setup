# Source common utilities
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\..\..\common\utils.ps1"

function Install-Chocolatey {
    Write-Status "Installing Chocolatey..."
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        refreshenv
    } else {
        Write-Status "Chocolatey already installed"
    }
}

function Install-Volta {
    Write-Status "Installing Volta..."
    if (!(Get-Command volta -ErrorAction SilentlyContinue)) {
        choco install volta -y
        refreshenv
    } else {
        Write-Status "Volta already installed"
    }
}

# Main execution
Install-Chocolatey
Install-Volta

Write-Status "Baseline setup complete!"
Write-Status "Your system is now ready for development tools installation." 