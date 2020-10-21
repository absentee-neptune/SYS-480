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
    Get-VMHost | Format-Table Name
    $vmhost = Read-Host "Enter the VM Host to place the Port Group"

    $portName = Read-Host "Enter Name for Port"

    Write-Host "Here are the Current Virtual Switches on the VM Host:"
    Get-VirtualSwitch | Format-Table Name
    $vswitch = "Enter the Switch to place the Port Group"

    Write-Host "Creating New Port Group:"
    New-VirtualPortGroup -VMHost $vmhost -VirtualSwitch $vswitch -Name $portName
}