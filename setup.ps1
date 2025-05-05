# PowerShell script for Windows development machine setup

# Function to print status messages
function Write-Status {
    param([string]$Message)
    Write-Host "[*] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Red
}

# Check if running on Windows
if ($IsWindows) {
    Write-Status "Detected Windows"
    $scriptPath = Join-Path $PSScriptRoot "windows\setup-windows-dev-machine.ps1"
    if (Test-Path $scriptPath) {
        & $scriptPath
    } else {
        Write-Error "Windows setup script not found"
        exit 1
    }
} else {
    Write-Error "This script is for Windows only"
    Write-Error "Please use setup.sh for macOS and Linux"
    exit 1
} 