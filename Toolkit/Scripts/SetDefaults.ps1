# OtterOS - Set System Defaults
# Applies common technician defaults for fresh Windows installations
# Run as Administrator

#Requires -RunAsAdministrator

Write-Host "`n  OtterOS System Defaults" -ForegroundColor Cyan
Write-Host "  =======================`n" -ForegroundColor Cyan

# --- File Explorer Settings ---
Write-Host "  [1/7] Configuring File Explorer..." -ForegroundColor White
$explorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

# Show file extensions
Set-ItemProperty -Path $explorerPath -Name "HideFileExt" -Value 0

# Show hidden files
Set-ItemProperty -Path $explorerPath -Name "Hidden" -Value 1

# Show full path in title bar
Set-ItemProperty -Path $explorerPath -Name "FullPath" -Value 1 -ErrorAction SilentlyContinue

# Open File Explorer to "This PC" instead of Quick Access
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1

Write-Host "    Done" -ForegroundColor Green

# --- Power Settings ---
Write-Host "  [2/7] Setting power configuration..." -ForegroundColor White

# High performance plan
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null

# USB selective suspend: disabled
powercfg /setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 2>$null

# Turn off display after 15 min (AC), 10 min (battery)
powercfg /change monitor-timeout-ac 15
powercfg /change monitor-timeout-dc 10

# Never sleep
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

# Disable hibernation
powercfg /hibernate off

Write-Host "    Done" -ForegroundColor Green

# --- Privacy & Telemetry ---
Write-Host "  [3/7] Disabling telemetry..." -ForegroundColor White

# Telemetry level = 0 (Security only)
$dataPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (!(Test-Path $dataPath)) { New-Item -Path $dataPath -Force | Out-Null }
Set-ItemProperty -Path $dataPath -Name "AllowTelemetry" -Value 0 -Type DWord

# Disable advertising ID
$advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
if (!(Test-Path $advPath)) { New-Item -Path $advPath -Force | Out-Null }
Set-ItemProperty -Path $advPath -Name "Enabled" -Value 0 -Type DWord

# Disable Cortana
$cortanaPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (!(Test-Path $cortanaPath)) { New-Item -Path $cortanaPath -Force | Out-Null }
Set-ItemProperty -Path $cortanaPath -Name "AllowCortana" -Value 0 -Type DWord

# Disable DiagTrack service
Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue

Write-Host "    Done" -ForegroundColor Green

# --- Windows 11 UI Tweaks ---
Write-Host "  [4/7] Applying UI tweaks..." -ForegroundColor White

# Restore classic right-click context menu (Win11)
$contextPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
if (!(Test-Path $contextPath)) { New-Item -Path $contextPath -Force | Out-Null }
Set-ItemProperty -Path $contextPath -Name "(Default)" -Value "" -Type String

# Taskbar: hide widgets, chat, task view
Set-ItemProperty -Path $explorerPath -Name "TaskbarDa" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $explorerPath -Name "TaskbarMn" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $explorerPath -Name "ShowTaskViewButton" -Value 0 -Type DWord

# Search bar: icon only
$searchPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
if (!(Test-Path $searchPath)) { New-Item -Path $searchPath -Force | Out-Null }
Set-ItemProperty -Path $searchPath -Name "SearchboxTaskbarMode" -Value 1 -Type DWord

Write-Host "    Done" -ForegroundColor Green

# --- Disable Unnecessary Services ---
Write-Host "  [5/7] Disabling unnecessary services..." -ForegroundColor White

$servicesToDisable = @(
    "SysMain",           # Superfetch - not needed on SSDs
    "WSearch",           # Windows Search indexing - uses disk I/O
    "MapsBroker",        # Downloaded Maps Manager
    "RetailDemo"         # Retail Demo service
)

foreach ($svc in $servicesToDisable) {
    $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($service -and $service.StartType -ne "Disabled") {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "    Disabled: $svc" -ForegroundColor DarkGray
    }
}

Write-Host "    Done" -ForegroundColor Green

# --- Network Tweaks ---
Write-Host "  [6/7] Applying network tweaks..." -ForegroundColor White

# Disable Nagle's algorithm for lower latency (gaming)
$interfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
foreach ($iface in $interfaces) {
    Set-ItemProperty -Path $iface.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $iface.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
}

# Disable auto-update of network drivers
$wuPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if (!(Test-Path $wuPath)) { New-Item -Path $wuPath -Force | Out-Null }
Set-ItemProperty -Path $wuPath -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord

Write-Host "    Done" -ForegroundColor Green

# --- Desktop Cleanup ---
Write-Host "  [7/7] Cleaning up desktop..." -ForegroundColor White

# Remove Edge shortcut from desktop (if exists)
$edgeShortcut = "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
if (Test-Path $edgeShortcut) {
    Remove-Item $edgeShortcut -Force -ErrorAction SilentlyContinue
}

# Remove other common shortcuts
$shortcuts = @(
    "$env:USERPROFILE\Desktop\Microsoft Edge.lnk",
    "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
)
foreach ($shortcut in $shortcuts) {
    if (Test-Path $shortcut) {
        Remove-Item $shortcut -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "    Done" -ForegroundColor Green

# --- Summary ---
Write-Host ""
Write-Host "  ==============================" -ForegroundColor Cyan
Write-Host "  All defaults applied!" -ForegroundColor Green
Write-Host "  ==============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Changes applied:" -ForegroundColor White
Write-Host "    - File extensions visible" -ForegroundColor DarkGray
Write-Host "    - Hidden files shown" -ForegroundColor DarkGray
Write-Host "    - Classic right-click menu (Win11)" -ForegroundColor DarkGray
Write-Host "    - High performance power plan" -ForegroundColor DarkGray
Write-Host "    - Sleep/hibernation disabled" -ForegroundColor DarkGray
Write-Host "    - Telemetry/tracking disabled" -ForegroundColor DarkGray
Write-Host "    - Widgets/chat/task view hidden" -ForegroundColor DarkGray
Write-Host "    - Network latency optimized" -ForegroundColor DarkGray
Write-Host "    - SysMain/WSearch disabled" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Restart recommended." -ForegroundColor Yellow
