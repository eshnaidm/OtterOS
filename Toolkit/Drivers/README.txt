=======================================
  OtterOS - Driver Installation Guide
=======================================

SNAPPY DRIVER INSTALLER ORIGIN (SDIO)
--------------------------------------
Location: Toolkit\Drivers\SDIO\

Setup:
1. Download SDIO from: glenn.delahoy.com/snappy-driver-installer-origin/
2. Extract to this folder (SDIO\)
3. Run SDIO executable
4. Go to: Tools > Options > Download
5. Download driver packs (or use torrent for bulk download)

Recommended driver packs to download:
  - DP_LAN         (Ethernet drivers - CRITICAL, download first)
  - DP_WLAN        (WiFi drivers)
  - DP_Chipset     (Intel/AMD chipset)
  - DP_Video_AMD   (AMD graphics)
  - DP_Video_nVIDIA (NVIDIA graphics)
  - DP_Video_Intel (Intel integrated graphics)
  - DP_Sound       (Audio - mostly Realtek)
  - DP_USB         (USB 3.x host controllers)
  - DP_Bluetooth   (Bluetooth adapters)
  - DP_Touchpad    (Laptop touchpads)

Total size: ~30-40 GB for all packs

UPDATING DRIVER PACKS
---------------------
Monthly maintenance:
1. Run SDIO
2. Click "Check for updates"
3. Download updated packs
4. Old packs can be deleted to save space

EMERGENCY LAN/WIFI DRIVERS
---------------------------
Location: Toolkit\Drivers\LAN_WiFi\

Keep a small collection of common LAN/WiFi drivers here for
machines that can't run SDIO due to no network driver:
  - Intel I219/I225 LAN drivers
  - Realtek 8111/8168 LAN drivers
  - Intel AX200/AX210 WiFi drivers
  - Realtek RTL8822/8852 WiFi drivers
  - MediaTek MT7921/7922 WiFi drivers

Download these from manufacturer websites and keep the
installer .exe or .zip files here.
