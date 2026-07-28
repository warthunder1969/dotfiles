<#
.SYNOPSIS
    Enables or disables the Windows Update service (wuauserv) properly.

.DESCRIPTION
    Prompts the user to choose Disable or Enable, then stops/starts the
    service AND changes its startup type, so the setting persists across
    reboots. Must be run as Administrator.
#>

# --- Check for admin rights ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "This script must be run as Administrator. Right-click PowerShell -> 'Run as administrator'." -ForegroundColor Red
    exit 1
}

$serviceName = "wuauserv"

try {
    $service = Get-Service -Name $serviceName -ErrorAction Stop
} catch {
    Write-Host "Could not find the Windows Update service ($serviceName)." -ForegroundColor Red
    exit 1
}

# --- Show current status ---
Write-Host ""
Write-Host "Current Windows Update service status:" -ForegroundColor Cyan
Get-Service -Name $serviceName | Select-Object Name, Status, StartType | Format-Table -AutoSize
Write-Host ""

# --- Prompt the user ---
do {
    $choice = Read-Host "Do you want to (D)isable or (E)nable Windows Update? [D/E]"
    $choice = $choice.Trim().ToUpper()
} while ($choice -ne "D" -and $choice -ne "E")

if ($choice -eq "D") {
    Write-Host ""
    Write-Host "Stopping Windows Update service..." -ForegroundColor Yellow
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue

    Write-Host "Setting startup type to Disabled..." -ForegroundColor Yellow
    Set-Service -Name $serviceName -StartupType Disabled

    Write-Host "Windows Update service is now DISABLED." -ForegroundColor Green
}
elseif ($choice -eq "E") {
    Write-Host ""
    Write-Host "Setting startup type to Manual (Windows default)..." -ForegroundColor Yellow
    Set-Service -Name $serviceName -StartupType Manual

    Write-Host "Starting Windows Update service..." -ForegroundColor Yellow
    Start-Service -Name $serviceName -ErrorAction SilentlyContinue

    Write-Host "Windows Update service is now ENABLED." -ForegroundColor Green
}

# --- Confirm final state ---
Write-Host ""
Write-Host "Final status:" -ForegroundColor Cyan
Get-Service -Name $serviceName | Select-Object Name, Status, StartType | Format-Table -AutoSize
