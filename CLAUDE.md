# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

OtterOS is a 256GB bootable USB technician toolkit for a PC repair/gaming shop in Israel. It uses **Ventoy** as the boot manager. The files here are the configuration, scripts, and theme files that get copied to the USB drive.

The USB drive is typically mounted as `F:` (Ventoy main partition, exFAT) and `G:` (VTOYEFI, FAT, small boot partition — never touch this).

## Deploying Changes to the USB

There is no build system. Changes are deployed by copying files directly:

```powershell
# Copy a specific config file
cp ventoy/ventoy.json F:/ventoy/ventoy.json

# Copy all auto_install XMLs
cp ventoy/auto_install/*.xml F:/ventoy/auto_install/

# Copy theme
cp ventoy/theme/theme.txt F:/ventoy/theme/theme.txt

# Copy autounattend
cp autounattend.xml F:/autounattend.xml

# Copy all scripts
cp Toolkit/Scripts/*.ps1 F:/Toolkit/Scripts/
```

Always verify the USB is mounted as `F:` before copying — run `powershell "Get-Volume | Select-Object DriveLetter,FileSystemLabel"` to confirm.

## Architecture

```
OtterOS_Claude/          ← Source of truth (desktop folder)
│
├── ventoy/
│   ├── ventoy.json      ← Ventoy boot config: search root, theme, auto_install mappings, Win11 bypass flags
│   ├── theme/
│   │   └── theme.txt    ← GRUB2 theme: positions are whole-number percentages only (no decimals — causes boot crash)
│   └── auto_install/    ← Per-ISO XMLs for Ventoy plugin (currently unused in favour of USB-root autounattend.xml)
│
├── autounattend.xml     ← ACTIVE unattended config — placed in USB root, picked up by Windows Setup automatically
│                           Contains: windowsPE pass (language screen), specialize pass (timezone + MS account block),
│                           oobeSystem pass (skip OOBE, create local User account)
│
└── Toolkit/
    ├── _LAUNCH.bat      ← Menu launcher, uses %~d0 to self-reference the USB drive letter
    └── Scripts/
        ├── PostInstall.ps1     ← Master menu, calls other scripts
        ├── RemoveBloatware.ps1 ← AppxPackage removal + provisioned package removal
        ├── SetDefaults.ps1     ← Registry + power + services tweaks
        └── InstallCommon.ps1   ← winget-based app installer
```

## Key Design Decisions

**autounattend.xml vs Ventoy auto_install plugin:** The `ventoy/auto_install/*.xml` files exist but are NOT the active method. The active file is `autounattend.xml` in the USB root. Ventoy's auto_install plugin injects the XML too late for the `windowsPE` pass to work, so the root file is used instead. Do not remove the ventoy/auto_install files — they serve as language-specific templates.

**Single universal autounattend.xml:** The active `autounattend.xml` intentionally does NOT set language/keyboard/locale. This means it works for Hebrew, English, and Russian installs without swapping files. The technician picks language manually (2 clicks). Israel Standard Time is set automatically.

**GRUB2 theme rules:** The `theme.txt` file only accepts whole-number percentages for positions (e.g. `left = 4%`). Decimal values like `4.3%` cause a `Failed to boot both default and fallback entries` crash.

**Ventoy search root:** `ventoy.json` sets `VTOY_DEFAULT_SEARCH_ROOT` to `/ISO` so Ventoy only scans that folder for bootable images — it ignores the 55GB SDIO driver packs in `/Toolkit`.

**_LAUNCH.bat drive detection:** Uses `%~d0` to get its own drive letter, so it works regardless of which letter Windows assigns the USB.

## Windows Unattended Install — What Each Pass Does

- `windowsPE` — runs at setup start; controls language screen visibility (`WillShowUI: Never` skips it)
- `specialize` — runs after drivers load; sets timezone, blocks MS account servers via hosts file
- `oobeSystem` — runs during OOBE; creates local "User" account with no password, skips privacy/Cortana screens

## Ventoy Configuration Reference

Key flags in `ventoy.json`:
- `VTOY_TREE_VIEW_MENU_STYLE: 1` — shows ISO folders as categories in boot menu
- `VTOY_DEFAULT_MENU_MODE: 1` — forces TreeView on startup
- `VTOY_WIN11_BYPASS_CHECK: 1` — bypasses TPM/RAM/Secure Boot checks during Win11 install
- `VTOY_WIN11_BYPASS_NRO: 1` — additional network requirement bypass
- `ventoy_left/top/width/height` in theme section — must match positions in `theme.txt`

## USB Content Layout (on F:)

- `F:/ISO/Windows/` — Win11 English/Hebrew/Russian ISOs (~8GB each)
- `F:/ISO/Recovery/` — Strelec WinPE, Hiren's BootCD PE
- `F:/ISO/Linux/` — Ubuntu, GParted, etc.
- `F:/ISO/Tools/` — Memtest86, HDAT2
- `F:/Toolkit/Drivers/SDIO/` — SDIO exe + 65 driver packs in `drivers/` subfolder (~55GB)
- `F:/Toolkit/Drivers/GPU_NVIDIA|GPU_AMD|GPU_Intel|Chipset_AMD|Intel_IRST|Intel_ME|Intel_DSA/`
- `F:/ventoy/` — config and theme (source of truth is this repo)
- `F:/autounattend.xml` — active unattended config (source of truth is this repo)
