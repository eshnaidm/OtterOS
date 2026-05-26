# OtterOS - Install Common Software
# Uses winget to install frequently needed applications
# Requires internet connection

Write-Host "`n  OtterOS Common Software Installer" -ForegroundColor Cyan
Write-Host "  ==================================`n" -ForegroundColor Cyan

# Check winget availability
$winget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $winget) {
    Write-Host "  ERROR: winget not found." -ForegroundColor Red
    Write-Host "  winget is included in Windows 10 (1809+) and Windows 11." -ForegroundColor Yellow
    Write-Host "  Try: 'Add-AppxPackage' with the App Installer package from Microsoft Store." -ForegroundColor Yellow
    exit 1
}

# Check internet
$internet = Test-NetConnection -ComputerName "8.8.8.8" -Port 53 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if (-not $internet.TcpTestSucceeded) {
    Write-Host "  ERROR: No internet connection detected." -ForegroundColor Red
    Write-Host "  Connect to the internet and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host "  Select software to install:" -ForegroundColor White
Write-Host ""
Write-Host "  --- Browsers ---" -ForegroundColor Yellow
Write-Host "   [1] Google Chrome"
Write-Host "   [2] Mozilla Firefox"
Write-Host ""
Write-Host "  --- Utilities ---" -ForegroundColor Yellow
Write-Host "   [3] 7-Zip"
Write-Host "   [4] Notepad++"
Write-Host "   [5] VLC Media Player"
Write-Host "   [6] Adobe Acrobat Reader"
Write-Host "   [7] WinRAR"
Write-Host ""
Write-Host "  --- Communication ---" -ForegroundColor Yellow
Write-Host "   [8] Discord"
Write-Host "   [9] Telegram"
Write-Host ""
Write-Host "  --- Development ---" -ForegroundColor Yellow
Write-Host "  [10] Visual Studio Code"
Write-Host "  [11] Git"
Write-Host ""
Write-Host "  --- Gaming ---" -ForegroundColor Yellow
Write-Host "  [12] Steam"
Write-Host "  [13] MSI Afterburner"
Write-Host ""
Write-Host "  -------------------------" -ForegroundColor DarkGray
Write-Host "   [A] ALL essentials (1,3,4,5,6)"
Write-Host "   [G] Gaming pack (1,3,5,12,13)"
Write-Host "   [S] Skip / Exit"
Write-Host ""

$appMap = @{
    "1"  = @{Name="Google Chrome"; Id="Google.Chrome"}
    "2"  = @{Name="Mozilla Firefox"; Id="Mozilla.Firefox"}
    "3"  = @{Name="7-Zip"; Id="7zip.7zip"}
    "4"  = @{Name="Notepad++"; Id="Notepad++.Notepad++"}
    "5"  = @{Name="VLC Media Player"; Id="VideoLAN.VLC"}
    "6"  = @{Name="Adobe Acrobat Reader"; Id="Adobe.Acrobat.Reader.64-bit"}
    "7"  = @{Name="WinRAR"; Id="RARLab.WinRAR"}
    "8"  = @{Name="Discord"; Id="Discord.Discord"}
    "9"  = @{Name="Telegram"; Id="Telegram.TelegramDesktop"}
    "10" = @{Name="Visual Studio Code"; Id="Microsoft.VisualStudioCode"}
    "11" = @{Name="Git"; Id="Git.Git"}
    "12" = @{Name="Steam"; Id="Valve.Steam"}
    "13" = @{Name="MSI Afterburner"; Id="Guru3D.Afterburner"}
}

$choice = Read-Host "  Enter numbers (comma-separated), A, G, or S"

if ($choice -eq "S" -or $choice -eq "s") { exit 0 }

$selectedKeys = @()
if ($choice -eq "A" -or $choice -eq "a") {
    $selectedKeys = @("1","3","4","5","6")
} elseif ($choice -eq "G" -or $choice -eq "g") {
    $selectedKeys = @("1","3","5","12","13")
} else {
    $selectedKeys = $choice -split "," | ForEach-Object { $_.Trim() }
}

Write-Host ""
$success = 0
$fail = 0

foreach ($key in $selectedKeys) {
    if ($appMap.ContainsKey($key)) {
        $app = $appMap[$key]
        Write-Host "  Installing $($app.Name)..." -ForegroundColor White -NoNewline
        $result = winget install --id $app.Id --accept-source-agreements --accept-package-agreements --silent 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host " OK" -ForegroundColor Green
            $success++
        } else {
            Write-Host " FAILED (may already be installed)" -ForegroundColor Yellow
            $fail++
        }
    } else {
        Write-Host "  Invalid selection: $key" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  Results: $success installed, $fail failed/skipped" -ForegroundColor Cyan
