# Summerise physical disk and logical volume usage

$logicalDrives = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
$partitions = Get-CimInstance -ClassName Win32_DiskPartition
$physicalDisks = Get-CimInstance -ClassName Win32_DiskDrive

$storageReport = @()

foreach ($drive in $logicalDrives) {
    $partition = $partitions | Where-Object {
        ($_ | Get-CimAssociatedInstance -ResultClassName Win32_LogicalDisk) |
        Where-Object { $_.DeviceID -eq $drive.DeviceID }
    }

    if ($partition) {
        $physicalDisk = $physicalDisks | Where-Object {
            $_ | Get-CimAssociatedInstance -ResultClassName Win32_DiskPartition |
            Where-Object { $_.DeviceID -eq $partition.DeviceID }
        }
    }

    if ($physicalDisk) {
        $diskNumber = ($physicalDisk.DeviceID -replace "\\\\.\\PHYSICALDRIVE", "")
        $diskModel = $physicalDisk.Model
        $diskType = $physicalDisk.MediaType
        $isISCSI = if ($diskModel -match "iSCSI") { "Yes" } else { "No" }
    } else {
        $diskNumber = "N/A"
        $diskModel = "N/A"
        $diskType = "N/A"
        $isISCSI = "N/A"
    }

    $totalSize = [math]::Round($drive.Size / 1GB, 2)
    $freeSpace = [math]::Round($drive.FreeSpace / 1GB, 2)
    $usedSpace = [math]::Round($totalSize - $freeSpace, 2)
    $percentFree = [math]::Round(($freeSpace / $totalSize) * 100, 2)

    $storageReport += New-Object PSObject -Property @{
        ParentDrive           = $drive.DeviceID
        ParentPhysicalDisk    = $diskNumber
        ParentDiskModel       = $diskModel
        ParentDiskType        = $diskType
        IsISCSI         = $isISCSI
        TotalSizeGB     = $totalSize
        UsedSpaceGB     = $usedSpace
        FreeSpaceGB     = $freeSpace
        PercentFree     = "$percentFree%"
    }
}

# Output the storage report
$storageReport | Format-List
Write-Host ""
Write-Host ""
$storageReport | Format-Table -AutoSize
