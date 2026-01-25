@echo off
REM This script will automate the repeated tasks on login
REM To help mass install AccPac 5.5 Updated 


cls
echo This will copy the Program Files for Sage AccPac
echo If you don't want to perform this task, hit CTRL+C now.
echo Otherwise, do as the prompt sais and hit any key
pause

net use y: \\server\e$\Support\AccPac_Inst

rmdir /S /Q "c:\Program Files\Sage Software\Sage Accpac"
xcopy /R /Y /H /W /E "y:\" "C:\Program Files\Sage Software\"
echo.
echo.
echo There should be 7590 File(s) copied
echo.
echo.
pause
cd "C:\Program Files\Sage Software\Sage Accpac\WSSetup\"
setup.exe

echo.
echo.
echo If there were no errors on the file copy, 
echo hitting enter will now start registering the new AccPac files the the system.
echo Otherwise, hit CTRL+C to manually fix what is needed and run AccReg manually.

C:
cd "C:\Program Files\Sage Software\Sage Accpac\Runtime\"
RegAcc.exe

echo Ok!! So far things are good, just some cleanup and 
echo we are ready to test the updated AccPac installation!

del /F "C:\Program Files\Sage Software\Sage Accpac\CP55A0.LIC"
NET USE Y /DELETE /Y
