$resourcesPath = ".\build-resources"
$buildFolder = ".\build-folder"


Write-Host Deleting old build folder
If (Test-Path $buildFolder){
	Remove-Item $buildFolder -Recurse
}
New-Item -Path $buildFolder -ItemType directory

Write-Host Copying files to build folder
Copy-Item ResetIpv6.cdf $buildFolder
Copy-Item ResetIPv6.diagpkg $buildFolder
Copy-Item RS_ResetIPv6.ps1 $buildFolder
Copy-Item TS_ResetIPv6.ps1 $buildFolder
Copy-Item VF_ResetIPv6.ps1 $buildFolder
Copy-Item devcon32.exe $buildFolder
Copy-Item devcon64.exe $buildFolder

Write-Host Creating Windows Catalog File
$makeCatParamters = "-v " + $buildFolder + "\ResetIpv6.cdf"
Start-Process -FilePath ($resourcesPath + "\MakeCat.Exe") -ArgumentList $makeCatParamters
Remove-Item ($buildFolder + "\ResetIpv6.cdf")


#throw "Build not finished yet"





