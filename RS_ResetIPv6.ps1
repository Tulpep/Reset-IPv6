# Resolver Script - This script fixes the root cause. It only runs if the Troubleshooter detects the root cause.
# Key cmdlets: 
# -- get-diaginput invokes an interactions and returns the response
# -- write-diagprogress displays a progress string to the user

# Your logic to fix the root cause here


function Get-OSArchitecture {            
[cmdletbinding()]            
param(            
    [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]            
    [string[]]$ComputerName = $env:computername                        
)            

begin {}            

process {            

 foreach ($Computer in $ComputerName) {            
  if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {            
   Write-Verbose "$Computer is online"            
   $OS  = (Get-WmiObject -computername $computer -class Win32_OperatingSystem ).Caption            
   if ((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -ea 0).OSArchitecture -eq '64-bit') {            
    $architecture = "64-Bit"            
   } else  {            
    $architecture = "32-Bit"            
   }            

   $OutputObj  = New-Object -Type PSObject            
   $OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Computer.ToUpper()            
   $OutputObj | Add-Member -MemberType NoteProperty -Name Architecture -Value $architecture            
   $OutputObj | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $OS            
   $OutputObj            
  }            
 }            
}            

end {}            

}

Write-DiagProgress -Activity "Analyzing the system"

$arch =  Get-OSArchitecture -ComputerName localhost
if($arch.Architecture -like "64-Bit")
{
 Copy-Item .\devcon64.exe C:\Windows\System32\devcon.exe
}
else
{
 Copy-Item .\devcon32.exe C:\Windows\System32\devcon.exe
}

Write-DiagProgress -Activity "Uninstalling IPv6 interfaces" -Status "Tunnel adapater 6to4"
devcon.exe remove *6to4mp
Write-DiagProgress -Activity "Uninstalling IPv6 interfaces" -Status "Tunnel adapater Teredo"
devcon.exe remove *teredo
Write-DiagProgress -Activity "Uninstalling IPv6 interfaces" -Status "Tunnel adapter IP-HTTPS"
devcon.exe remove *IPHTTPS
Write-DiagProgress -Activity "Uninstalling IPv6 interfaces" -Status "Tunnel adapter Isatap"
devcon.exe remove *ISATAP


Set-Location $env:WINDIR\inf
Write-DiagProgress -Activity "Installing IPv6 drivers"  -Status "Tunnel adapter 6to4"
devcon.exe install nettun.inf *6to4mp
Write-DiagProgress -Activity "Installing IPv6 drivers"  -Status "Tunnel adapter Teredo"
devcon.exe install nettun.inf *teredo
Write-DiagProgress -Activity "Installing IPv6 drivers"  -Status "Tunnel adapter IP-HTTPS"
devcon.exe install nettun.inf *IPHTTPS
Write-DiagProgress -Activity "Installing IPv6 drivers"  -Status "Tunnel adapter Isatap"
devcon.exe install nettun.inf *ISATAP

Write-DiagProgress -Activity "Resetting IPv6 settings" -Status "Netsh interface ipv6 reset"
netsh interface ipv6 reset
Write-DiagProgress -Activity "Updating group policies" -Status "GPUpdate /Force"
gpupdate /force

$input = Get-DiagInput -Id "WantToRestart"
if($input -eq $true)
{
Restart-Computer
} 

Return 0