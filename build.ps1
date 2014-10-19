$resourcesPath = ".\build-resources"
$buildFolder = ".\build-folder"


Write-Output "Deleting old build folder"
If (Test-Path $buildFolder){
	Remove-Item $buildFolder -Recurse
}
New-Item -Path $buildFolder -ItemType directory | Out-Null

Write-Output "Copying files to build folder"
Copy-Item ResetIpv6.cdf $buildFolder
Copy-Item ResetIPv6.diagpkg $buildFolder
Copy-Item RS_ResetIPv6.ps1 $buildFolder
Copy-Item TS_ResetIPv6.ps1 $buildFolder
Copy-Item VF_ResetIPv6.ps1 $buildFolder
Copy-Item devcon32.exe $buildFolder
Copy-Item devcon64.exe $buildFolder

Write-Output "Creating Windows Catalog File"
Start-Process -FilePath ($resourcesPath + "\MakeCat.Exe") -ArgumentList "-v ResetIpv6.cdf" -WorkingDirectory $buildFolder -Wait
Remove-Item ($buildFolder + "\ResetIpv6.cdf")


Write-Output "Digitally signing the catalog"
Start-Process -FilePath ($resourcesPath + "\signtool.Exe") -ArgumentList "sign /t http://timestamp.verisign.com/scripts/timstamp.dll /sha1 b6c83dfa006475aec9e458a48696c1c42ff1b5c4 DiagPackage.cat" -WorkingDirectory $buildFolder -Wait


Write-Output "Creating Cabinet File .diagcab"
$cabInfoFile = "cabInfo.txt"
$listOfFiles = Get-ChildItem -Path $buildFolder -Name
Write-Output ".Set DiskDirectoryTemplate=cab" | Out-File -FilePath ($buildFolder + "\" + $cabInfoFile) -encoding ASCII
Write-Output ".Set CabinetNameTemplate=ResetIPv6.diagcab" | Out-File -FilePath ($buildFolder + "\" + $cabInfoFile) -Append -encoding ASCII
Write-Output $listOfFiles | Out-File -FilePath ($buildFolder + "\" + $cabInfoFile) -Append -encoding ASCII
Start-Process -FilePath makecab.exe -ArgumentList ("/d ""ResetIpv6=ResetIPv6.diagcab"" /f " + $cabInfoFile) -WorkingDirectory $buildFolder -Wait
Move-Item ($buildFolder + "\cab\" + "ResetIPv6.diagcab") "ResetIPv6.diagcab" -Force
Remove-Item $buildFolder -Recurse


Write-Output "Digitally signing the cab"
Start-Process -FilePath ($resourcesPath + "\signtool.Exe") -ArgumentList "sign /t http://timestamp.verisign.com/scripts/timstamp.dll /sha1 b6c83dfa006475aec9e458a48696c1c42ff1b5c4 ResetIPv6.diagcab" -Wait


$validSiganture = (Get-AuthenticodeSignature -FilePath "ResetIPv6.diagcab" | ? { $_.Status -eq "Valid" }) -ne $null
If($validSiganture -eq $true)
{
    Write-Output "Troubleshooting packaged created with name ResetIPv6.diagcab"
}
else
{
    throw "The Diagcab file created does not have a valid signature"
}






