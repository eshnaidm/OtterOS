# OtterOS USB Setup Script
# Creates the full folder structure on a USB drive
# Usage: powershell -ExecutionPolicy Bypass -File setup.ps1 -Drive F:
#
# Run this AFTER installing Ventoy on the USB drive.

param(
    [Parameter(Mandatory=$false)]
    [string]$Drive
)

# ── Banner ────────────────────────────────────────────────────────────────────

Clear-Host
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║       OtterOS USB Setup Script           ║" -ForegroundColor Cyan
Write-Host "  ║   Creates folder structure on USB drive  ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Drive selection ──────────────────────────────────────────────────────────

if (-not $Drive) {
    Write-Host "  Available removable drives:" -ForegroundColor Yellow
    Write-Host ""
    Get-Volume | Where-Object { $_.DriveType -eq "Removable" -and $_.DriveLetter } | ForEach-Object {
        $size = [math]::Round($_.Size / 1GB, 0)
        Write-Host "    $($_.DriveLetter):  $($_.FileSystemLabel)  ($size GB  $($_.FileSystem))" -ForegroundColor White
    }
    Write-Host ""
    $Drive = Read-Host "  Enter USB drive letter (e.g. F)"
    $Drive = $Drive.TrimEnd(':').ToUpper()
}

$Drive = $Drive.TrimEnd(':').ToUpper()
$Root = "${Drive}:"

# ── Validate drive ────────────────────────────────────────────────────────────

if (-not (Test-Path "$Root\")) {
    Write-Host "  ERROR: Drive $Root not found." -ForegroundColor Red
    exit 1
}

$vol = Get-Volume -DriveLetter $Drive -ErrorAction SilentlyContinue
if (-not $vol) {
    Write-Host "  ERROR: Could not read volume info for $Root" -ForegroundColor Red
    exit 1
}

$sizeGB = [math]::Round($vol.Size / 1GB, 0)
$label  = if ($vol.FileSystemLabel) { $vol.FileSystemLabel } else { "(no label)" }

Write-Host "  Target drive: $Root  [$label]  $sizeGB GB  $($vol.FileSystem)" -ForegroundColor White
Write-Host ""

if ($sizeGB -lt 64) {
    Write-Host "  WARNING: Drive is only ${sizeGB}GB. OtterOS requires 256GB for full driver packs." -ForegroundColor Yellow
    Write-Host "  You can still set up the folder structure, but large files may not fit." -ForegroundColor Yellow
    Write-Host ""
}

$confirm = Read-Host "  Create OtterOS folder structure on ${Root}? (Y/N)"
if ($confirm -notmatch "^[Yy]") {
    Write-Host "  Cancelled." -ForegroundColor Red
    exit 0
}

Write-Host ""

# ── Create folders ────────────────────────────────────────────────────────────

$folders = @(
    # ISO categories
    "ISO\Windows",
    "ISO\Recovery",
    "ISO\Linux",
    "ISO\Tools",

    # Ventoy config and theme
    "ventoy\theme",
    "ventoy\auto_install",

    # Toolkit - drivers
    "Toolkit\Drivers\SDIO\drivers",
    "Toolkit\Drivers\GPU_NVIDIA",
    "Toolkit\Drivers\GPU_AMD",
    "Toolkit\Drivers\GPU_Intel",
    "Toolkit\Drivers\Chipset_AMD",
    "Toolkit\Drivers\Intel_IRST",
    "Toolkit\Drivers\Intel_ME",
    "Toolkit\Drivers\Intel_DSA",
    "Toolkit\Drivers\LAN_WiFi",

    # Toolkit - tools and scripts
    "Toolkit\Tools",
    "Toolkit\Scripts",
    "Toolkit\Configs"
)

foreach ($folder in $folders) {
    $fullPath = Join-Path $Root $folder
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  [+] $folder" -ForegroundColor Green
    } else {
        Write-Host "  [=] $folder (already exists)" -ForegroundColor DarkGray
    }
}

Write-Host ""

# ── Copy config files from script location ────────────────────────────────────

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "  Copying config files from repo..." -ForegroundColor Cyan
Write-Host ""

$copies = @(
    @{ Src = "autounattend.xml";        Dst = "$Root\autounattend.xml" },
    @{ Src = "README.txt";              Dst = "$Root\README.txt" },
    @{ Src = "ventoy\ventoy.json";      Dst = "$Root\ventoy\ventoy.json" },
    @{ Src = "ventoy\theme\theme.txt";  Dst = "$Root\ventoy\theme\theme.txt" },
    @{ Src = "Toolkit\_LAUNCH.bat";     Dst = "$Root\Toolkit\_LAUNCH.bat" }
)

foreach ($item in $copies) {
    $src = Join-Path $scriptDir $item.Src
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $item.Dst -Force
        Write-Host "  [+] Copied: $($item.Src)" -ForegroundColor Green
    } else {
        Write-Host "  [!] Not found (skip): $($item.Src)" -ForegroundColor Yellow
    }
}

# Copy all scripts
$scriptsDir = Join-Path $scriptDir "Toolkit\Scripts"
if (Test-Path $scriptsDir) {
    Get-ChildItem -Path $scriptsDir | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$Root\Toolkit\Scripts\$($_.Name)" -Force
        Write-Host "  [+] Copied: Toolkit\Scripts\$($_.Name)" -ForegroundColor Green
    }
}

# Copy auto_install XMLs
$autoInstallDir = Join-Path $scriptDir "ventoy\auto_install"
if (Test-Path $autoInstallDir) {
    Get-ChildItem -Path $autoInstallDir -Filter "*.xml" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$Root\ventoy\auto_install\$($_.Name)" -Force
        Write-Host "  [+] Copied: ventoy\auto_install\$($_.Name)" -ForegroundColor Green
    }
}

# Copy Configs
$configsDir = Join-Path $scriptDir "Toolkit\Configs"
if (Test-Path $configsDir) {
    Get-ChildItem -Path $configsDir | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$Root\Toolkit\Configs\$($_.Name)" -Force
        Write-Host "  [+] Copied: Toolkit\Configs\$($_.Name)" -ForegroundColor Green
    }
}

# ── Summary ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  ════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "   1. Add background image: $Root\ventoy\theme\background.png" -ForegroundColor Yellow
Write-Host "   2. Download ISOs → $Root\ISO\Windows\  Recovery\  Linux\  Tools\" -ForegroundColor Yellow
Write-Host "   3. Download SDIO + driver packs → $Root\Toolkit\Drivers\SDIO\" -ForegroundColor Yellow
Write-Host "   4. Download portable tools → $Root\Toolkit\Tools\" -ForegroundColor Yellow
Write-Host "   5. Download standalone GPU/chipset drivers to Toolkit\Drivers\GPU_*" -ForegroundColor Yellow
Write-Host ""
Write-Host "  See README.md for all download links." -ForegroundColor Cyan
Write-Host "  ════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
