# TroubleshooterScript - This script checks for the presence of a root cause
# Key Cmdlets:
# -- update-diagrootcause flags the status of a root cause and can be used to pass parameters
# -- get-diaginput invokes an interactions and returns the response
# -- write-diagprogress displays a progress string to the user

$RootCauseID = "failedToOpen"

# Your detection Logic Here

$netsh = cmd /c 'netsh interface teredo show state  & netsh interface 6to4 show state & netsh interface https show interfaces' | Out-String


if($netsh -match "failed to open")
{
    $result = 1   
}
elseif($netsh -match "no se puede abrir")
{
    $result = 1   
}

elseif($netsh -match "interface creation failure")
{
    $result = 1   
}
else
{
    $result = 0
}


$RootCauseDetected = $result

#The following line notifies Windows Troubleshooting Platform of the status of this root cause
update-diagrootcause -id $RootCauseId -detected $RootCauseDetected