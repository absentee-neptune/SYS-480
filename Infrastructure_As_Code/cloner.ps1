$configuration_path = "cloner.json"
$interactive = $true
$conf = ""

if (Test-Path $configuration_path) {
    Write-Host "Using a Saved Configuration File:"
    $interactive = $false
    $conf = (Get-Content -Raw -Path $configuration_path | ConvertFrom-Json)
} else {
    Write-Host "Interactive Mode"
    cloneVM
}

if ($interactive) {
    cloneVM
}

function cloneVM {
    try {
        $VIserver = Read-Host "Enter vCenter Hostname or IP Address"
        Connect-VIServer -Server $VIserver -ErrorAction Stop
    }
    catch {
        Write-Output "ISSUE: $PSItem"
        Break
    }

    try {
        $BaseLocation = Read-Host "Enter folder name for Base VMs"
        
        Write-Host "Here are the current Base VMs:"
        Get-VM -Location $BaseLocation -ErrorAction Stop | Format-Table Name
        $basevm = Read-Host "Enter the name of the Base VM to clone"
    }
    catch {
        Write-Output "ISSUE: $PSItem"
        Break
    }

    $CloneType = Read-Host "[F]ull Clone or [L]inked Clone"

    Write-Host "Here are the current VM Hosts on the vCenter Server:"
    Get-VMHost | Format-Table Name
    $vmhost = Read-Host "Enter the VM Host to place the Clone"

    Write-Host "Here are the current Datastores on the Host:"
    Get-Datastore | Format-Table Name
    $dstore = Read-Host "Enter the name of the Datastore to place the Clone"

    $CloneName = Read-Host "Enter a Name for the Clone"

    if($CloneType -eq "F")
    { 
        try {
            Write-Host "Creating Full Clone of ${basevm}:"
            New-VM -Name $CloneName -VM $basevm -VMHost $vmhost -Datastore $dstore -ErrorAction Stop
        }
        catch{
            Write-Output "ISSUE: $PSItem"
            Break
        }
    }

    if($CloneType -eq "L")
    {
        try
        {
            $snapshot = Get-Snapshot -VM $basevm -Name "Base"

            $linkedname = "{0}.linked" -f $CloneName

            Write-Host "Creating Linked Clone of ${basevm}:"
            New-VM -Name $linkedname -VM $basevm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -ErrorAction Stop
        }
        catch
        {
            Write-Output "ISSUE: $PSItem"
            Break
        }
    }
}