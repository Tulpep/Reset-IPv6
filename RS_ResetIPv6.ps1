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

$arch =  Get-OSArchitecture -ComputerName localhost
if($arch.Architecture -like "64-Bit")
{
 Copy-Item .\devcon64.exe C:\Windows\System32\devcon.exe
}
else
{
 Copy-Item .\devcon32.exe C:\Windows\System32\devcon.exe
}

devcon.exe remove *6to4mp
devcon.exe remove *teredo
devcon.exe remove *IPHTTPS
devcon.exe remove *ISATAP

Set-Location $env:WINDIR\inf
devcon.exe install nettun.inf *6to4mp
devcon.exe install nettun.inf *teredo
devcon.exe install nettun.inf *IPHTTPS
devcon.exe install nettun.inf *ISATAP

netsh interface ipv6 reset
gpupdate /force

shutdown -r -t 1

Return 0