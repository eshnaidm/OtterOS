@echo off
title OtterOS - Switch Install Language
color 0F
setlocal

:: Get the drive letter of this script
set "DRIVE=%~d0"

cls
echo.
echo  ============================================
echo       OtterOS - Windows Install Language
echo  ============================================
echo.
echo   Current default: Check %DRIVE%\autounattend.xml
echo.
echo   [1] Hebrew   (default for shop)
echo   [2] English
echo   [3] Russian
echo   [0] Cancel
echo.
echo  ============================================
echo.
set /p "choice=  Select language: "

if "%choice%"=="1" goto HEBREW
if "%choice%"=="2" goto ENGLISH
if "%choice%"=="3" goto RUSSIAN
if "%choice%"=="0" goto EXIT

echo  Invalid choice.
pause
goto EXIT

:HEBREW
copy /Y "%DRIVE%\autounattend_HE.xml" "%DRIVE%\autounattend.xml" >nul
echo.
echo  Done! Next Windows install will be HEBREW.
goto DONE

:ENGLISH
copy /Y "%DRIVE%\autounattend_EN.xml" "%DRIVE%\autounattend.xml" >nul
echo.
echo  Done! Next Windows install will be ENGLISH.
goto DONE

:RUSSIAN
copy /Y "%DRIVE%\autounattend_RU.xml" "%DRIVE%\autounattend.xml" >nul
echo.
echo  Done! Next Windows install will be RUSSIAN.
goto DONE

:DONE
echo  (autounattend.xml updated on %DRIVE%\)
echo.
pause

:EXIT
exit /b 0
