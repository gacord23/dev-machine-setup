# finishup/verify.ps1
#
# Final verification and recap for dev machine setup (Windows).
# Checks installed tools, ensures env vars, and prints a summary.

function Write-Status($msg) { Write-Host "[*] $msg" -ForegroundColor Green }
function Write-WarningMsg($msg) { Write-Host "[!] $msg" -ForegroundColor Yellow }

# Backup PowerShell profile
$profilePath = $PROFILE
if (Test-Path $profilePath) {
    $ts = Get-Date -Format 'yyyyMMdd-HHmmss'
    Copy-Item $profilePath "$profilePath.backup-$ts"
    Write-Status ".ps1 profile backed up to $profilePath.backup-$ts"
}

# Helper to ensure an env var is in $PROFILE
function Ensure-ProfileExport {
    param($var, $value)
    if (-not (Select-String -Path $PROFILE -Pattern $var -Quiet)) {
        Add-Content $PROFILE "`n`$env:$var = \"$value;`$env:$var\""
    }
    $env:$var = "$value;${env:$var}"
}

# Chocolatey
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Status "Chocolatey installed."
} else {
    Write-WarningMsg "Chocolatey not found!"
}

# Python
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Status "Python available: $(python --version)"
} else {
    Write-WarningMsg "Python not found!"
}

# Node
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Status "Node.js available: $(node --version)"
} else {
    Write-WarningMsg "Node.js not found!"
}

# vips/glib (assume Chocolatey install locations)
$chocoLib = "$env:ChocolateyInstall\lib"
$vipsInclude = "$chocoLib\vips\tools\include"
$glibInclude = "$chocoLib\glib\tools\include"

Ensure-ProfileExport CPLUS_INCLUDE_PATH "$glibInclude;$vipsInclude"
Ensure-ProfileExport LIBRARY_PATH "$chocoLib\vips\tools\lib;$chocoLib\glib\tools\lib"
Ensure-ProfileExport PKG_CONFIG_PATH "$chocoLib\vips\tools\lib\pkgconfig;$chocoLib\glib\tools\lib\pkgconfig"
Ensure-ProfileExport CXXFLAGS "-I$glibInclude -I$vipsInclude"
Ensure-ProfileExport LDFLAGS "-L$chocoLib\vips\tools\lib -L$chocoLib\glib\tools\lib"

Write-Status "Verification complete."
Write-Status "If you see any warnings above, review your setup or re-run the relevant category script."
Write-Status "You may need to restart your terminal or run '. $PROFILE' to apply new environment variables." 