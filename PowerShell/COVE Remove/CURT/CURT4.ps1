param (
    [bool]$whatIf = $true,
    [bool]$userScope = $true,
    [string]$logFilePath,
    [string]$adminURL,
    [string]$adminUPN,
    [string]$csvFilePath
)

# Script details
[int]$version = 4
[string]$scriptName = [system.io.path]::GetFileName($PSCommandPath)
[string]$author = "Jason Mcdill"

# Global variables
$userUpns = @()
$logFilePath

# Function to log messages to a file
function logMessage {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFilePath -Value "$($timestamp): $message"
}

# Convert yes/no answer to boolean
function convertAnswer {
    param ([string]$answer)
    logMessage "convertAnswer called with answer: $answer"
    switch ($answer.ToLower()) {
        "yes" { return $true }
        "no"  { return $false }
        "y"   { return $true }
        "n"   { return $false }
        default { return $null }
    }
}

# Ask WhatIf confirmation
function askWhatIf {
    while ($true) {
        Write-Host "Do you want to test run before making changes? (Yes or No): " -NoNewline
        $input = Read-Host
        $converted = convertAnswer -answer $input
        if ($null -ne $converted) { return $converted }
        Write-Host "Invalid input, please enter Yes or No."
    }
}

# Validate email
function validateEmail {
    param ([string]$emailAddress)
    $emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return $emailAddress -match $emailPattern
}

# Ask for user UPN if `userScope` is false
function askUserUPN {
    while ($true) {
        Write-Host "Please provide the target user's email address: " -NoNewline
        $input = Read-Host
        if (validateEmail -emailAddress $input) { return $input }
        Write-Host "$input does not look like a valid email address."
    }
}

# Main Options Collection Function
function getOptions {
    $whatIf = askWhatIf
    $userScope = askUserScope
    $changeSP = askChangeSP
    $changeTeams = askChangeTeams

    if (-not ($changeSP -or $changeTeams)) {
        Write-Host "No changes selected for SharePoint or Teams. Restarting selection..."
        return getOptions
    }

    return @{
        whatIf      = $whatIf
        userScope   = $userScope
        changeSP    = $changeSP
        changeTeams = $changeTeams
    }
}

# Start the script
function startScript {
    $logFilePath = createLog
    logMessage "Script started"

    # Admin session and required modules check
    if (-not $checkAdminSession) { return }
    if (-not $checkModules) { return }

    # Collect options
    $options = getOptions

    # Depending on userScope, collect user UPNs
    if (-not $options.userScope) {
        $userUpn = askUserUPN
    }
    else {
        $userUpns = multipleUsers -csvFilePath $csvFilePath
    }

    # Validate Admin URL and Admin UPN if needed
    if ($options.changeSP) {
        $adminURL = askAdminURL
    }
    $adminUPN = askAdminUPN

    # Confirm Details
    if (-not $userConfirm) { return }

    # Run changes
    runPermissionChanges -userUPNs $userUpns -adminURL $adminURL -adminUPN $adminUPN -changeSP $options.changeSP -changeTeams $options.changeTeams
}

startScript
