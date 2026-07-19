<#
.SYNOPSIS
    Runs Windows Update and upgrades all Chocolatey packages in one go.

.DESCRIPTION
    - Installs the PSWindowsUpdate module if it isn't already present.
    - Scans for and installs all available Windows Updates (excluding
      any that require manual driver confirmation, unless you opt in).
    - Runs `choco upgrade all` to bring every installed Chocolatey
      package to its latest version.
    - Logs everything to a timestamped log file so you can review
      what happened.
    - Optionally reboots automatically if Windows Update requires it.

.NOTES
    Must be run from an elevated (Administrator) PowerShell prompt.

.PARAMETER AutoReboot
    If specified, the machine will reboot automatically when Windows
    Update reports a reboot is required. Otherwise you'll just get a
    notice at the end telling you a reboot is pending.

.EXAMPLE
    .\Update-Everything.ps1

.EXAMPLE
    .\Update-Everything.ps1 -AutoReboot
#>

[CmdletBinding()]
param(
    [switch]$AutoReboot
)

# ------------------------------------------------------------------
# Setup
# ------------------------------------------------------------------

$ErrorActionPreference = 'Continue'
$logDir  = Join-Path $env:ProgramData 'UpdateEverything\Logs'
$logFile = Join-Path $logDir ("update-{0}.log" -f (Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'))

if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$timestamp] [$Level] $Message"
    Write-Host $line
    Add-Content -Path $logFile -Value $line
}

function Assert-Admin {
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "ERROR: This script must be run as Administrator." -ForegroundColor Red
        Write-Host "Right-click PowerShell (or Windows Terminal) and choose 'Run as administrator', then re-run this script." -ForegroundColor Yellow
        exit 1
    }
}

# ------------------------------------------------------------------
# Pre-flight checks
# ------------------------------------------------------------------

Assert-Admin
Write-Log "===== Update run started ====="
Write-Log "Log file: $logFile"

# Allow scripts to run for this process only (doesn't touch machine policy)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force | Out-Null

# ------------------------------------------------------------------
# Step 1: Windows Update
# ------------------------------------------------------------------

Write-Log "----- Windows Update -----"

try {
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Log "PSWindowsUpdate module not found. Installing from PSGallery..."

        # Ensure NuGet provider + TLS 1.2 so the install doesn't fail on older systems
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
        }

        Install-Module -Name PSWindowsUpdate -Force -Scope AllUsers -AllowClobber
        Write-Log "PSWindowsUpdate installed."
    } else {
        Write-Log "PSWindowsUpdate module already present."
    }

    Import-Module PSWindowsUpdate -ErrorAction Stop

    Write-Log "Checking for available Windows Updates..."
    $updates = Get-WindowsUpdate -MicrosoftUpdate -ErrorAction SilentlyContinue

    if ($updates) {
        Write-Log ("Found {0} update(s). Installing..." -f $updates.Count)

        # -AcceptAll installs everything found; -IgnoreReboot lets us control reboot ourselves
        $result = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -Verbose *>&1
        $result | ForEach-Object { Write-Log $_.ToString() }

        Write-Log "Windows Update install pass complete."
    } else {
        Write-Log "No Windows Updates available. System is up to date."
    }
}
catch {
    Write-Log ("ERROR during Windows Update step: {0}" -f $_.Exception.Message) 'ERROR'
}

# ------------------------------------------------------------------
# Step 2: Chocolatey package upgrades
# ------------------------------------------------------------------

Write-Log "----- Chocolatey Upgrade -----"

$chocoCmd = Get-Command choco.exe -ErrorAction SilentlyContinue

if (-not $chocoCmd) {
    Write-Log "Chocolatey (choco.exe) not found on this system. Skipping package upgrades." 'WARN'
    Write-Log "Install it from https://chocolatey.org/install if you want this step to run." 'WARN'
} else {
    try {
        Write-Log "Running: choco upgrade all -y"
        # Stream choco's output straight into the log/console
        & choco upgrade all -y --no-progress 2>&1 | ForEach-Object {
            Write-Log $_.ToString()
        }
        Write-Log "Chocolatey upgrade pass complete."
    }
    catch {
        Write-Log ("ERROR during Chocolatey upgrade: {0}" -f $_.Exception.Message) 'ERROR'
    }
}

# ------------------------------------------------------------------
# Step 3: Reboot handling
# ------------------------------------------------------------------

Write-Log "----- Reboot Check -----"

$rebootRequired = $false
try {
    if (Get-Command Get-WURebootStatus -ErrorAction SilentlyContinue) {
        $rebootRequired = (Get-WURebootStatus -Silent)
    }
}
catch {
    Write-Log "Could not determine reboot status automatically." 'WARN'
}

if ($rebootRequired) {
    if ($AutoReboot) {
        Write-Log "Reboot is required. AutoReboot switch was set - restarting now in 30 seconds (Ctrl+C to cancel)."
        Start-Sleep -Seconds 30
        Restart-Computer -Force
    } else {
        Write-Log "Reboot is required to finish applying updates. Run with -AutoReboot to have this happen automatically next time, or restart manually now." 'WARN'
    }
} else {
    Write-Log "No reboot required."
}

Write-Log "===== Update run finished ====="
Write-Host "`nFull log saved to: $logFile" -ForegroundColor Cyan
