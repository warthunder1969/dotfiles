# Ensure the execution policy allows running scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey
if (-not (Test-Path -Path "$env:ProgramData\Chocolatey")) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Reload environment variables so 'choco' is immediately recognized
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

choco feature enable -n allowGlobalConfirmation

# Define Packages
$Apps = @(
    "chocolateygui",
    "brave",
    "keepassxc",
    "git",
    "vlc",
    "foxitreader",
    "7zip",
    "notepadplusplus",
    "wezterm",
    "dotnet-6.0-desktopruntime"	

)

# Bulk install all listed applications silently
Write-Host "Starting software installations..." -ForegroundColor Cyan
foreach ($App in $Apps) {
    Write-Host "Installing $App..." -ForegroundColor Green
    choco install $App -y --no-progress
}

Write-Host "All software installations completed!" -ForegroundColor Cyan

# Tweaks/Settings


# Enable Dark Mode
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWORD -Force

# Move Start Menu to the left
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -PropertyType DWORD -Force

# Change Explorer View Mode to Compact
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Value 1 -PropertyType DWORD -Force

# Set Explorer to Open This PC First
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -PropertyType DWORD -Force

# Show Hidden Files
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -PropertyType DWORD -Force
# Show File Extensions
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -PropertyType DWORD -Force

# Don't hide file types for known files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Do not show recent folders in Quick Access
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0

# Do not show recent files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0

# Hide Search Box
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force

# Remove Widgets/weather/news

$settings = [PSCustomObject]@{
    Path  = "SOFTWARE\Policies\Microsoft\Dsh"
    Value = 0
    Name  = "AllowNewsAndInterests"
} | group Path

foreach ($setting in $settings) {
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($setting.Name, $true)
    if ($null -eq $registry) {
        $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($setting.Name, $true)
    }
    $setting.Group | % {
        if (!$_.Type) {
            $registry.SetValue($_.name, $_.value)
        }
        else {
            $registry.SetValue($_.name, $_.value, $_.type)
        }
    }
    $registry.Dispose()
}

# Restart Explorer to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer

# Set Browser Defaults
$associations_xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="FirefoxHTML" ApplicationName="Brave" />
  <Association Identifier=".html" ProgId="FirefoxHTML" ApplicationName="Brave" />
  <Association Identifier=".pdf" ProgId="AcroExch.Document.DC" ApplicationName="Brave" />
  <Association Identifier="http" ProgId="FirefoxURL" ApplicationName="Brave" />
  <Association Identifier="https" ProgId="FirefoxURL" ApplicationName="Brave" />
</DefaultAssociations>
"@

$provisioning = ni "$($env:ProgramData)\provisioning" -ItemType Directory -Force

$associations_xml | Out-File "$($provisioning.FullName)\associations.xml" -Encoding utf8

dism /online /Import-DefaultAppAssociations:"$($provisioning.FullName)\associations.xml"
TOC
