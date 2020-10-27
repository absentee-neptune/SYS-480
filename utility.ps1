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

function createSwitch {
    Get-VMHost | Format-Table Name
    $vmhost = Read-Host "Enter the VM Host to place the Switch"

    $switchName = Read-Host "Enter Name for Switch"

    Write-Host "Creating New Virtual Switch:"
    New-VirtualSwitch -VMHost $vmhost -Name $switchName -ErrorAction Ignore
}

function createPortGroup {
    $portName = Read-Host "Enter Name for Port"

    Write-Host "Here are the Current Virtual Switches on the VM Host:"
    Get-VirtualSwitch | Format-Table Name
    $vswitch = Read-Host "Enter the Switch to place the Port Group"

    Write-Host "Creating New Port Group:"
    New-VirtualPortGroup -VirtualSwitch $vswitch -Name $portName
}

function changeNetwork {
    Get-VM | Format-Table Name
    $vmName = Read-Host "Enter the VM that requres the Network Change"
    $vm = Get-VM -Name $vmName

    $vm | Get-NetworkAdapter | Format-Table
    $numInterface = Read-Host "Enter the Network Adapter Position to change [0-2]"

    $preferredNetwork = Read-Host "Enter the New Network Name"
    
    $interfaces = $vm | Get-NetworkAdapter
    $interfaces[$numInterface] | Set-NetworkAdapter -NetworkName $preferredNetwork
}

function getIP {
    param (
        [string]$vmName
    )
    
    $vm = Get-VM -Name $vmName
    Write-Host $vm.Guest.IPaddress[0] hostname=$vmName
}

function powerOn {
    param (
        [string]$vmName
    )
  
    Start-VM -VM $vmName
}