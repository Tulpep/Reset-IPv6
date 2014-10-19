$resourcesPath = ".\build-resources"
$buildFolder = ".\build-folder"


Write-Host Deleting old build folder
If (Test-Path $buildFolder){
	Remove-Item $buildFolder -Recurse
}
New-Item -Path $buildFolder -ItemType directory | Out-Null

Write-Host Copying files to build folder
Copy-Item ResetIpv6.cdf $buildFolder
Copy-Item ResetIPv6.diagpkg $buildFolder
Copy-Item RS_ResetIPv6.ps1 $buildFolder
Copy-Item TS_ResetIPv6.ps1 $buildFolder
Copy-Item VF_ResetIPv6.ps1 $buildFolder
Copy-Item devcon32.exe $buildFolder
Copy-Item devcon64.exe $buildFolder

Write-Host Creating Windows Catalog File
Start-Process -FilePath ($resourcesPath + "\MakeCat.Exe") -ArgumentList "-v ResetIpv6.cdf" -WorkingDirectory $buildFolder -Wait
Remove-Item ($buildFolder + "\ResetIpv6.cdf")


Write-Host Digitally signing the catalog
Start-Process -FilePath ($resourcesPath + "\signtool.Exe") -ArgumentList "sign /t http://timestamp.verisign.com/scripts/timstamp.dll /sha1 b6c83dfa006475aec9e458a48696c1c42ff1b5c4 DiagPackage.cat" -WorkingDirectory $buildFolder -Wait
#throw "Build not finished yet"





