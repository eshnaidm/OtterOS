# OtterOS - Remove Windows Bloatware
# Removes pre-installed Windows apps that are unnecessary for most users
# Run as Administrator

#Requires -RunAsAdministrator

Write-Host "`n  OtterOS Bloatware Removal" -ForegroundColor Cyan
Write-Host "  ========================`n" -ForegroundColor Cyan

$bloatApps = @(
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.GamingApp"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MixedReality.Portal"
    "Microsoft.People"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.SkypeApp"
    "Microsoft.Todos"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "MicrosoftCorporationII.QuickAssist"
    "MicrosoftTeams"
    "Clipchamp.Clipchamp"
    "Microsoft.549981C3F5F10"
    "Disney.37853FC22B2CE"
    "SpotifyAB.SpotifyMusic"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "Facebook.Facebook"
    "BytedancePte.Ltd.TikTok"
    "AmazonVideo.PrimeVideo"
    "Microsoft.OutlookForWindows"
)

$removed = 0
$failed = 0

foreach ($app in $bloatApps) {
    $package = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
    if ($package) {
        Write-Host "  Removing: $app" -ForegroundColor Yellow
        try {
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Stop
            $removed++
        } catch {
            Write-Host "    Warning: Could not fully remove $app" -ForegroundColor DarkYellow
            $failed++
        }
    }

    # Also remove provisioned package (prevents reinstall on new user accounts)
    $provisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.PackageName -like "*$app*" }
    if ($provisioned) {
        try {
            $provisioned | Remove-AppxProvisionedPackage -Online -ErrorAction Stop | Out-Null
        } catch {
            # Silently continue - provisioned removal sometimes fails on active packages
        }
    }
}

Write-Host ""
Write-Host "  Results:" -ForegroundColor Cyan
Write-Host "    Removed: $removed apps" -ForegroundColor Green
Write-Host "    Failed:  $failed apps" -ForegroundColor $(if ($failed -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

# Disable consumer features (prevents re-installation of bloat)
$cdmPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
if (!(Test-Path $cdmPath)) { New-Item -Path $cdmPath -Force | Out-Null }
Set-ItemProperty -Path $cdmPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord
Set-ItemProperty -Path $cdmPath -Name "DisableConsumerAccountStateContent" -Value 1 -Type DWord

# Disable suggested apps in Start
$contentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty -Path $contentPath -Name "SilentInstalledAppsEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $contentPath -Name "OemPreInstalledAppsEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $contentPath -Name "PreInstalledAppsEnabled" -Value 0 -Type DWord

Write-Host "  Disabled future bloatware re-installation." -ForegroundColor Green
