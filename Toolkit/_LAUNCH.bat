@echo off
title OtterOS Toolkit Launcher
color 0F
setlocal EnableDelayedExpansion

:: Get the drive letter of this script
set "DRIVE=%~d0"
set "TOOLKIT=%~dp0"

:MENU
cls
echo.
echo  ============================================================
echo        ___  _   _             ___  ____
echo       / _ \| |_| |_ ___ _ __/ _ \/ ___|
echo      ^| ^| ^| ^| __^| __/ _ \ '__^| ^| ^| \___ \
echo      ^| ^|_^| ^| ^|_^| ^|_^|  __/ ^|  ^| ^|_^| ^|___) ^|
echo       \___/ \__\__\___^|_^|   \___/^|____/
echo.
echo              Technician Toolkit v1.0
echo  ============================================================
echo.
echo   [1] Snappy Driver Installer (SDIO)
echo   [2] Hardware Info (HWInfo, CPU-Z, GPU-Z)
echo   [3] Disk Tools (CrystalDiskInfo, Victoria)
echo   [4] Stress Test (FurMark, OCCT)
echo   [5] Network Tools (PuTTY, Angry IP, WinSCP)
echo   [6] Recovery Tools (Recuva, TestDisk, ProduKey)
echo   [7] System Utilities (Sysinternals, NirSoft)
echo   [8] Run Post-Install Script (PowerShell)
echo   [9] Open Toolkit Folder
echo   [0] Exit
echo.
echo  ============================================================
echo.
set /p "choice=  Select option: "

if "%choice%"=="1" goto SDIO
if "%choice%"=="2" goto HWINFO
if "%choice%"=="3" goto DISK
if "%choice%"=="4" goto STRESS
if "%choice%"=="5" goto NETWORK
if "%choice%"=="6" goto RECOVERY
if "%choice%"=="7" goto UTILITIES
if "%choice%"=="8" goto POSTINSTALL
if "%choice%"=="9" goto OPENFOLDER
if "%choice%"=="0" goto EXIT

echo  Invalid choice. Press any key...
pause >nul
goto MENU

:SDIO
if exist "%TOOLKIT%Drivers\SDIO\SDIO_x64_R*.exe" (
    start "" "%TOOLKIT%Drivers\SDIO\SDIO_x64_R*.exe"
) else if exist "%TOOLKIT%Drivers\SDIO\SDIO.exe" (
    start "" "%TOOLKIT%Drivers\SDIO\SDIO.exe"
) else (
    echo  SDIO not found in %TOOLKIT%Drivers\SDIO\
    echo  Download from: glenn.delahoy.com/snappy-driver-installer-origin/
    pause
)
goto MENU

:HWINFO
echo.
echo   [A] HWInfo
echo   [B] CPU-Z
echo   [C] GPU-Z
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Tools\HWInfo" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Tools\CPU-Z" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Tools\GPU-Z" && goto MENU
goto MENU

:DISK
echo.
echo   [A] CrystalDiskInfo
echo   [B] CrystalDiskMark
echo   [C] Victoria
echo   [D] HDTune
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Tools\CrystalDiskInfo" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Tools\CrystalDiskMark" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Tools\Victoria" && goto MENU
if /i "%sub%"=="D" start "" "%TOOLKIT%Tools\HDTune" && goto MENU
goto MENU

:STRESS
echo.
echo   [A] FurMark (GPU stress)
echo   [B] OCCT (CPU/GPU/PSU stress)
echo   [C] AIDA64
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Tools\FurMark" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Tools\OCCT" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Tools\AIDA64" && goto MENU
goto MENU

:NETWORK
echo.
echo   [A] PuTTY
echo   [B] WinSCP
echo   [C] Angry IP Scanner
echo   [D] Wireshark
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Network\PuTTY" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Network\WinSCP" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Network\AngryIPScanner" && goto MENU
if /i "%sub%"=="D" start "" "%TOOLKIT%Network\Wireshark" && goto MENU
goto MENU

:RECOVERY
echo.
echo   [A] Recuva (file recovery)
echo   [B] TestDisk / PhotoRec
echo   [C] ProduKey (Windows key finder)
echo   [D] NTPasswd (password reset)
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Recovery\Recuva" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Recovery\TestDisk" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Recovery\ProduKey" && goto MENU
if /i "%sub%"=="D" start "" "%TOOLKIT%Recovery\NTPasswd" && goto MENU
goto MENU

:UTILITIES
echo.
echo   [A] Sysinternals Suite
echo   [B] NirSoft Pack
echo   [C] 7-Zip
echo   [D] TreeSize
echo   [R] Return
echo.
set /p "sub=  Select: "
if /i "%sub%"=="A" start "" "%TOOLKIT%Utilities\Sysinternals" && goto MENU
if /i "%sub%"=="B" start "" "%TOOLKIT%Utilities\NirSoft_Pack" && goto MENU
if /i "%sub%"=="C" start "" "%TOOLKIT%Tools\7-Zip" && goto MENU
if /i "%sub%"=="D" start "" "%TOOLKIT%Tools\TreeSize" && goto MENU
goto MENU

:POSTINSTALL
echo.
echo  Launching Post-Install Script...
powershell -ExecutionPolicy Bypass -File "%TOOLKIT%Scripts\PostInstall.ps1"
pause
goto MENU

:OPENFOLDER
explorer "%TOOLKIT%"
goto MENU

:EXIT
exit /b 0
