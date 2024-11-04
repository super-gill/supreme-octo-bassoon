# Parameters
param (
    [string]$jobName,
    [string]$sourceFolder,
    [string]$destinationFolder,
    [string]$reportDirectory,
    [int]$versions = 40,
    [bool]$emailNotification = $FALSE,
    [string]$notificationEmailTo = "jason@mcdill.uk",
    [string]$notificationEmailFrom = "backups@mcdill.uk",
    [string]$smtpServer = "mcdill-uk.mail.protection.outlook.com",
    [switch]$differencing,
    [switch]$image
)

# Internal variables
[string]$backupNamePattern = "^Backup_(FULL|DIFF)_\d{4}-\d{2}-\d{2}_\d{1,3}$"
[string]$oneDrivePath = "C:\Program Files\Microsoft OneDrive\onedrive.exe"
[array]$failedFiles = @()
[string]$backupStatus
[array]$successfulFiles = @()
[int]$version = 1
[datetime]$startDate = Get-Date
[int]$fileCount = 0
[string]$notificationState
[string]$oneDriveRunningState
[int]$longFileNameCount = 0
[bool]$notificationSendStatus

# Internal variables without definitions :/
$endDate
$report
$duration

Clear-Host

if (-not $jobName -or -not $sourceFolder -or -not $destinationFolder) {
    # Clear-Host
    Write-Host "We couldnt pass the job name, source folder or destination folder, the backup has been cancelled." -ForegroundColor Red
    Write-Host ""
    Write-Host "For reference, we tried to pass these as:"
    Write-Host ""
    if (-not $jobname) {
        Write-Host "Job Name:           Empty" -ForegroundColor yellow 
    }
    else {
        Write-Host "Job Name:           $($jobName)" -ForegroundColor Green 
    }
    if (-not $sourceFolder) {
        Write-Host "Source Folder:      Empty" -ForegroundColor yellow 
    }
    else { 
        Write-Host "Source Folder:      $($sourceFolder)" -ForegroundColor Green 
    }
    if (-not $destinationFolder) {
        Write-Host "Destination Folder: Empty" -ForegroundColor yellow 
    }
    else { 
        Write-Host "Destination Folder: $($destinationFolder)" -ForegroundColor Green 
    }
    Write-Host ""
    Write-Host "Example`n" -ForegroundColor Yellow 
    Write-Host ".\simplebackup.ps1 -jobname ""Backup1"" -sourcefolder ""C:\temp"" -destinationfolder ""C:\backups""`n" -ForegroundColor Yellow
    exit
}
else {

    # Function to apply \\?\ prefix for long paths if needed
    function checkLongFilePath {
        param ([string]$path)
        if ($path.Length -gt 260 -and $path -notmatch "^\\\\\?\\") {
            $longFileNameCount ++
            return "\\?\" + $path
        }
        return $path
    }

    # Function to check a directory exists and create it if not
    function checkDirectory {
        param(
            $dirPath
        )
        if (!(Test-Path -LiteralPath $dirPath)) {
            New-Item -Path $dirPath -ItemType Directory | Out-Null
        }
    }

    # Function that returns the state of notifications as a string
    function getNotificationState {
        if ($emailNotification) {
            return "On"
        }
        else {
            return "Off"
        }
    }

    # Function that returns the title
    function title {
        param (
            [int]$style
        )

        Clear-Host

        if ($style -eq 1) {
            Write-Output "-----------------------"
            Write-Output "Jankup Special Sauce Version $($version)`n`n`n`n`n"
            Write-Output "Written By Jason Mcdill"
            Write-Output "-----------------------`n"
        }
        if ($style -eq 2) {
            Write-Output "-----------------------"
            Write-Output "Jankup Special Sauce Version $($version)"
            Write-Output "Written By Jason Mcdill"
            Write-Output "-----------------------`n"
        }
    }

    # Function that returns matching backup folders in the backup destination
    function getExistingBackupFolders {
        Get-ChildItem -LiteralPath $destinationFolder | Where-Object {
            $_.PSIsContainer -and $_.Name -match $backupNamePattern
        } | Sort-Object LastWriteTime -Descending
    }

    # Function that returns the running status of OneDrive as a string
    function getOneDriveRunningStatus {
        
        if (Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue) {
            Write-Host "OneDrive is running"
            return "Running"
        }
        else { 
            Write-Host "OneDrive is Stopped"
            return "Stopped" 
        }
    }

    #function to toggle OneDrive on and off
    function toggleOneDrive {

        param(
            [switch]$start,
            [switch]$stop
        )
        
        if ($stop) {
            try {
                if (getOneDriveRunningStatus -eq "Running") {
                    Stop-Process -Name "OneDrive" -Force
                }
            }
            catch {
                Write-Host "Failed to stop OneDrive.`n" -ForegroundColor red
            }
        }
        
        if ($start) {
            try {
                if (getOneDriveRunningStatus -eq "Stopped") {
                    Write-Output "Starting OneDrive...`n"
                    Start-Process -FilePath $oneDrivePath -ArgumentList "/background"
                }
            }
            catch {
                Write-Host "OneDrive failed to start, please start it manually.`n" -ForegroundColor red
            }
        } $oneDriveRunningState = getOneDriveRunningStatus
    }

    # Create timestamp and random number for backup folder name
    [string]$date = Get-Date -Format "yyyy-MM-dd"
    [int]$randomNumber = Get-Random -Minimum 0 -Maximum 101
    
    if ($differencing) {
        [string]$newFolderName = "Backup_DIFF_$($date)_$randomNumber"
    }
    else {
        [string]$newFolderName = "Backup_FULL_$($date)_$randomNumber"
    }
    
    [string]$newFolderPath = checkLongFilePath (Join-Path -Path $destinationFolder -ChildPath $newFolderName)

    # Ensure the backup directory exists
    checkDirectory -dirPath $newFolderPath

    title -style 1

    # Stop OneDrive if running
    toggleOneDrive -stop

    Write-Output "Backup Job Name:      $jobName"

    [void]($notificationState = getNotificationState)
    
    Write-Output "Notifications:        $notificationState"
    Write-Output "Source Folder:        $sourceFolder"
    Write-Output "Destination Folder:   $destinationFolder"
    Write-Output "New Backup Folder:    $newFolderName"
    Write-Output ""

    # Get all files to copy and count for progress tracking
    Write-Progress -activity "Checking source files..." -status "Please Wait..."
    [array]$files = Get-ChildItem -LiteralPath $sourceFolder -Recurse -File
    [int]$totalFiles = $files.Count
    [int]$fileCount = 0
    Write-Progress -Activity "Source files checked successfully." -Completed


    # Copy each file individually with progress output for PS and EXE
    Write-Output "--------------------------------------"
    Write-Output "Copying folder contents..."
    foreach ($file in $files) {
        $fileCount++

        # Calculate the destination path for the current file
        $relativePath = $file.FullName.Substring($sourceFolder.Length).TrimStart('\')
        $destinationPath = checkLongFilePath (Join-Path -Path $newFolderPath -ChildPath $relativePath)

        # Ensure the destination directory exists
        $destinationDir = checkLongFilePath (Split-Path -Path $destinationPath)
        checkDirectory -dirPath $destinationDir

        # Copy the file
        try {
            Copy-Item -LiteralPath (checkLongFilePath $file.FullName) -Destination $destinationPath -Force
            $successfulFiles += $file.FullName  # Add to successful list
        }
        catch {
            $failedFiles += @{
                FileName     = $file.FullName
                ErrorMessage = $_.Exception.Message
            }
            $backupStatus = "Failed"
        }

        # Calculate progress percentage
        $progressPercent = [math]::Round(($fileCount / $totalFiles) * 100, 2)
        $progressStatus = ("{0,5}% complete - {1,1} files copied" -f $progressPercent, $filecount)

        # Display progress
        if ($Host.Name -eq 'ConsoleHost') {
            Write-Progress -Activity "Copying files..." -Status $progressStatus -PercentComplete $progressPercent
        }
        else {
            Write-Host -NoNewline -ForegroundColor Green "rProgress: $progressPercent% complete"
        }
    }

    Write-Output "Backup completed at:    $newFolderPath"
    Write-Output "--------------------------------------"
    Write-Output ""

    # Retrieve existing backups and sort by date
    Write-Output "Retrieving existing backups..."

    $backupFolders = getExistingBackupFolders

    Write-Output "Found $($backupFolders.Count) existing backup(s)."
    Write-Output ""

    # Remove older backups if they exceed the retention limit
    if ($backupFolders.Count -gt $versions) {
        [array]$foldersToRemove = $backupFolders | Select-Object -Skip $versions
        Write-Output "Removing older backups to keep the most recent $versions version(s):"
        foreach ($folder in $foldersToRemove) {
            Write-Output " - Removing old backup: $($folder.FullName)"
            Remove-Item -LiteralPath (checkLongFilePath $folder.FullName) -Recurse -Force
        }
        $backupFolders = getExistingBackupFolders
        Write-Output "Older backups removed successfully."
    }
    else {
        Write-Output "No older backups to remove. Currently storing $($backupFolders.count) of $($versions) version(s)."
    }

    toggleOneDrive -start
        
    if ($failedFiles.count -gt 0) {
        Write-Host ""
        Write-Host "The following failures occurred." -ForegroundColor Red
        $report = $failedFiles | Format-Table -Property Filename, ErrorMessage -AutoSize | Out-String
        Write-Output $($report)
        $backupStatus = "Failed"
        $notificationEmailSubject = "$jobName - Failed"
    }
    else {
        Write-Host ""
        Write-Host "$($fileCount) files copied successfully." -ForegroundColor Green
        $report = "$($fileCount) All files copied successfully."
        $backupStatus = "Success"
        $notificationEmailSubject = "$jobName - Success"
    }

    if ($emailNotification) {
        # Send backup status message
        try {
            Send-MailMessage -From $notificationEmailFrom 
            -to $notificationEmailTo 
            -Subject $notificationEmailSubject 
            -Body $report 
            -SmtpServer $smtpServer 
        }
        catch {
            $notificationSendStatus = $false
        }
    
    }

    # Report file path inside the specific backup folder (e.g., Backup_2024-10-26_100)
    if (-not $reportDirectory) {
        [string]$reportFilePath = Join-Path -Path $newFolderPath -ChildPath "Backup_Report_$($date)_$randomNumber.txt"
    }
    else {
        $reportFilePath = $reportDirectory
    }
    

    [datetime]$endDate = Get-Date
    $duration = New-TimeSpan -start $startDate -End $endDate
    [void]($oneDriveRunningState = getOneDriveRunningStatus)

    # Generate report content
    $reportContent = @"
Backup Report for Job: $jobName
=======================================
Time Stats
----------
Start Time:             $startDate
End Time:               $endDate
Duration:               $($duration.ToString("hh\:mm\:ss"))

Directories
-----------
Source Folder:          $sourceFolder
Destination Folder:     $destinationFolder
Backup Folder:          $newFolderName
Report Directory:       $reportFilePath
Long Directories:       $($longFileNameCount)

Other Stats
-----------
Version Retained:       $($backupFolders.Count) of $($versions)
Backup Status:          $backupStatus
Notification Status:     $($notificationState)
OneDrive Running State: $($oneDriveRunningState)
Total Files:            $fileCount
=======================================
Successful Files:
$([string]::Join("`n", $successfulFiles))

Failed Files:
$($failedFiles | ForEach-Object { "$($_.FileName) - Error: $($_.ErrorMessage)" })
=======================================
"@

    title -style 2
    Write-Host ""
    # Generate report for the console
    $consoleReport = @"
Backup Report for Job: $jobName
=======================================
Time Stats
----------
Start Time:             $startDate
End Time:               $endDate
Duration:               $($duration.ToString("hh\:mm\:ss"))

Directories
-----------
Source Folder:          $sourceFolder
Destination Folder:     $destinationFolder
Backup Folder:          $newFolderName
Report Directory:       $reportFilePath
Long Directories:       $($longFileNameCount)

Other Stats
-----------
Version Retained:       $($backupFolders.Count) of $($versions)
Backup Status:          $backupStatus
Notification Status:    $($notificationState)
OneDrive Running State: $($oneDriveRunningState)
Total Files:            $fileCount
=======================================
"@

    # Close the progress bar
    Write-Progress -Activity "Processing" -Status "Completed" -Complete

    # Send the console report to the console
    Write-Host "`n$($consoleReport)`n"

    # Write the report content to file
    Set-Content -Path $reportFilePath -Value $reportContent

    # Send a windows notification
    Add-Type -AssemblyName System.Windows.Forms
    If ($backupStatus -eq "success") {
        [string]$message = "Backup completed successfully"
        [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null

    }
    else {
        [string]$message = "Backup failed or partially failed"
        [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null

    }
}