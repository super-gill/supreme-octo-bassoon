param (
    [string]$driveLetter
)

Write-Host ""

if ($driveLetter) {
    $volumes = get-volume | Where-Object { $_.DriveLetter -eq $driveLetter }
    Write-Host "Searching for volumes assigned to $($driveLetter):`n"
} else {
    $volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' }
    Write-Host "Will search the following drives:"
    foreach($volume in $volumes) {Write-Host "$($volume.DriveLetter):"}
    Write-Host ""
}

foreach ($volume in $volumes) {
    $volumeInfo = Get-Volume -DriveLetter $volume.DriveLetter
    Write-Host -NoNewline "Scanning $($volume.DriveLetter): for VHD files..."
    Write-Host  "`rDone searching.             `n"

    $currentSize = 0
    $maxSize = 0

    if ($vhdFiles) {
        $vhdInfo = @()
        foreach ($file in $vhdFiles) {
            try {
                $vhdInfo += Get-VHD -Path $file.FullName -ErrorAction Stop
            } catch {
                Write-Host "Error accessing VHD file: $($file.FullName)" -ForegroundColor Yellow
            }
        }

        $currentSize = ($vhdInfo.FileSize | Measure-Object -Sum).Sum / 1GB
        $maxSize = ($vhdInfo.Size | Measure-Object -Sum).Sum / 1GB
    }

    $fullyProvisionedFreeSpace = $volumeInfo.SizeRemaining / 1GB - $maxSize + $currentSize

    Write-Host "Volume $($volume.DriveLetter):"
    Write-Host "  Currently Provisioned VHD Space: $([math]::round($currentSize,2)) GB"
    Write-Host "  Max Possible VHD Space: $([math]::round($maxSize,2)) GB"
    Write-Host "  Fully Provisioned Free Space: $([math]::round($fullyProvisionedFreeSpace,2)) GB"

    if ($volumeInfo.Size -ne 0) {
        $provisionedUsagePercentage = ((($volumeInfo.Size / 1GB) - ($volumeInfo.SizeRemaining / 1GB) + $maxSize - $currentSize) * 100 / ($volumeInfo.Size / 1GB))
        Write-Host "  Provisioned Usage Percentage: $([math]::Round($provisionedUsagePercentage,2)) %"
    } else {
        Write-Host "  Provisioned Usage Percentage: Not Applicable (Size is 0)"
    }

    if ($fullyProvisionedFreeSpace -le 0) {
        Write-Host "  Yo Dawg - You've over-provisioned your virtual disks" -ForegroundColor Red
    } else {
        Write-Host "  Status: All Good" -ForegroundColor Green
    }

    Write-Host "------------------------------"
}
