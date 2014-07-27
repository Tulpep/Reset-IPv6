# Resolver Script - This script fixes the root cause. It only runs if the Troubleshooter detects the root cause.
# Key cmdlets: 
# -- get-diaginput invokes an interactions and returns the response
# -- write-diagprogress displays a progress string to the user

# Your logic to fix the root cause here

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