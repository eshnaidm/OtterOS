=======================================
  OtterOS - Scripts Guide
=======================================

All scripts should be run as Administrator.
Right-click > "Run as Administrator" or use:
  powershell -ExecutionPolicy Bypass -File "ScriptName.ps1"

SCRIPTS:
--------

PostInstall.ps1
  Interactive menu that combines all other scripts.
  Start here for a fresh install workflow.

RemoveBloatware.ps1
  Removes pre-installed Windows apps (Candy Crush, Xbox,
  Maps, Weather, etc.) and prevents re-installation.

SetDefaults.ps1
  Applies all common technician settings:
  - Show file extensions & hidden files
  - Classic right-click menu (Win11)
  - High performance power plan
  - Disable sleep/hibernation
  - Disable telemetry
  - Disable Cortana/widgets/chat
  - Network latency optimizations

InstallCommon.ps1
  Install common software via winget (Chrome, 7-Zip, VLC, etc.)
  Requires internet connection.

WORKFLOW FOR FRESH INSTALL:
---------------------------
1. Boot from OtterOS USB > Install Windows
2. After Windows boots, plug USB back in
3. Run _LAUNCH.bat from USB root
4. Option 1: Run SDIO to install drivers
5. Option 8: Run Post-Install script
   - Remove bloatware
   - Set defaults
   - Install common apps
6. Restart
7. Done!
