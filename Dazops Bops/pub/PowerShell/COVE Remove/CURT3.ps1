param (
    [bool]$whatIf = $true,
    [bool]$userUPN,
    [bool]$userScope = $true,
    [string]$logFilePath,
    [string]$adminURL,
    [string]$adminUPN,
    [string]$csvFilePath
)

# Script details
[int]$version = 3
[string]$scriptName = [system.io.path]::GetFileName($PSCommandPath)
[string]$author = "Jason Mcdill"

# Global variables
[string]$sassMe = "Invalid answer"
[bool]$isadmin
$userUpns = @()
[string]$logFilePath

# Function to log messages to a file
function logMessage {
    param (
        [string]$message
    )

    $callStack = Get-PSCallStack
    $currentLineNumber = if ($callStack) { $callStack[1].ScriptLineNumber } else { "Unknown" }
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFilePath -Value "$timestamp - Line $($currentLineNumber): $message"
}

# General function to convert a yes/no value to boolean
function convertAnswer {
    param (
        [string]$answer # Receive the answer (yes/no/y/n etc) from the calling function
    )
    
    logMessage "convertAnswer called with answer: $($answer)"

    switch ($answer.ToLower()) {
        "yes" { return $true }
        "no" { return $false }
        "y" { return $true }
        "n" { return $false }
        default {
            logMessage "convertAnswer failed to match: $($answer)"
            return $null
        }
    }
}

# Function to validate email addresses
function validateEmail {
    param (
        [string]$emailAddress # Pass the email from the calling function
    )

    logMessage "validateEmail called with email address: $($emailAddress)"

    $emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    if ($emailAddress -match $emailPattern) {
        logMessage "validateEmail returned true for email address: $($emailAddress)"
        return $true
    }
    else {
        logMessage "validateEmail returned false for email address: $($emailAddress)"
        return $false
    }
}

# Function to validate the URL
function validateURL {
    param (
        [string]$url # Pass the URL from the calling function
    )

    logMessage "validateURL called with URL: $($url)"

    $urlPattern = '^https:\/\/[a-zA-Z0-9-]+\.sharepoint\.com\/$'

    if ($url -match $urlPattern) {
        logMessage "validateURL returned true for URL: $($url)"
        return $true
    }
    else {
        logMessage "validateURL returned false for URL: $($url)"
        return $false
    }
}

function createLog {
    logMessage "createLog called"

    showHeader -logFilePath $logFilePath

    # Ensure the C:\temp directory exists
    $directory = "C:\temp"
    if (-not (Test-Path -Path $directory)) {
        New-Item -ItemType Directory -Path $directory | Out-Null
    }

    # Generate a unique number for the log file
    $uniqueNumber = Get-Random -Minimum 1000 -Maximum 9999

    # Construct the file name
    $fileName = "CURTLog_$uniqueNumber.txt"
    $logFilePath = Join-Path -Path $directory -ChildPath $fileName

    # Create the empty text file
    New-Item -ItemType File -Path $logFilePath | Out-Null

    # Output the file path
    Write-Host "Created log file: $logFilePath"
    Start-Sleep -Seconds 2

    # Title the log
    $hostname = [System.Environment]::MachineName
    logMessage "Script $scriptName version $version authored by $author"
    logMessage "Logged in user: $($env:USERNAME)"
    logMessage "Called on hostname: $hostname"
    logMessage "Loaded parameters: whatIf=$whatIf, userUPN=$userUPN, userScope=$userScope, csvFilePath=$csvFilePath, adminURL=$adminURL, adminUPN=$adminUPN"
    return $logFilePath
}

function checkAdminSession {
    logMessage "checkAdminSession called"

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        logMessage "Running as administrator"
        showHeader -logFilePath $logFilePath
        Write-Host ""
        Write-Host "Do not run this as an administrator, restart PowerShell as the logged in user."
        Write-Host ""
        Write-Host -NoNewLine 'Press any key to continue...'
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Clear-Host
        Start-Sleep -seconds 5
        return $true
    }
    else {
        logMessage "Running as non-administrator"
        return $false
    }
}

function checkModules {
    logMessage "checkModules called"

    $teamsModule = get-module -ListAvailable -name MicrosoftTeams
    $SPModule = Get-Module -ListAvailable -name SharePointPnPPowerShellOnline
    
    if ($teamsModule -and ($null -ne $SPModule)) {
        logMessage "SP and Teams modules detected"
        showInstructions
    }
    else {
        showHeader -logFilePath $logFilePath        
        Write-Host ""
        try {
            if ($false -eq $SPModule) {
                logMessage "SharePoint module not installed, attempting to install"
                Write-Host "The SharePoint powershell module is not installed, attempting to install..."
                $null = Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
                return $true
            }
        }
        catch {
            logMessage "Failed to install the SharePoint module"
            Write-Host "Failed to install the SharePoint Module, the SharePoint module needs to be installed before running the script"
            exit
        }
        try {
            if ($false -eq $teamsModule) {
                logMessage "Teams module not installed, attempting to install"
                Write-Host "The Teams powershell module is not installed, attempting to install..." -ForegroundColor Yellow
                $null = install-module -name PowerShell -force -AllowClobber
                return $true
            }
        }
        catch {
            logMessage "Failed to install the Teams module"
            Write-Host "Failed to install the Teams Module, the Teams module needs to be installed before running the script"
            exit
        }
    }
}

# Display the header
function showHeader {
    param (
        $logFilePath,
        $version
    )

    logMessage "showHeader called"

    Clear-Host
    
    if ($isadmin) {
        Write-Host "[Running as administrator]"
    }
    
    $boxWidth = 60
    
    $textLines = @(
        "Cove User Removal Tool",
        "Written by Jason Prime",
        "Version $($version)"
        "Log File: $($logFilePath)"
    )
    
    $paddingLines = $textLines | ForEach-Object {
        $textLength = $_.Length
        $totalPadding = $boxWidth - $textLength - 4
        $leftPadding = " " * [math]::Floor($totalPadding / 2)
        $rightPadding = " " * [math]::Ceiling($totalPadding / 2)
        "$leftPadding$_$rightPadding"
    }
    
    Write-Host "##############################################################" -ForegroundColor Cyan
    Write-Host "#                                                            #" -ForegroundColor Cyan
    foreach ($line in $paddingLines) {
        Write-Host "#  " -ForegroundColor Cyan -NoNewline
        Write-Host "$line" -ForegroundColor Yellow -NoNewline
        Write-Host "  #" -ForegroundColor Cyan
    }
    Write-Host "#                                                            #" -ForegroundColor Cyan
    Write-Host "##############################################################" -ForegroundColor Cyan
}

# Display the instructions splash
function showInstructions {
    logMessage "showInstructions called"

    showHeader -logFilePath $logFilePath
    Write-Host "" -ForegroundColor Green
    Write-Host "You will need the following to complete this successfully:"  -ForegroundColor Green
    Write-Host ""
    Write-Host "If you are editing SharePoint:" -ForegroundColor Green
    Write-Host "> A user account with at least the SharePoint administrator role" -ForegroundColor Green
    Write-Host "> The UPN of the above administrator account" -ForegroundColor Green
    Write-Host "> The UPN of the target user account you will be removing" -ForegroundColor Green
    Write-Host "> The URL of the SharePoint admin panel" -ForegroundColor Green
    Write-Host ""
    Write-Host "If you are editing Teams permissions:" -ForegroundColor Green
    Write-Host "> A global administrator account" -ForegroundColor Green
    Write-Host "> The UPN of the target user account you will be removing" -ForegroundColor Green
    Write-Host ""
    Write-Host "*It is strongly recommended to use the test run feature first*" -ForegroundColor Green
    Write-Host ""
    Write-Host "Run ""get-help .\$($scriptName) -full"" for more info" -ForegroundColor Yellow
    Write-Host ""
    Write-Host -NoNewLine 'Press any key to continue...'
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    return
}

# Present the current configuration of the script to the user
function taskStatus {
    param (
        [bool]$whatIf,
        [string]$changeSP,
        [bool]$changeTeams
    )

    logMessage "taskStatus called with parameters: whatIf=$($whatIf), changeSP=$($changeSP), changeTeams=$($changeTeams)"

    showHeader -logFilePath $logFilePath
    Write-Host ""

    if ($whatIf) {
        Write-Host "> This is a test run" -ForegroundColor Green
    }
    else {
        Write-Host "> This is a live run, changes will be applied!" -ForegroundColor Red
    }

    Write-Host ""
    if ($changeSP -eq $false -or $whatIf) {
        Write-Host "> We won't edit SharePoint" -ForegroundColor Green
    }
    elseif ($changeSP) {
        Write-Host "> We will make changes to SharePoint" -ForegroundColor Red
    }
    
    if ($changeTeams -eq $false -or $whatIf) {
        Write-Host "> We won't edit Teams" -ForegroundColor Green
    }
    else {
        Write-Host "> We will make changes to Teams" -ForegroundColor Red
    }
}

# Ask if we are enabling WhatIf
function askWhatIf {
    param (
        [bool]$whatIf
    )

    logMessage "askWhatIf called with whatIf: $($whatIf)"

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to test run before making changes? (recommended!) (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $whatIf = convertAnswer -answer $userInput
            logMessage "askWhatIf user input: $($userInput), converted to: $($whatIf)"
            
            if ($null -eq $whatIf) {
                Write-Host $sassMe -ForegroundColor Yellow
                $whatIf = $true
                Start-Sleep -Seconds 4
                askWhatIf  # Retry
            }
            return $whatIf
        }
        catch {
            Write-Host "ERROR in askWhatIf(): $_" -ForegroundColor Red
            logMessage "ERROR in askWhatIf(): $_"
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are using a single user UPN or importing a list
function askUserScope {
    logMessage "askUserScope called"

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Are we changing more than one user? (Yes or No): " -ForegroundColor yellow -NoNewline; $userInput = Read-Host
            $userScope = convertAnswer -answer $userInput
            logMessage "askUserScope user input: $($userInput), converted to: $($userScope)"

            if ($null -eq $userScope) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                askUserScope  # Retry
            }
            return $userScope
        }
        catch {
            Write-Host "ERROR in askUserScope(): $_" -ForegroundColor Red
            logMessage "ERROR in askUserScope(): $_"
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are making changes to SharePoint
function askChangeSP {
    logMessage "askChangeSP called"

    $changeSP = $null
    logMessage "cleared changeSP"

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to remove the user from SharePoint? (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $changeSP = convertAnswer -answer $userInput
            logMessage "askChangeSP user input: $($userInput), converted to: $($changeSP)"

            if ($null -eq $changeSP) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                continue  # Retry
            }
            return $changeSP
        }
        catch {
            Write-Host "ERROR in askChangeSP(): $_" -ForegroundColor Red
            logMessage "ERROR in askChangeSP(): $_"
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are making changes to Teams
function askChangeTeams {
    logMessage "askChangeTeams called"

    $changeTeams = $null
    logMessage "cleared changeTeams"

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to remove the user from Teams? (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $changeTeams = convertAnswer -answer $userInput
            logMessage "askChangeTeams user input: $($userInput), converted to: $($changeTeams)"

            if ($null -eq $changeTeams) {
                Write-Host $sassMe -ForegroundColor Yellow
                $changeTeams = $null
                Start-Sleep -Seconds 4
                askChangeTeams  # Retry
            }
            return $changeTeams
        }
        catch {
            Write-Host "ERROR in askChangeTeams(): $_" -ForegroundColor Red
            logMessage "ERROR in askChangeTeams(): $_"
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask for the target users UPN
function askUserUPN {
    logMessage "askUserUPN called"

    try {
        showHeader -logFilePath $logFilePath
        Write-Host ""
        Write-Host "Please provide the target user's email address: " -ForegroundColor Yellow -NoNewline; $userUPN = Read-Host
        logMessage "askUserUPN user input: $($userUPN)"
        if (-not (validateEmail -emailAddress $userUPN)) {
            Write-Host """$userUPN""" " Does not look like a valid email address" -ForegroundColor Red
            logMessage "askUserUPN validation failed for input: $($userUPN)"
            $userUPN = $null
            Start-Sleep -seconds 3
            askUserUPN # Retry
        }
        logMessage "askUserUPN validation succeeded for input: $($userUPN)"

        Start-Sleep -Seconds 1
        return $userUPN
    }
    catch {
        Write-Host "ERROR in askUserUPN(): $_" -ForegroundColor Red
        logMessage "ERROR in askUserUPN(): $_"
        Write-Host $sassMe -ForegroundColor Yellow
        Start-Sleep -Seconds 3
    }
}

function multipleUsers {
    param (
        [string]$csvFilePath
    )

    logMessage "multipleUsers called"

    try {
        $userUPNs = @()
        logMessage "Cleared UPN list"
    }
    catch {
        Write-Host "Failed to clear the UPN list"
        logMessage "multipleUsers failed to clear the UPN list"
        Start-Sleep -Seconds 2
        exit
    }

    showHeader -logFilePath $logFilePath

    Write-Host ""
    Write-Host "You will need to provide a CSV containing a vertical list of all UPNs you want to modify" -ForegroundColor Yellow
    Write-Host "They must have a title that reads 'UserPrincipalName' with no spaces I.E:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UserPrincipalName," -ForegroundColor Yellow
    Write-Host "user1@contoso.com," -ForegroundColor Yellow
    Write-Host "user2@contoso.com," -ForegroundColor Yellow
    Write-Host "user3@contoso.com," -ForegroundColor Yellow
    Write-Host ""

    try {
        Write-Host "Please provide the full path to the CSV (I.E C:\temp\users.csv): " -ForegroundColor Yellow -NoNewline; $csvFilePath = Read-Host
        logMessage "multipleUsers user input for CSV path: $($csvFilePath)"
    }
    catch {
        Write-Host "Failed to read the user prompt"
        logMessage "multipleUsers failed to read the user prompt"
        Start-Sleep -Seconds 3
        exit
    }

    try {
        $users = Import-Csv -Path $csvFilePath
    }
    catch {
        Write-Host "Failed to import the CSV"
        logMessage "multipleUsers failed to import the CSV"
        Start-Sleep -Seconds 3
        multipleUsers
    }

    try {
        $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName
        foreach ($upn in $userUPNs) {
            $validation = validateEmail -emailAddress $upn
            if ($validation) {
                logMessage "$($upn) validated"
                Write-Host "$($upn) validated"
            }
            else {
                logMessage "$($upn) invalid, multipleUsers re-called"
                Write-Host "$($upn) invalid, please check your CSV and try again"
                Start-Sleep -Seconds 3
                multipleUsers
            }
        }
    }
    catch {
        Write-Host "Failed to extract the UPNs"
        logMessage "multipleUsers failed to extract the UPNs"
        Start-Sleep -Seconds 3
        exit
    }
    
    showHeader -logFilePath $logFilePath
    Write-Host ""
    Write-Host "These are the UPNs I read from that file, please check them before continuing:" -ForegroundColor Yellow
    Write-Host ""
    logMessage "multipleUsers returned to caller with: $($userUpns)"

    foreach ($upn in $userUPNs) {
        logMessage "$($upn)"
        Write-Host "$($upn)" -ForegroundColor Yellow
    }

    function userValidation {
        while ($true) {
            Write-Host ""
            Write-Host "Do these look correct? (Yes or No):  " -ForegroundColor Yellow -NoNewline; $userValidation = Read-Host
            $userValidation = convertAnswer -answer $userValidation
            if ($userValidation) {
                return $userUpns
            }
            else {
                multipleUsers
            }
        }
    }
    userValidation
}

function runPermissionChanges {
    param (
        [array]$userUPNs,
        [string]$adminURL,
        [string]$adminUPN,
        [bool]$changeSP,
        [bool]$changeTeams
    )

    logMessage "runPermissionChanges called with parameters: userUPNs=$($userUPNs), adminURL=$($adminURL), adminUPN=$($adminUPN), changeSP=$($changeSP), changeTeams=$($changeTeams)"

    if ($changeSP) {
        doSharePointMulti -userUPNs $userUPNs -adminURL $adminURL -adminUPN $adminUPN
    }
    if ($changeTeams) {
        doTeams -userUPNs $userUPNs
    }
}

# Run the question functions to gather inputs and options
function getOptions {
    param (
        [bool]$whatIf,
        [bool]$userScope,
        [bool]$changeSP,
        [bool]$changeTeams
    )

    logMessage "getOptions called with parameters: whatIf=$($whatIf), userScope=$($userScope), changeSP=$($changeSP), changeTeams=$($changeTeams)"

    showHeader -logFilePath $logFilePath

    Write-Host ""
    Write-Host "Please follow the prompts below to proceed." -ForegroundColor Green
    Write-Host ""
    
    $whatIf = askWhatIf
    $userScope = askUserScope
    $changeSP = askChangeSP
    $changeTeams = askChangeTeams

    # Check if both $changeSP and $changeTeams are false
    if (-not ($changeSP -or $changeTeams)) {
        Write-Host "You selected No for both SharePoint and Teams changes. Restarting selection..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        getOptions -whatIf $whatIf -userScope $userScope
    }

    logMessage "Returned getOptions to caller with: whatIf=$($whatIf), userScope=$($userScope), userUPNs=$($userUpns), changeSP=$($changeSP), changeTeams=$($changeTeams)"

    return @{
        whatIf      = $whatIf
        userScope   = $userScope
        userUPNs    = $userUpns
        changeSP    = $changeSP
        changeTeams = $changeTeams
    }
}

# Ask for and validate the SPO portal URL
function askAdminURL {
    param (
        $adminURL,
        $whatIf,
        $askChangeSP
    )

    if ($false -eq $askChangeSP) {
        logMessage "askAdminURL called with askChangeSP $($askChangeSP)"
        return $null 
    }
    else {
        logMessage "askAdminURL called with askChangeSP $($askChangeSP)"

        taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
        logMessage ">>>>>>>>>>>>>>> taskstatus called in askAdminURL with whatIf=$($whatIf)"

        Write-Host "The portal address must include all slashes and the scheme or it will be rejected" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "I.E. https://contoso-admin.sharepoint.com/" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Please provide the SharePoint admin URL: " -ForegroundColor Yellow -NoNewline; $adminURL = Read-Host
        logMessage "askAdminURL user input: $($adminURL)"
        if (-not (validateURL -url $adminURL)) {
            Write-Host """$adminURL""" " does not look like a valid SharePoint portal URL" -ForegroundColor Red
            logMessage "askAdminURL validation failed for input: $($adminURL)"
            $adminURL = $null
            Start-Sleep -seconds 3
            askAdminURL
        }
        logMessage "askAdminURL validation succeeded for input: $($adminURL)"
        return $adminURL
    }
}

# Ask for and validate the SP admin UPN
function askAdminUPN {
    param (
        $changeSP,
        $whatIf
    )
    logMessage "askAdminUPN called"

    taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
    logMessage "taskstatus called in askAdminUPN with whatIf=$($whatIf) changeTeams=$($changeTeams) changeSP=$($changeSP)"

    Write-Host ""
    Write-Host "Please provide an Exchange Administrator email address: " -ForegroundColor Yellow -NoNewline; $adminUPN = Read-Host
    logMessage "askAdminUPN user input: $($adminUPN)"
    if (-not (validateEmail -emailAddress $adminUPN)) {
        Write-Host """$adminUPN""" " does not look like a valid email address" -ForegroundColor Red
        logMessage "askAdminUPN validation failed for input: $($adminUPN)"
        $adminUPN = $null
        Start-Sleep -seconds 3
        askAdminUPN
    }
    logMessage "askAdminUPN validation succeeded for input: $($adminUPN)"
    return $adminUPN
}

# Gather additional SharePoint details
function prepSharePoint {
    param (
        [string]$userUPN,
        [string]$adminURL,
        [string]$adminUPN
    )

    logMessage "prepSharePoint called with parameters: userUPN=$($userUPN), adminURL=$($adminURL), adminUPN=$($adminUPN)"

    $adminURL = askAdminURL
    $adminUPN = askAdminUPN

    userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
}

function doSharePointMulti {
    param (
        [array]$userUPNs,
        [string]$adminURL,
        [string]$adminUPN
    )

    logMessage "doSharePointMulti called with parameters: userUPNs=$($userUPNs), adminURL=$($adminURL), adminUPN=$($adminUPN)"

    if ($changeSP) {
        showHeader -logFilePath $logFilePath
        Write-Host ""
        Write-Host "Editing SharePoint, please log in and wait..." -ForegroundColor Yellow

        $null = Connect-SPOService -Url $adminURL
        $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

        foreach ($site in $siteUrls) {
            try {
                logMessage "Processing site: $($site)"
                $user = Get-SPOUser -Site $site -LoginName $adminUPN -ErrorAction Stop > $null
                if ($user.IsSiteCollectionAdmin) {
                    Write-Host "$adminUPN already an admin"
                }
                else {
                    Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $true > $null
                    Write-Host "$adminUPN added as admin"
                }
            }
            catch {
                Write-Host "Error adding admin to $($site): $_" -ForegroundColor Red
                logMessage "Error adding admin to $($site): $_"
            }

            foreach ($userUPN in $userUPNs) {
                try {
                    $user = Get-SPOUser -Site $site -LoginName $userUPN -ErrorAction Stop > $null
                    if ($whatIf -eq $false) {
                        Remove-SPOUser -Site $site -LoginName $userUPN -ErrorAction Stop > $null
                        if ($?) {
                            Write-Host "Removed user" -ForegroundColor Green
                        }
                        else {
                            Write-Host "Remove failed" -ForegroundColor Red
                        }
                    }
                    else {
                        Write-Host "Would remove user" -ForegroundColor Yellow
                    }
                }
                catch {
                    Write-Host "$($userUPN): $_" -ForegroundColor Red
                    logMessage "Error removing user $($userUPN) from site $($site): $_"
                }
            }
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $false > $null
            Write-Host "$adminUPN removed"
            Write-Host "_______________________________`n"
        }
        if ($whatIf -and ($changeTeams -eq $false)) {
            Write-Host "Do you want to run this live with the current settings?: " -ForegroundColor Yellow -NoNewline $runLive = Read-Host
            convertAnswer -answer $runLive
            if ($runLive) {
                $whatIf = $false
                Write-Host "Called what if false with: userUPNs: $($userUPNs) adminURL: $($adminURL) adminUPN: $($adminUPN)"
                Start-Sleep -Seconds 5
                doSharePointMulti -userUPNs $userUPNs -adminURL $adminURL -adminUPN $adminUPN
            }
        }
    }
}

# Perform Teams actions
function doTeams {
    param (
        [array]$userUPNs
    )

    logMessage "doTeams called with parameters: userUPNs=$($userUPNs)"

    if ($changeTeams) {
        Write-Host ""
        Write-Host "Editing Teams, please log in and wait..." -ForegroundColor Yellow
        
        try {
            Connect-MicrosoftTeams
        }
        catch {
            Write-Host ""
            Write-Host "Connecting to Teams Online failed, is the module installed?" -ForegroundColor Red
            Write-Host "Ensure the module is installed" -ForegroundColor Red 
            Write-Host "Check the details you entered are correct" -ForegroundColor Red 
            Write-Host ""
            Write-Host "Restarting the Teams editor..."
            Write-Host ""
            $adminUPN = $null
            Start-Sleep -Seconds 5
            askAdminUPN
        }

        $teamResult = @()
        $teams = Get-Team

        foreach ($team in $teams) {
            try {
                foreach ($userUPN in $userUPNs) {
                    if (Get-TeamUser -GroupId $team.GroupId | Where-Object user -Like $userUPN) {
                        if ($whatIf -eq $false) {
                            Remove-TeamUser -GroupId $team.GroupId -User $userUPN
                            $teamResult += $team.DisplayName
                            Write-Host "$userUPN was removed from $team.DisplayName" -ForegroundColor Green
                        }
                        else {
                            Write-Host "Would remove $userUPN from $team" -ForegroundColor Yellow
                            $teamResult += $team.DisplayName
                        }
                    }
                    else {
                        Write-Host "$userUPN not found in $team.DisplayName" -ForegroundColor Red
                    }
                }
            }
            catch {
                Write-Host "Error in doTeams(): $_" -ForegroundColor Red
                logMessage "Error processing team $($team.DisplayName): $_"
            }
            Write-Host "_______________________`n"
        }
        
        function reRunLive {
            logMessage "reRunLive called"

            param (
                [array]$userUPNs,
                [string]$adminURL,
                [string]$adminUPN
            )

            if ($whatIf -and $changeSP) {
                Write-Host "Do you want to run this live with the current settings?: " -ForegroundColor Yellow -NoNewline; $runLive = Read-Host
                convertAnswer -answer $runLive
                if ($runLive) {
                    $whatIf = $false

                    userConfirm -userUPNs $userUPNs -adminURL $adminURL -adminUPN $adminUPN
                }
            }
            if ($whatIf -and -not $changeSP) {
                Write-Host "Do you want to run this live with the current settings?: " -ForegroundColor Yellow -NoNewline; $runLive = Read-Host
                convertAnswer -answer $runLive
                if ($runLive) {
                    $whatIf = $false
                    doTeams -userUPNs $userUPNs
                }
            }
        }
    }

    if ($whatIf -eq $false) {
        Write-Host "The following Teams were edited:`n" -ForegroundColor Green
        $teamResult | ForEach-Object { Write-Host $_ -ForegroundColor Green }
        Write-Host ""
        Write-Host ""
        reRunLive
    }
    else {
        Write-Host "The following Teams would have been edited:`n" -ForegroundColor Yellow
        $teamResult | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
        Write-Host ""
        Write-Host ""
        reRunLive

    }
}

# Get the user to confirm they don't want to run a WhatIf first
function userConfirm {
    param (
        [bool]$whatIf,
        [string]$userUPN,
        [string]$adminURL,
        [string]$adminUPN,
        [array]$userUpns
    )

    logMessage "userConfirm called with parameters: userUPN=$($userUPN), adminURL=$($adminURL), adminUPN=$($adminUPN), userUpns=$($userUpns)"

    taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
    logMessage ">>>>>>>>>>>>>>> taskstatus called in userConfirm with whatIf=$($whatIf)"

    Write-Host ""
    Write-Host "Please confirm the details are correct before continuing." -ForegroundColor Yellow 
    Write-Host ""

    if ($userScope) {
        $upnCount = $userUpns.count
        Write-Host "We will remove $($upnCount) accounts listed in your CSV" -ForegroundColor Yellow
    }
    else { Write-Host "The account being removed is: $($userUPN)" -ForegroundColor Yellow }
    if ($changeSP) {
        Write-Host "The SharePoint tenant being accessed is: $($adminURL)" -ForegroundColor Yellow
    }
    Write-Host "The administrator account being used to make changes is: $($adminUPN)" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "Are these details correct?: " -ForegroundColor Yellow -NoNewline; $confirmPrompt = Read-Host
    $confirmPrompt = convertAnswer -answer $confirmPrompt
    Write-Host "Converted to: $($confirmPrompt)" -ForegroundColor Green
    logMessage "userConfirm user input: $($confirmPrompt), converted to: $($confirmPrompt)"
    Start-Sleep -Seconds 1

    if ($confirmPrompt) {
        doSharePointMulti -userUPNs $userUpns -adminURL $adminURL -adminUPN $adminUPN
    }
    else {
        Write-Host "Restarting selection..." -ForegroundColor Yellow
        logMessage "userConfirm restarting selection due to user input: $($confirmPrompt)"
        Start-Sleep -Seconds 3
        getOptions  # Restart options selection
    }
}

# Start the script
function startScript {
    param (
        [bool]$whatIf,
        [bool]$userUPN,
        [bool]$userScope,
        [string]$adminURL,
        [string]$logFilePath,
        [string]$adminUPN,
        $changeTeams,
        $changeSP
    )

    # Start logging
    $logFilePath = createLog
    logMessage "startScript called with parameters: whatIf=$($whatIf), userUPN=$($userUPN), userScope=$($userScope), csvFilePath=$($csvFilePath), adminURL=$($adminURL), adminUPN=$($adminUPN)"

    # Check admin session
    $null = checkAdminSession
    logMessage "checkAdminSession called"

    # Check required modules
    $null = checkModules
    logMessage "checkModules called"

    # # Get user options
    # $options = getOptions -whatIf $whatIf -userScope $userScope
    # $changeTeams = $options.changeTeams
    # $changeSP = $options.changeSP
    # $whatif = $options.whatIf
    # $userScope = $options.userScope
    # $userUpns = $options.userUPNs

    $whatIf = askWhatIf
    $userScope = askUserScope
    $changeSP = askChangeSP
    $changeTeams = askChangeTeams

    # Check if both $changeSP and $changeTeams are false
    if (-not ($changeSP -or $changeTeams)) {
        Write-Host "You selected No for both SharePoint and Teams changes. Restarting selection..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        getOptions -whatIf $whatIf -userScope $userScope
    }

    # Ask for and validate additional details if required
    if ($options.userScope -eq $false) {
        $userUPN = askUserUPN
    }
    else {
        $userUpns = multipleUsers -csvFilePath $csvFilePath
    }

    # Ask for the admin and SPO details
    if ($changeSP) { 
        $adminURL = askAdminURL -whatIf $whatIf
    }
    $adminUPN = askAdminURL -whatIf $whatIf
    
    # Confirm details before making changes
    userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN -userUpns $userUpns

    # Run permission changes
    runPermissionChanges -userUPNs $userUpns -adminUPN $adminUPN -adminURL $adminURL -changeSP $options.changeSP -changeTeams $options.changeTeams
}

# Main script execution
if ($userUPN -ne "") {
    Write-Host ""
    Write-Host "Running the script without the UI has been disabled, restarting in UI mode..." -ForegroundColor Red
    Write-Host ""
    Start-Sleep -seconds 3
    startScript -whatIf $whatIf -userUPN $userUPN -userScope $userScope -logFilePath $logFilePath -adminURL $adminURL -adminUPN $adminUPN
}
else {
    startScript -whatIf $whatIf -userUPN $userUPN -userScope $userScope -logFilePath $logFilePath -adminURL $adminURL -adminUPN $adminUPN
}
