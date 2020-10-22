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

    $numInterface = Read-Host "Enter the Network Adapter Number to change"

    $preferredNetwork = Read-Host "Enter the Netowrk Name"

    Get-VM $vmName | Get-NetworkAdapter | Set-NetworkAdapter -NetworkAdapter $numInterface -NetworkName $preferredNetwork
}

function getIP {
    Get-VM | Format-Table Name
    $vm = Read-Host "Which VM has the needed IP Address"

    Write-Host $vm.Guest.IPaddress[0] hostname=$vm.name
}

function utilityMenu {
    Write-Host ""
    Write-Host "Utility Functions Menu"
    Write-Host "[1] Create Virtual Switch"
    Write-Host "[2] Create Virtual Port Group"
    Write-Host "[3] Change Network for a VM"
    Write-Host "[4] Show IP of a VM"
    Write-Host "[E]xit"
    Write-Host ""
    
    $option = Read-Host "Choose a Utility Function"

    if ($option -eq 1) {
        createSwitch
    } elseif ($option -eq 2) {
        createPortGroup
    } elseif ($option -eq 3) {
        changeNetwork
    } elseif ($option -eq 4) {
        getIP
    } elseif ($option -eq "E") {
        Break
    }
}

Connect
while ($true) {
    utilityMenu
}
