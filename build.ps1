$makeCatPath = ".\build-resources\MakeCat.Exe"
$outputFolder = ".\build-folder"

If (Test-Path $outputFolder){
	Remove-Item $outputFolder -Recurse
}
New-Item -Path $outputFolder -ItemType directory

Copy-Item ResetIpv6.cdf $outputFolder
Copy-Item ResetIPv6.diagpkg $outputFolder
Copy-Item RS_ResetIPv6.ps1 $outputFolder
Copy-Item TS_ResetIPv6.ps1 $outputFolder
Copy-Item VF_ResetIPv6.ps1 $outputFolder
Copy-Item devcon32.exe $outputFolder
Copy-Item devcon64.exe $outputFolder

$makeCatParamters = "-v " + $outputFolder + "\ResetIpv6.cdf"
Start-Process -FilePath $makeCatPath -ArgumentList $makeCatParamters
Remove-Item ($outputFolder + "\ResetIpv6.cdf")


throw "Build not finished yet"





