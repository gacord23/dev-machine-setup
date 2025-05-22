# Source common utilities
. "$PSScriptRoot\..\..\common\utils.ps1"

# Function to uninstall VSCode
function Uninstall-VSCode {
    Write-Status "Uninstalling VSCode..."
    if (Test-Path "C:\Program Files\Microsoft VS Code") {
        Remove-Item -Path "C:\Program Files\Microsoft VS Code" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\Code") {
        Remove-Item -Path "$env:APPDATA\Code" -Recurse -Force
    }
    if (Test-Path "$env:USERPROFILE\.vscode") {
        Remove-Item -Path "$env:USERPROFILE\.vscode" -Recurse -Force
    }
    Write-Status "VSCode uninstalled"
}

# Function to uninstall Cursor
function Uninstall-Cursor {
    Write-Status "Uninstalling Cursor..."
    if (Test-Path "C:\Program Files\Cursor") {
        Remove-Item -Path "C:\Program Files\Cursor" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\Cursor") {
        Remove-Item -Path "$env:APPDATA\Cursor" -Recurse -Force
    }
    Write-Status "Cursor uninstalled"
}

# Function to uninstall WebStorm
function Uninstall-WebStorm {
    Write-Status "Uninstalling WebStorm..."
    if (Test-Path "C:\Program Files\JetBrains\WebStorm") {
        Remove-Item -Path "C:\Program Files\JetBrains\WebStorm" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\JetBrains\WebStorm*") {
        Remove-Item -Path "$env:APPDATA\JetBrains\WebStorm*" -Recurse -Force
    }
    Write-Status "WebStorm uninstalled"
}

# Function to uninstall IntelliJ IDEA
function Uninstall-IntelliJ {
    Write-Status "Uninstalling IntelliJ IDEA..."
    if (Test-Path "C:\Program Files\JetBrains\IntelliJ IDEA") {
        Remove-Item -Path "C:\Program Files\JetBrains\IntelliJ IDEA" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\JetBrains\IntelliJIdea*") {
        Remove-Item -Path "$env:APPDATA\JetBrains\IntelliJIdea*" -Recurse -Force
    }
    Write-Status "IntelliJ IDEA uninstalled"
}

# Function to uninstall PyCharm
function Uninstall-PyCharm {
    Write-Status "Uninstalling PyCharm..."
    if (Test-Path "C:\Program Files\JetBrains\PyCharm") {
        Remove-Item -Path "C:\Program Files\JetBrains\PyCharm" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\JetBrains\PyCharm*") {
        Remove-Item -Path "$env:APPDATA\JetBrains\PyCharm*" -Recurse -Force
    }
    Write-Status "PyCharm uninstalled"
}

# Function to uninstall Sublime Text
function Uninstall-SublimeText {
    Write-Status "Uninstalling Sublime Text..."
    if (Test-Path "C:\Program Files\Sublime Text") {
        Remove-Item -Path "C:\Program Files\Sublime Text" -Recurse -Force
    }
    if (Test-Path "$env:APPDATA\Sublime Text") {
        Remove-Item -Path "$env:APPDATA\Sublime Text" -Recurse -Force
    }
    Write-Status "Sublime Text uninstalled"
}

# Function to uninstall LazyVim
function Uninstall-LazyVim {
    Write-Status "Uninstalling LazyVim..."
    if (Test-Path "$env:USERPROFILE\.config\nvim") {
        Remove-Item -Path "$env:USERPROFILE\.config\nvim" -Recurse -Force
    }
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop uninstall neovim
    }
    Write-Status "LazyVim uninstalled"
}

# Main execution
Write-Status "Starting IDE uninstallation..."

# Get user selections
Write-Host "`nSelect IDEs and code editors to uninstall:"
Write-Host "1) VSCode"
Write-Host "2) Cursor"
Write-Host "3) WebStorm"
Write-Host "4) LazyVim"
Write-Host "5) IntelliJ IDEA"
Write-Host "6) PyCharm"
Write-Host "7) Sublime Text"
Write-Host "8) All"
Write-Host ""

$choices = Read-Host "Enter your choices (comma-separated, e.g., 1,3,4)"

# Process choices
$selected = $choices -split ','
foreach ($choice in $selected) {
    switch ($choice) {
        "1" { Uninstall-VSCode }
        "2" { Uninstall-Cursor }
        "3" { Uninstall-WebStorm }
        "4" { Uninstall-LazyVim }
        "5" { Uninstall-IntelliJ }
        "6" { Uninstall-PyCharm }
        "7" { Uninstall-SublimeText }
        "8" {
            Uninstall-VSCode
            Uninstall-Cursor
            Uninstall-WebStorm
            Uninstall-LazyVim
            Uninstall-IntelliJ
            Uninstall-PyCharm
            Uninstall-SublimeText
        }
        default { Write-Warning "Invalid choice: $choice" }
    }
}

Write-Status "IDE uninstallation complete!" 