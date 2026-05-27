# OtterOS 🦦

**A professional multi-boot USB toolkit for PC technicians.**

Boot from it to get a clean menu with Windows installers, recovery environments, Linux distros, and diagnostic tools. After installing Windows, plug the USB back in and use the Toolkit folder for drivers, scripts, and utilities.

> Built for a PC repair and gaming PC installation shop. Works for any technician.

---

## Boot Menu Preview

The boot menu shows ISOs organized by category (TreeView mode). Navigation:

| Key | Action |
|-----|--------|
| Arrow keys | Navigate |
| Enter | Select / open folder |
| ESC | Go back |
| F3 | Toggle Tree/List view |
| Ctrl+W | Enable WIMBOOT mode (use if WinPE fails to boot) |

---

## Features

- **Multi-language Windows installs** — English, Hebrew, Russian (Win10 + Win11)
- **Semi-unattended setup** — skips OOBE, Microsoft account, privacy screens, Cortana; creates local "User" account with no password; sets Israel Standard Time automatically
- **Recovery environments** — Sergei Strelec WinPE, Hiren's BootCD PE, Rescuezilla
- **Linux ISOs** — Ubuntu, Kali, GParted, SystemRescue
- **Diagnostic tools** — Memtest86, HDAT2
- **Post-install scripts** — remove bloatware, disable telemetry, apply tweaks, install common apps
- **Offline driver support** — SDIO with full driver packs, standalone GPU/chipset installers
- **Custom GRUB2 boot theme** — dark background, otter mascot, clean layout

---

## Requirements

- USB drive **256GB or larger** (recommended: USB 3.0+)
- [Ventoy](https://www.ventoy.net/en/download.html) installed on the USB
- Windows 10/11 PC to set up the USB

---

## Setup Guide

### Step 1 — Install Ventoy on your USB

1. Download [Ventoy](https://www.ventoy.net/en/download.html) and run `Ventoy2Disk.exe`
2. Select your USB drive
3. Options → Partition Style: **GPT**
4. Options → Secure Boot Support: **Enable**
5. Click **Install**

### Step 2 — Clone this repo

```
git clone https://github.com/eshnaidm/OtterOS.git
```

Or download the ZIP from GitHub and extract it.

### Step 3 — Run setup script

Run the included setup script as Administrator (replace `F:` with your USB drive letter):

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1 -Drive F:
```

This does everything in one shot:
- Creates all folders on the USB
- Copies all config files (ventoy.json, theme.txt, autounattend.xml, scripts, launcher)

### Step 4 — Download ISOs and place them in the correct folders

See the [Download Links](#download-links) section below. Put each ISO in the matching folder on the USB.

```
F:\ISO\Windows\     ← Windows 10/11 ISOs
F:\ISO\Recovery\    ← Strelec, Hiren's, Rescuezilla
F:\ISO\Linux\       ← Ubuntu, Kali, GParted, SystemRescue
F:\ISO\Tools\       ← Memtest86, HDAT2
```

### Step 5 — Download and install SDIO + driver packs

1. Download [SDIO](https://www.glenn.delahoy.com/snappy-driver-installer-origin/) — put `SDIO.exe` in `F:\Toolkit\Drivers\SDIO\`
2. Run SDIO → Tools → Download Network Indexes
3. Download driver packs into `F:\Toolkit\Drivers\SDIO\drivers\`

### Step 6 — Add background image

Put your background image (1920×1080 PNG) at:
```
F:\ventoy\theme\background.png
```

### Step 7 — Test boot

Restart and boot from the USB. You should see the OtterOS themed menu with categorized ISOs.

---

## USB Folder Structure

```
F:\
├── autounattend.xml              ← Active unattended Windows install config
│
├── ISO\
│   ├── Windows\                  ← Win11/Win10 English, Hebrew, Russian
│   ├── Recovery\                 ← Strelec WinPE, Hiren's BootCD PE, Rescuezilla
│   ├── Linux\                    ← Ubuntu, Kali, GParted, SystemRescue
│   └── Tools\                    ← Memtest86, HDAT2
│
├── Toolkit\
│   ├── _LAUNCH.bat               ← Run this after Windows install (quick launcher)
│   ├── Drivers\
│   │   ├── SDIO\                 ← Snappy Driver Installer + driver packs (~55GB)
│   │   ├── GPU_NVIDIA\
│   │   ├── GPU_AMD\
│   │   ├── GPU_Intel\
│   │   ├── Chipset_AMD\
│   │   ├── Intel_IRST\
│   │   └── LAN_WiFi\             ← Emergency network drivers
│   ├── Tools\                    ← Portable diagnostic tools
│   ├── Scripts\
│   │   ├── PostInstall.ps1       ← Master post-install menu (run this)
│   │   ├── RemoveBloatware.ps1
│   │   ├── SetDefaults.ps1
│   │   └── InstallCommon.ps1
│   └── Configs\
│       └── RegistryTweaks.reg
│
└── ventoy\
    ├── ventoy.json               ← Ventoy config
    └── theme\
        ├── theme.txt             ← GRUB2 boot theme
        └── background.png        ← Your background image (not included)
```

---

## Post-Install Workflow

After Windows finishes installing and boots to the desktop:

1. Plug the USB back in
2. Open USB → run `Toolkit\_LAUNCH.bat`
3. Option 1: SDIO → install LAN/WiFi/chipset/audio drivers
4. Option 8: PostInstall script → remove bloatware, apply tweaks, install apps
5. Install GPU driver from `Toolkit\Drivers\GPU_NVIDIA` or `GPU_AMD`
6. Restart — done

### PostInstall.ps1 menu options

| Option | What it does |
|--------|-------------|
| [1] Remove Bloatware | Removes Xbox apps, Teams, Candy Crush, TikTok, Spotify, Clipchamp, OneDrive, etc. |
| [2] Disable Telemetry | Disables DiagTrack service, sets telemetry to minimum, disables advertising ID |
| [3] High Performance | Activates High Performance power plan |
| [4] Registry Tweaks | Show file extensions, hide widgets/chat/taskview, classic right-click, disable Cortana |
| [5] Install Common Apps | Installs Chrome, 7-Zip, VLC, Notepad++, Discord, Steam, etc. via winget |
| [6] Disable Sleep | Disables sleep and hibernation, screen off after 15min (AC) / 10min (battery) |
| [7] Launch SDIO | Opens Snappy Driver Installer |
| [8] System Info | Shows CPU, RAM, disk summary |
| [9] Run ALL (1-6) | Does everything in one shot |

---

## Unattended Windows Install

The `autounattend.xml` in the USB root is picked up automatically by Windows Setup.

**What it skips automatically:**
- EULA (accepted)
- Microsoft account requirement (blocked via hosts file)
- WiFi/network setup screen
- Privacy settings screens
- Cortana setup

**What you still do manually:**
- Pick language/region/keyboard (2 clicks)
- Pick which disk to install to
- Pick edition (Home or Pro)

**What it sets automatically:**
- Timezone: Israel Standard Time
- Local account: "User" with no password
- Auto-login once on first boot
- PowerShell execution policy set to allow scripts

---

## Driver Install Order

1. **LAN driver** first (to get internet)
2. **Chipset** (AMD or Intel)
3. **GPU** — use standalone installer from `Toolkit\Drivers\GPU_*`, NOT SDIO
4. **SDIO** for everything else (audio, USB, touchpad, Bluetooth)
5. **Intel IRST** if NVMe or RAID system

**SDIO tips:**
- Run in **Expert Mode** to see all drivers and choose manually
- Skip GPU drivers in SDIO — use standalone installer instead
- First run takes 2–5 min to index all packs (normal)
- Always run from a **USB 3.0 port**

---

## Download Links

### Windows ISOs

| ISO | Source |
|-----|--------|
| Windows 11 (all languages) | [microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11) |
| Windows 10 (all languages) | [microsoft.com/software-download/windows10ISO](https://www.microsoft.com/software-download/windows10ISO) |

Use the Microsoft Media Creation Tool and select your desired language.

### Recovery / WinPE

| ISO | Source |
|-----|--------|
| Sergei Strelec WinPE | [sergeistrelec.ru](https://sergeistrelec.name) |
| Hiren's BootCD PE | [hirensbootcd.org/download](https://www.hirensbootcd.org/download/) |
| Rescuezilla | [rescuezilla.com/download](https://rescuezilla.com/download) |
| Clonezilla | [clonezilla.org/downloads](https://clonezilla.org/downloads.php) |

### Linux

| ISO | Source |
|-----|--------|
| Ubuntu 24.04 LTS | [ubuntu.com/download/desktop](https://ubuntu.com/download/desktop) |
| Kali Linux | [kali.org/get-kali](https://www.kali.org/get-kali/#kali-live) |
| GParted Live | [gparted.org/download](https://gparted.org/download.php) |
| SystemRescue | [system-rescue.org/Download](https://www.system-rescue.org/Download/) |

### Diagnostic Tools (bootable)

| ISO | Source |
|-----|--------|
| Memtest86 | [memtest86.com/download](https://www.memtest86.com/download.htm) |
| HDAT2 | [hdat2.com/download](https://www.hdat2.com/download) |

### Toolkit (portable apps)

| Tool | Source |
|------|--------|
| SDIO | [glenn.delahoy.com/snappy-driver-installer-origin](https://www.glenn.delahoy.com/snappy-driver-installer-origin/) |
| HWInfo (portable) | [hwinfo.com/download](https://www.hwinfo.com/download/) |
| CPU-Z (ZIP) | [cpuid.com/softwares/cpu-z.html](https://www.cpuid.com/softwares/cpu-z.html) |
| GPU-Z | [techpowerup.com/gpuz](https://www.techpowerup.com/gpuz/) |
| CrystalDiskInfo (portable) | [crystalmark.info](https://crystalmark.info/en/software/crystaldiskinfo/) |
| CrystalDiskMark (portable) | [crystalmark.info](https://crystalmark.info/en/software/crystaldiskmark/) |
| FurMark | [geeks3d.com/furmark](https://www.geeks3d.com/furmark/) |
| OCCT | [ocbase.com/download](https://www.ocbase.com/download) |
| DDU | [guru3d.com/files-details/display-driver-uninstaller-download.html](https://www.guru3d.com/files-details/display-driver-uninstaller-download.html) |
| Victoria | [hdd.by/victoria](https://hdd.by/victoria/) |
| Autoruns | [learn.microsoft.com/sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) |

---

## Diagnostic Tools Reference

| Tool | Purpose |
|------|---------|
| CPU-Z | CPU, motherboard, RAM, SPD info |
| GPU-Z | GPU specs, VRAM, temperatures |
| HWInfo | Complete system hardware overview |
| CrystalDiskInfo | SSD/HDD health, SMART data |
| CrystalDiskMark | Disk read/write speed benchmark |
| FurMark | GPU stress test and burn-in |
| OCCT | CPU/GPU/PSU stress test (most thorough) |
| DDU | Clean GPU driver removal before reinstall |
| Victoria | Low-level HDD/SSD diagnostics and repair |

---

## Secure Boot

On first boot on a new machine with Secure Boot enabled:

1. Blue **MOK Management** screen appears
2. Select **"Enroll key from disk"**
3. Navigate to VTOYEFI partition → select the `.cer` file
4. Confirm → Reboot
5. Done permanently on that machine

---

## Maintaining the USB

**Update Windows ISOs:** Delete old ISO → drop new one in same folder → Ventoy detects automatically.

**Update Ventoy:** Run `Ventoy2Disk.exe` → select USB → click **Update**. Only updates boot files, data is untouched.

**Update SDIO driver packs:** Open SDIO → check for updates → download new packs. Delete old `.7z` files to save space.

**Update portable tools:** Download new version → replace files in `Toolkit\Tools\[ToolName]\`.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| WinPE fails to boot | Press Ctrl+W before selecting ISO to enable WIMBOOT mode |
| Boot menu shows as list, not folders | Press F3 to toggle TreeView, or check `VTOY_DEFAULT_MENU_MODE` in ventoy.json |
| Windows install not skipping screens | Make sure `autounattend.xml` is in the USB root (not in a subfolder) |
| SDIO takes long to start | Normal on first run — it indexes all driver packs. Use USB 3.0 port |
| Secure Boot blocks boot | Follow MOK enrollment steps above |

---

## License

MIT License — free to use, modify, and distribute.

---

*OtterOS v1.0 — Built for professional PC technicians*
