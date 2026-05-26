# OtterOS Post-Install Script
# Run this after a fresh Windows installation to configure the system
# Must be run as Administrator

#Requires -RunAsAdministrator

$Host.UI.RawUI.WindowTitle = "OtterOS Post-Install"

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor Cyan
    Write-Host "       OtterOS Post-Install Configuration" -ForegroundColor White
    Write-Host "  ============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   [1] Remove Bloatware (preinstalled apps)" -ForegroundColor Yellow
    Write-Host "   [2] Disable Telemetry & Tracking" -ForegroundColor Yellow
    Write-Host "   [3] Set High Performance Power Plan" -ForegroundColor Yellow
    Write-Host "   [4] Apply Registry Tweaks (performance/privacy)" -ForegroundColor Yellow
    Write-Host "   [5] Install Common Software (via winget)" -ForegroundColor Yellow
    Write-Host "   [6] Disable Sleep & Hibernation" -ForegroundColor Yellow
    Write-Host "   [7] Launch Snappy Driver Installer" -ForegroundColor Yellow
    Write-Host "   [8] Show System Info" -ForegroundColor Yellow
    Write-Host "   [9] Run ALL (1-6 in sequence)" -ForegroundColor Green
    Write-Host "   [0] Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "  ============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Remove-Bloatware {
    Write-Host "`n  Removing Windows Bloatware..." -ForegroundColor Cyan
    $ScriptPath = Join-Path $PSScriptRoot "RemoveBloatware.ps1"
    if (Test-Path $ScriptPath) {
        & $ScriptPath
    } else {
        Write-Host "  RemoveBloatware.ps1 not found at: $ScriptPath" -ForegroundColor Red
    }
}

function Disable-Telemetry {
    Write-Host "`n  Disabling Telemetry & Tracking..." -ForegroundColor Cyan

    # Disable telemetry service
    Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue

    # Disable Connected User Experiences
    Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue

    # Registry: Disable telemetry
    $telemetryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (!(Test-Path $telemetryPath)) { New-Item -Path $telemetryPath -Force | Out-Null }
    Set-ItemProperty -Path $telemetryPath -Name "AllowTelemetry" -Value 0 -Type DWord

    # Disable feedback notifications
    $feedbackPath = "HKCU:\Software\Microsoft\Siuf\Rules"
    if (!(Test-Path $feedbackPath)) { New-Item -Path $feedbackPath -Force | Out-Null }
    Set-ItemProperty -Path $feedbackPath -Name "NumberOfSIUFInPeriod" -Value 0 -Type DWord

    # Disable advertising ID
    $advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    if (!(Test-Path $advPath)) { New-Item -Path $advPath -Force | Out-Null }
    Set-ItemProperty -Path $advPath -Name "Enabled" -Value 0 -Type DWord

    # Disable activity history
    $activityPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    if (!(Test-Path $activityPath)) { New-Item -Path $activityPath -Force | Out-Null }
    Set-ItemProperty -Path $activityPath -Name "EnableActivityFeed" -Value 0 -Type DWord
    Set-ItemProperty -Path $activityPath -Name "PublishUserActivities" -Value 0 -Type DWord
    Set-ItemProperty -Path $activityPath -Name "UploadUserActivities" -Value 0 -Type DWord

    Write-Host "  Done. Telemetry disabled." -ForegroundColor Green
}

function Set-HighPerformance {
    Write-Host "`n  Setting High Performance Power Plan..." -ForegroundColor Cyan

    # Activate High Performance plan
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null

    # If that fails, create Ultimate Performance
    if ($LASTEXITCODE -ne 0) {
        powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        if ($LASTEXITCODE -ne 0) {
            powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        }
    }

    Write-Host "  Done. High Performance power plan active." -ForegroundColor Green
}

function Set-RegistryTweaks {
    Write-Host "`n  Applying Registry Tweaks..." -ForegroundColor Cyan

    # Show file extensions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

    # Show hidden files
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

    # Disable Cortana
    $cortanaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    if (!(Test-Path $cortanaPath)) { New-Item -Path $cortanaPath -Force | Out-Null }
    Set-ItemProperty -Path $cortanaPath -Name "AllowCortana" -Value 0 -Type DWord

    # Disable web search in Start menu
    Set-ItemProperty -Path $cortanaPath -Name "DisableWebSearch" -Value 1 -Type DWord
    Set-ItemProperty -Path $cortanaPath -Name "ConnectedSearchUseWeb" -Value 0 -Type DWord

    # Disable lock screen tips
    $lockPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty -Path $lockPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $lockPath -Name "SubscribedContent-338387Enabled" -Value 0 -Type DWord

    # Disable Start menu suggestions
    Set-ItemProperty -Path $lockPath -Name "SystemPaneSuggestionsEnabled" -Value 0 -Type DWord

    # Classic right-click menu (Windows 11)
    $contextPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    if (!(Test-Path $contextPath)) { New-Item -Path $contextPath -Force | Out-Null }
    Set-ItemProperty -Path $contextPath -Name "(Default)" -Value "" -Type String

    # Disable snap assist flyout
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SnapAssist" -Value 0 -Type DWord

    # Taskbar: Disable widgets, chat, search
    $taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $taskbarPath -Name "TaskbarDa" -Value 0 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $taskbarPath -Name "TaskbarMn" -Value 0 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $taskbarPath -Name "ShowTaskViewButton" -Value 0 -Type DWord

    $searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    if (!(Test-Path $searchPath)) { New-Item -Path $searchPath -Force | Out-Null }
    Set-ItemProperty -Path $searchPath -Name "SearchboxTaskbarMode" -Value 1 -Type DWord

    Write-Host "  Done. Registry tweaks applied." -ForegroundColor Green
    Write-Host "  Note: Some changes require a restart or Explorer restart." -ForegroundColor Yellow
}

function Install-CommonSoftware {
    Write-Host "`n  Installing Common Software via winget..." -ForegroundColor Cyan
    Write-Host "  (Requires internet connection)" -ForegroundColor Yellow
    Write-Host ""

    $apps = @(
        @{Name="Google Chrome"; Id="Google.Chrome"},
        @{Name="7-Zip"; Id="7zip.7zip"},
        @{Name="VLC Media Player"; Id="VideoLAN.VLC"},
        @{Name="Notepad++"; Id="Notepad++.Notepad++"},
        @{Name="Adobe Acrobat Reader"; Id="Adobe.Acrobat.Reader.64-bit"}
    )

    Write-Host "  Available apps to install:" -ForegroundColor White
    for ($i = 0; $i -lt $apps.Count; $i++) {
        Write-Host "    [$($i+1)] $($apps[$i].Name)"
    }
    Write-Host "    [A] All"
    Write-Host "    [S] Skip"
    Write-Host ""
    $appChoice = Read-Host "  Select (comma-separated numbers, A for all, S to skip)"

    if ($appChoice -eq "S" -or $appChoice -eq "s") { return }

    $toInstall = @()
    if ($appChoice -eq "A" -or $appChoice -eq "a") {
        $toInstall = $apps
    } else {
        $indices = $appChoice -split "," | ForEach-Object { [int]$_.Trim() - 1 }
        foreach ($idx in $indices) {
            if ($idx -ge 0 -and $idx -lt $apps.Count) {
                $toInstall += $apps[$idx]
            }
        }
    }

    foreach ($app in $toInstall) {
        Write-Host "  Installing $($app.Name)..." -ForegroundColor White
        winget install --id $app.Id --accept-source-agreements --accept-package-agreements --silent 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    OK" -ForegroundColor Green
        } else {
            Write-Host "    Failed or already installed" -ForegroundColor Yellow
        }
    }
}

function Disable-SleepHibernation {
    Write-Host "`n  Disabling Sleep & Hibernation..." -ForegroundColor Cyan

    # Disable hibernation
    powercfg /hibernate off

    # Set sleep to never (AC)
    powercfg /change standby-timeout-ac 0
    powercfg /change monitor-timeout-ac 15

    # Set sleep to never (battery)
    powercfg /change standby-timeout-dc 0
    powercfg /change monitor-timeout-dc 10

    Write-Host "  Done. Sleep disabled, monitor off after 15min (AC) / 10min (battery)." -ForegroundColor Green
}

function Launch-SDIO {
    $sdioPath = Join-Path (Split-Path $PSScriptRoot) "Drivers\SDIO"
    $sdioExe = Get-ChildItem -Path $sdioPath -Filter "SDIO*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($sdioExe) {
        Write-Host "  Launching SDIO: $($sdioExe.FullName)" -ForegroundColor Cyan
        Start-Process $sdioExe.FullName
    } else {
        Write-Host "  SDIO not found in: $sdioPath" -ForegroundColor Red
        Write-Host "  Download from: glenn.delahoy.com/snappy-driver-installer-origin/" -ForegroundColor Yellow
    }
}

function Show-SystemInfo {
    Write-Host "`n  System Information:" -ForegroundColor Cyan
    Write-Host "  -------------------" -ForegroundColor Cyan

    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $disk = Get-CimInstance Win32_DiskDrive | Select-Object -First 1

    Write-Host "  OS:     $($os.Caption) $($os.OSArchitecture)" -ForegroundColor White
    Write-Host "  Build:  $($os.BuildNumber)" -ForegroundColor White
    Write-Host "  CPU:    $($cpu.Name)" -ForegroundColor White
    Write-Host "  RAM:    ${ram} GB" -ForegroundColor White
    Write-Host "  Disk:   $($disk.Model) ($([math]::Round($disk.Size / 1GB, 0)) GB)" -ForegroundColor White
    Write-Host ""
}

function Run-All {
    Write-Host "`n  Running ALL post-install steps..." -ForegroundColor Magenta
    Remove-Bloatware
    Disable-Telemetry
    Set-HighPerformance
    Set-RegistryTweaks
    Disable-SleepHibernation
    Write-Host "`n  ALL steps complete!" -ForegroundColor Green
    Write-Host "  Restart recommended for all changes to take effect." -ForegroundColor Yellow
}

# Main loop
do {
    Show-Menu
    $input = Read-Host "  Select option"

    switch ($input) {
        "1" { Remove-Bloatware; Read-Host "`n  Press Enter to continue" }
        "2" { Disable-Telemetry; Read-Host "`n  Press Enter to continue" }
        "3" { Set-HighPerformance; Read-Host "`n  Press Enter to continue" }
        "4" { Set-RegistryTweaks; Read-Host "`n  Press Enter to continue" }
        "5" { Install-CommonSoftware; Read-Host "`n  Press Enter to continue" }
        "6" { Disable-SleepHibernation; Read-Host "`n  Press Enter to continue" }
        "7" { Launch-SDIO; Read-Host "`n  Press Enter to continue" }
        "8" { Show-SystemInfo; Read-Host "`n  Press Enter to continue" }
        "9" { Run-All; Read-Host "`n  Press Enter to continue" }
        "0" { break }
        default { Write-Host "  Invalid option." -ForegroundColor Red; Start-Sleep 1 }
    }
} while ($input -ne "0")
