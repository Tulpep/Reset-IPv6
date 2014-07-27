rd /s /q output

mkdir output
copy ResetIpv6.cdf output\ResetIpv6.cdf
copy ResetIPv6.diagpkg output\ResetIPv6.diagpkg
copy RS_ResetIPv6.ps1 output\RS_ResetIPv6.ps1
copy TS_ResetIPv6.ps1 output\TS_ResetIPv6.ps1
copy VF_ResetIPv6.ps1 output\VF_ResetIPv6.ps1
copy devcon32.exe output\devcon32.exe
copy devcon64.exe output\devcon64.exe

cd output

makecat -v ResetIpv6.cdf
signtool sign /t http://timestamp.verisign.com/scripts/timstamp.dll /sha1 b6c83dfa006475aec9e458a48696c1c42ff1b5c4 DiagPackage.cat
del /q /f ResetIpv6.cdf

mkdir cab
echo .Set DiskDirectoryTemplate=cab > cab\files.txt
echo .Set CabinetNameTemplate=ResetIPv6.diagcab >> cab\files.txt
dir /b /a-d >> cab\files.txt


makecab /d "ResetIpv6=ResetIPv6.diagcab" /f cab\files.txt
signtool sign /t http://timestamp.verisign.com/scripts/timstamp.dll /sha1 b6c83dfa006475aec9e458a48696c1c42ff1b5c4 cab\ResetIPv6.diagcab

cd..

copy output\cab\ResetIPv6.diagcab ResetIPv6.diagcab
rd /s /q output