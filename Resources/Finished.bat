@Echo OFF
title Finishing Troubleshooting. Please Wait.
echo MsgBox "All virtual IPv6 interfaces have been reinstalled.",vbInformation,"Troubleshooting Completed"> %temp%\TEMPmessage.vbs
start /MAX %temp%\TEMPmessage.vbs
pause
DEL "%~f0"