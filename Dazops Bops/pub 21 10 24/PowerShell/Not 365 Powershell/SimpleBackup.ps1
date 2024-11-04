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
[array]$failedFiles = @()
[int]$version = 1
[datetime]$startDate = Get-Date
[int]$fileCount = 0

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
            return "\\?\" + $path
        }
        return $path
    }

    function checkDirectory {
        param(
            $dirPath
        )
        if (!(Test-Path -LiteralPath $dirPath)) {
            New-Item -Path $dirPath -ItemType Directory | Out-Null
        }
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

    # Clear-Host
    Write-Output "Backup Started"
    Write-Output "-----------------------"
    Write-Output "Jankup"
    Write-Output "Version $($version)"
    Write-Output "Written By Jason Mcdill"
    Write-Output "-----------------------"
    Write-Host ""

    # Stop OneDrive if running
    $oneDriveProc = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    if ($oneDriveProc) {
        Write-Output "Stopping OneDrive..."
        Stop-Process -Name "OneDrive" -Force
        # Wait until OneDrive process is completely stopped
        do {
            Start-Sleep -Seconds 1
            $oneDriveProc = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
            Write-Host "Waiting OneDrive..." -ForegroundColor yellow
        } while ($oneDriveProc)

        Write-Output "OneDrive is no longer running."
        Write-Output ""
    }
    else {
        Write-Output "OneDrive was not running."
        Write-Output ""
    }

    Write-Output "Backup Job Name:      $jobName"
    if ($emailNotification) {
        Write-Output "Notifications to:    $notificationEmailTo"
    }
    else {
        Write-Output "Notifications:        Off"
    }
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
    $backupFolders = Get-ChildItem -LiteralPath $destinationFolder | Where-Object {
        $_.PSIsContainer -and $_.Name -match $backupNamePattern
    } | Sort-Object LastWriteTime -Descending

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
        Write-Output "Older backups removed successfully."
    }
    else {
        Write-Output "No older backups to remove. Currently storing $($backupFolders.count) of $($versions) version(s)."
    }

    Write-Host ""
    Write-Output "Starting OneDrive..."
    Start-Process -FilePath $oneDrivePath -ArgumentList "/background"
    if (-not (Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue)) {
        Write-host "OneDrive failed to start, please start it manually." -ForegroundColor red
    }
    else {
        Write-host "OneDrive started successfully." -ForegroundColor green -NoNewline
    }
        
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
        Send-MailMessage -From $notificationEmailFrom 
        -to $notificationEmailTo 
        -Subject $notificationEmailSubject 
        -Body $report 
        -SmtpServer $smtpServer 
    
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

    # Generate report content
    $reportContent = @"
Backup Report for Job: $jobName
=======================================
Start Time:        $startDate
End Time:          $endDate
Duration:          $($duration.ToString("hh\:mm\:ss"))
Source Folder:     $sourceFolder
Destination Folder:$destinationFolder
Backup Folder:     $newFolderName
Version Retained:  $versions
Backup Status:     $backupStatus
Total Files:       $fileCount
---------------------------------------
Successful Files:
$([string]::Join("`n", $successfulFiles))

Failed Files:
$($failedFiles | ForEach-Object { "$($_.FileName) - Error: $($_.ErrorMessage)" })
=======================================
"@

Write-Host "`n$($reportContent)`n"

    # Write the report content to the file inside the backup folder
    Set-Content -Path $reportFilePath -Value $reportContent

    Write-Output ""
    Write-Output "-------------------------------------------------------------"
    Write-Output "Backup process completed in $($duration.ToString("hh\:mm\:ss"))"
    Write-Output "Retained $versions most recent backup(s)."
    Write-Output "Backup report created at: $reportFilePath"
    Write-Output "-------------------------------------------------------------"
    Write-Output ""

    # Send a windows notification
    Add-Type -AssemblyName System.Windows.Forms
    If ($backupStatus = "success") {
        [string]$message = "Backup completed successfully"
        [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null

    }
    else {
        [string]$message = "Backup failed or partially failed"
        [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null

    }
}