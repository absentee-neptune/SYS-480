function Connect {
    try {
        $VIserver = Read-Host "Enter vCenter Hostname or IP Address"
        Connect-VIServer -Server $VIserver -ErrorAction Stop
    }
    catch {
        Write-Output "ISSUE: $PSItem"
        Break
    }
}

# Milestone 6.1 Notes
$switchName = "BLUE8-LAN"
$esx_host = Get-VMHost -Name super8.cyber.local
$vswitch = New-VirtualSwitch -VMHost $esx_host -Name $switchName -ErrorAction Ignore
$vport = New-VirtualPortGroup -VirtualSwitch $vswitch -Name $switchName

function createSwitch {
    
}
