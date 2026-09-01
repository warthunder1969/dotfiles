function Show-TUI-Menu {
    param (
        [string]$Title = "Main Menu",
        [array]$Options = @("Install Software", "Apply Tweaks", "Cleanup System", "Quit")
    )

    do {
        Clear-Host
        Write-Host "================ $Title ================" -ForegroundColor Cyan
        for ($i = 0; $i -lt $Options.Count; $i++) {
            if ($Options[$i] -eq "Quit") {
                Write-Host "$($i + 1): $Options[$i]" -ForegroundColor Red
            } else {
                Write-Host "$($i + 1): $Options[$i]" -ForegroundColor Yellow
            }
        }

        $selection = Read-Host "`nPlease select an option (1-$($Options.Count))"

        # Validate input is a number within range
        if ($selection -match '^\d+$' -and [int]$selection -ge 1 -and [int]$selection -le $Options.Count) {
            $index = [int]$selection - 1

            if ($Options[$index] -eq "Quit") {
                Write-Host "`nExiting menu." -ForegroundColor Green
                return
                }
                # Option 1: Install Software via Chocolatey
                Write-Host "`n--- Install Software ---" -ForegroundColor Cyan
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
                    "googlechrome",
                    "keepassxc",
                    "git",
                    "vlc",
                    "thunderbird",
                    "discord",
                    "element-desktop",
                    "foxitreader",
                    "winrar",
                    "notepadplusplus",
                    "open-shell",
                    "alacritty",
                    "dotnet-6.0-desktopruntime"

                )

                # Bulk install all listed applications silently
                Write-Host "Starting software installations..." -ForegroundColor Cyan
                foreach ($App in $Apps) {
                    Write-Host "Installing $App..." -ForegroundColor Green
                    choco install $App -y --no-progress
                }

                Write-Host "All software installations completed!" -ForegroundColor Cyan

        }

            } else {

                Write-Host "`n--- Apply Tweaks ---" -ForegroundColor Green
                # Enable Dark Mode
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWORD -Force
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWORD -Force

                # Move Start Menu to the left
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -PropertyType DWORD -Force

                # Change Explorer View Mode to Compact
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "UseCompactMode" -Value 1 -PropertyType DWORD -Force

                # Set Explorer to Open This PC First
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -PropertyType DWORD -Force

                # Show File Extensions
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -PropertyType DWORD -Force

                # Don't hide file types for known files
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

                # Do not show recent folders in Quick Access
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0

                # Do not show recent files
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0

                # Hide Search Box
                Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchBoxTaskbarMode" -Value 0 -Type DWord -Force

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


                Start-Sleep -Seconds 2 # Simulate work
            }
        } else {
            Write-Host "`nInvalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    } while ($true)
}

# Run the menu
Show-TUI-Menu -Title "System Control" -Options @("Check Status", "Restart Service", "View Logs", "Quit")
