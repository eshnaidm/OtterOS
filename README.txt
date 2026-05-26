╔══════════════════════════════════════════════════════════════════════╗
║                        OtterOS v1.0                                  ║
║                  Professional Technician USB Toolkit                  ║
╚══════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 WHAT IS THIS USB?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 A multi-boot technician USB for PC repair and gaming PC installation.
 Boot from it to get a menu with Windows installers, recovery tools,
 Linux distros and diagnostics. After installing Windows, plug the USB
 back in and use the Toolkit folder for drivers, tools and scripts.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 USB STRUCTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 autounattend.xml     Universal Windows unattended install config
                      (see AUTOUNATTEND section below)

 ISO\
   Windows\           Win11 English, Hebrew, Russian ISOs
   Recovery\          Strelec WinPE, Hiren's BootCD PE, Rescuezilla
   Linux\             Ubuntu, Kali, GParted, SystemRescue
   Tools\             Memtest86, HDAT2

 Toolkit\
   _LAUNCH.bat        Quick launcher menu (run this after install)
   Drivers\           GPU, chipset, LAN/WiFi, SDIO driver packs
   Tools\             Portable diagnostic and utility apps
   Scripts\           PowerShell automation scripts
   Configs\           Registry tweaks file

 ventoy\              Boot manager config and theme files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 BOOT MENU NAVIGATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Arrow keys          Navigate up/down
 Enter               Select / open folder
 ESC                 Go back one level
 F3                  Toggle between Tree view and List view
 Ctrl+W              Enable WIMBOOT mode (use if WinPE fails to boot)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 AUTOUNATTEND.XML - WHAT IT DOES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 This file sits in the USB root. Windows Setup finds it automatically
 on every install. Works for ALL languages (Hebrew, English, Russian).

 WHAT IT SKIPS:
   - EULA screen (accepted automatically)
   - WiFi/network setup screen
   - Microsoft account requirement (blocked via hosts file)
   - Privacy settings screens
   - Cortana setup

 WHAT YOU STILL DO MANUALLY:
   - Pick language/region/keyboard (2 clicks, any language)
   - Pick which disk to install to
   - Pick edition (Home or Pro)

 WHAT IT SETS AUTOMATICALLY:
   - Timezone: Israel Standard Time
   - Local account: "User" with no password
   - Auto-login once on first boot
   - PowerShell execution policy set to allow scripts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SCRIPTS - WHAT EACH ONE DOES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 All scripts are in: Toolkit\Scripts\
 Run them as Administrator (right-click > Run as Administrator)
 Or use the launcher: Toolkit\_LAUNCH.bat > Option 8

 ┌─────────────────────────────────────────────────────────────────┐
 │ PostInstall.ps1 - MASTER MENU                                   │
 └─────────────────────────────────────────────────────────────────┘
 The main script. Run this after every Windows installation.
 Shows a numbered menu so you pick exactly what to do:

   [1] Remove Bloatware      - Runs RemoveBloatware.ps1
   [2] Disable Telemetry     - Turns off tracking services
   [3] High Performance      - Activates high performance power plan
   [4] Registry Tweaks       - Runs SetDefaults.ps1
   [5] Install Common Apps   - Runs InstallCommon.ps1
   [6] Disable Sleep         - Disables sleep and hibernation
   [7] Launch SDIO           - Opens Snappy Driver Installer
   [8] System Info           - Shows CPU, RAM, disk summary
   [9] Run ALL (1-6)         - Does everything in one shot

 ┌─────────────────────────────────────────────────────────────────┐
 │ RemoveBloatware.ps1                                             │
 └─────────────────────────────────────────────────────────────────┘
 Removes pre-installed Windows apps that waste space and slow
 down the system. Removes:
   - Candy Crush, Facebook, TikTok, Spotify, Disney+
   - Xbox apps (Xbox, Game Bar, Game Overlay, Xbox Identity)
   - Microsoft Teams, Skype, Get Help, Tips
   - Maps, Weather, News, Finance, Sports
   - Clipchamp, Power Automate, Solitaire Collection
   - OneDrive hooks, Cortana, Outlook for Windows
 Also prevents Windows from reinstalling bloat automatically.

 ┌─────────────────────────────────────────────────────────────────┐
 │ SetDefaults.ps1                                                 │
 └─────────────────────────────────────────────────────────────────┘
 Applies all standard technician settings to a fresh Windows install.
 Does 7 things in sequence:

   1. File Explorer tweaks
      - Show file extensions (e.g. .exe, .dll visible)
      - Show hidden files and folders
      - Open Explorer to "This PC" instead of Quick Access

   2. Power plan
      - Activates High Performance power plan
      - Disables USB selective suspend
      - Screen off after 15 min (AC) / 10 min (battery)

   3. Telemetry
      - Sets telemetry level to minimum (Security only)
      - Disables DiagTrack service
      - Disables advertising ID

   4. Windows 11 UI tweaks
      - Restores classic right-click context menu
      - Hides Widgets button from taskbar
      - Hides Chat (Teams) button from taskbar
      - Hides Task View button from taskbar
      - Sets Search to icon-only mode

   5. Disable unnecessary services
      - SysMain (Superfetch) - not needed on SSDs
      - Windows Search indexing - reduces disk I/O
      - Maps Broker, Retail Demo

   6. Network tweaks
      - Disables Nagle's algorithm (lower ping/latency for gaming)
      - Prevents Windows Update from pushing driver updates

   7. Desktop cleanup
      - Removes Microsoft Edge shortcut from desktop

 ┌─────────────────────────────────────────────────────────────────┐
 │ InstallCommon.ps1                                               │
 └─────────────────────────────────────────────────────────────────┘
 Installs common software using winget (Windows package manager).
 Requires internet connection. You choose what to install:

   Browsers:     Chrome, Firefox
   Utilities:    7-Zip, Notepad++, VLC, Adobe Reader, WinRAR
   Chat:         Discord, Telegram
   Dev:          VS Code, Git
   Gaming:       Steam, MSI Afterburner

   Or pick "All essentials" or "Gaming pack" in one shot.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DRIVERS - HOW TO USE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Toolkit\Drivers\
   SDIO\              Snappy Driver Installer + 65 driver packs (~55GB)
   GPU_NVIDIA\        NVIDIA GeForce drivers (Game + Studio + Quadro)
   GPU_AMD\           AMD Adrenalin software
   GPU_Intel\         Intel integrated graphics driver
   Chipset_AMD\       AMD chipset combo installer
   Intel_IRST\        Intel Rapid Storage Technology (NVMe/RAID)
   Intel_ME\          Intel Management Engine driver
   Intel_DSA\         Intel Driver & Support Assistant
   LAN_WiFi\          Emergency LAN/WiFi drivers (use when no network)

 RECOMMENDED DRIVER INSTALL ORDER:
   1. LAN driver first (get internet)
   2. Chipset (AMD or Intel)
   3. GPU (NVIDIA or AMD standalone installer - NOT via SDIO)
   4. SDIO for everything else (audio, USB, touchpad, etc.)
   5. Intel IRST if NVMe or RAID system

 SDIO TIPS:
   - Run in Expert Mode to see all drivers and choose manually
   - Skip GPU drivers in SDIO - use standalone installer instead
   - First run takes 2-5 min to index all packs (normal)
   - After first index it is instant on same machine
   - Always run from USB 3.0 port (USB 2.0 is much slower)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 DIAGNOSTIC TOOLS QUICK REFERENCE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 CPU-Z            CPU, motherboard, RAM, SPD info
 GPU-Z            GPU specs, VRAM, temperatures, load
 HWInfo           Complete system hardware overview (best all-rounder)
 CrystalDiskInfo  SSD/HDD health, SMART data, temperature
 CrystalDiskMark  Disk read/write speed benchmark
 FurMark          GPU stress test and burn-in
 OCCT             CPU/GPU/PSU stress test (most thorough)
 DDU              Display Driver Uninstaller - clean GPU driver removal
                  Use before installing new NVIDIA/AMD drivers
 Victoria         Low-level HDD/SSD diagnostics and repair
 FixWin           One-click Windows repair for common issues
 NvidiaProfileInspector  Advanced NVIDIA driver settings per game

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TYPICAL WORKFLOW - NEW PC BUILD / FRESH INSTALL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1.  Boot from USB
 2.  Select Windows ISO from menu (Windows > Win11_Hebrew.iso etc.)
 3.  Pick language, disk, edition
 4.  Wait for install (~15-20 min)
 5.  Windows boots, logs in as "User" automatically
 6.  Plug USB back in
 7.  Open USB > run Toolkit\_LAUNCH.bat
 8.  Option 1: SDIO - install LAN/WiFi/chipset/audio drivers
 9.  Option 8: PostInstall script
       - Remove bloatware
       - Apply defaults and tweaks
       - Install common apps
 10. Install GPU driver from Toolkit\Drivers\GPU_NVIDIA or GPU_AMD
 11. Restart - done

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 TYPICAL WORKFLOW - PC REPAIR / DIAGNOSTICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 RAM issues        Boot > Tools > Memtest86 (run overnight)
 Disk issues       Boot > Tools > HDAT2 or CrystalDiskInfo in Windows
 Boot issues       Boot > Recovery > Strelec Win11PE
 Data recovery     Boot > Recovery > Rescuezilla or Clonezilla
 GPU issues        Use DDU to clean driver, reinstall fresh
 Windows corrupt   Boot > Recovery > Hiren's BootCD PE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 MAINTAINING THE USB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Update Windows ISOs:
   Delete old ISO > drop new one in same folder > done
   Ventoy detects ISOs automatically, no config change needed

 Update Ventoy itself:
   Run Ventoy2Disk.exe > select USB > click Update
   This ONLY updates boot files, your data is untouched

 Update SDIO driver packs:
   Open SDIO > check for updates > download new packs
   Delete old .7z files to save space

 Update portable tools:
   Download new version > replace files in Toolkit\Tools\[ToolName]\

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 SECURE BOOT NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 On first boot on a new machine with Secure Boot enabled:
   1. Blue MOK Management screen appears
   2. Select "Enroll key from disk"
   3. Navigate to VTOYEFI partition
   4. Select the .cer file > Confirm > Reboot
   5. Done permanently on that machine

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 OtterOS v1.0 - Built for professional PC technicians
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
