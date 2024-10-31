$volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' }

foreach ($volume in $volumes) {
    $volumeInfo = Get-Volume -DriveLetter $volume.DriveLetter

    $vhdFiles = Get-ChildItem "$($volume.DriveLetter):\" -Recurse -Depth 2 -Include *.vhd, *.vhdx -ErrorAction SilentlyContinue
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
    Write-Host "  Currently Provisioned VHD Space: $currentSize GB"
    Write-Host "  Max Possible VHD Space: $maxSize GB"
    Write-Host "  Fully Provisioned Free Space: $fullyProvisionedFreeSpace GB"

    if ($volumeInfo.Size -ne 0) {
        $provisionedUsagePercentage = ((($volumeInfo.Size / 1GB) - ($volumeInfo.SizeRemaining / 1GB) + $maxSize - $currentSize) * 100 / ($volumeInfo.Size / 1GB))
        Write-Host "  Provisioned Usage Percentage: $provisionedUsagePercentage %"
    } else {
        Write-Host "  Provisioned Usage Percentage: Not Applicable (Size is 0)"
    }

    if ($fullyProvisionedFreeSpace -le 0) {
        Write-Host "  Yo Dawg - You've over provisioned your virtual disks" -ForegroundColor Red
    } else {
        Write-Host "  Status: All Good" -ForegroundColor Green
    }

    Write-Host "------------------------------"
}
