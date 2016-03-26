@echo off
rem Display info and license
color f0
echo GWX Kill Script 1.0.0
echo A tool for disabling "Upgrade to Windows 10" notifications (and tray icon).
echo https://github.com/DavisNT/GWX-Kill-Script
echo.
echo Copyright (c) 2016 Davis Mosenkovs
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
verify other 2>nul
setlocal enableextensions
if errorlevel 1 goto :end
set accepted=
if not "%1"=="/AUTO" if not "%1"=="/auto" set /P accepted=Press enter if you agree or immediately close this window otherwise! 
if not "%accepted%"=="" goto :end
echo.

rem Check admin rights
net session >nul 2>nul
if errorlevel 1 goto :noadmin

rem Disable GWX
set errors=0
echo Taking ownership of GWX files...
takeown /A /F %SystemRoot%\system32\GWX\*.exe
if errorlevel 1 set errors=1
echo.
echo Changing permissions of GWX files...
icacls %SystemRoot%\system32\GWX\*.exe /deny *S-1-1-0:(X)
if errorlevel 1 set errors=1
echo.
echo Terminating GWX processes...
taskkill /f /im GWX*
echo.

rem Display results
if "%errors%"=="1" goto :errors

rem Success
color f2
echo GWX ("Upgrade to Windows 10" notifications) should be disabled now.
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

goto :end

rem Errors occured
:errors
color fc
echo Error(s) occurred, please review the script output!
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

goto :end

rem Missing admin rights error
:noadmin
color fc
echo This script must be run with Administrator rights.
echo Please right click on the script and select "Run as Administrator"
if not "%1"=="/AUTO" if not "%1"=="/auto" pause

rem For compatibility
:end
