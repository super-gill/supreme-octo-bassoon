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

# General function to convert a yes/no value to boolean
function convertAnswer {

    param (
        [string]$answer # Recievie the answer (yes/no/y/n etc) from the calling function
    )
    Write-Output "convertAnswer called with answer: $($answer)" >> $logFilePath
    switch ($answer.ToLower()) {
        "yes" { return $true }
        "no" { return $false }
        "y" { return $true }
        "n" { return $false }
        default {
            Write-Output "convertAnswer failed to match answer: $($answer)" >> $logFilePath
            return $null
        }
    }
}

# Function to validate email addresses
function validateEmail {

    param (
        [string]$emailAddress # Pass the email from the calling function
    )
    Write-Output "validateEmail called with emailAddress: $($emailAddress)" >> $logFilePath

    $emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    if ($emailAddress -match $emailPattern) {
        Write-Output "validateEmail returned true for emailAddress to the caller: $($emailAddress)" >> $logFilePath
        return $true
    }
    else {
        Write-Output "validateEmail returned false for emailAddress to the caller: $($emailAddress)" >> $logFilePath
        return $false
    }
}

# Function to validate the URL
function validateURL {

    param (
        [string]$url # Pass the URL from the calling function
    )
    Write-Output "validateURL called with url: $($url)" >> $logFilePath

    $urlPattern = '^https:\/\/[a-zA-Z0-9-]+\.sharepoint\.com\/$'

    if ($url -match $urlPattern) {
        Write-Output "validateURL returned true for url to the caller: $($url)" >> $logFilePath
        return $true
    }
    else {
        Write-Output "validateURL returned false for url to the caller: $($url)" >> $logFilePath
        return $false
    }
}

function createLog {

    showHeader -logFilePath $logFilePath
    Write-Host ""

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
    Write-Output "Script $scriptName version $version started by $author" >> $logFilePath
    Write-Output "" >> $logFilePath
    Write-Output "Logged in user: $($env:USERNAME)" >> $logFilePath
    Write-Output "called on hostname: $hostname" >> $logFilePath
    Write-Output "" >> $logFilePath
    Write-Output "" >> $logFilePath
    Write-Output "Loaded parameters:" >> $logFilePath 
    Write-Output "whatIf: $($whatIf)" >> $logFilePath
    Write-Output "userUPN: $($userUPN)" >> $logFilePath
    Write-Output "userScope: $($userScope)" >> $logFilePath
    Write-Output "csvFilePath: $($csvFilePath)" >> $logFilePath
    Write-Output "adminURL: $($adminURL)" >> $logFilePath
    Write-Output "adminUPN: $($adminUPN)" >> $logFilePath
    return $logFilePath
}

function checkAdminSession {

    Write-Output "checkAdminSession ran" >> $logFilePath

    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Write-Output "checkAdminSession detected running as admin to caller" >> $logFilePath
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
        Write-Output "checkAdminSession running as non-admin to caller" >> $logFilePath
        Write-Output $_ >> $logFilePath
        return $false
    }
}

function checkModules {

    Write-Output "checkModules called" >> $logFilePath

    $teamsModule = get-module -ListAvailable -name MicrosoftTeams
    $SPModule = Get-Module -ListAvailable -name SharePointPnPPowerShellOnline
    
    if ($teamsModule -and ($null -ne $SPModule)) {
        Write-Output "checkModules detected SP and Teams modules are installed" >> $logFilePath
        showInstructions
    }
    else {
        showHeader -logFilePath $logFilePath        
        Write-Host ""
        try {
            if ($false -eq $SPModule) {
                Write-Output "checkModules detected SP Module is not installed" >> $logFilePath
                Write-Host "The SharePoint powershell module is not installed, attempting to install..."
                $null = Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
                return $true
            }
        }
        catch {
            Write-Host "Failed to install the SharePoint Module, the SharePoint module needs to be installed before running the script"
            Write-Output "Failed to install the SP module" >> $logFilePath
            exit
        }
        try {
            if ($false -eq $teamsModule) {
                Write-Output "checkModules detected Teams module is not installed" >> $logFilePath
                Write-Host "The Teams powershell module is not installed, attempting to install..." -ForegroundColor Yellow
                $null = install-module -name PowerShell -force -AllowClobber
                return $true
            }
        }
        catch {
            Write-Host "Failed to install the Teams Module, the Teams module needs to be installed before running the script"
            Write-Output "Failed to install the Teams module" >> $logFilePath
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

    Write-Output "showHeader called" >> $logFilePath

    Clear-Host
    
    if ($isadmin) {
        Write-Host "[Running as administrator]"
        Write-Output "Appended runas admin to header" >> $logFilePath
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

    Write-Output "showInstructions called" >> $logFilePath

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

    Write-Output "taskStatus ran with parameters: whatIf=$($whatIf), changeSP=$($changeSP), changeTeams=$($changeTeams)" >> $logFilePath

    showHeader -logFilePath $logFilePath
    Write-Host ""

    if ($whatIf) {
        Write-Host "> This is a test run" -ForegroundColor Green
        Write-Host "Test run set with whatIf: ($($whatIf))"
    }
    else {
        Write-Host "> This is a live run, changes will be applied!" -ForegroundColor Red
        Write-Host "Live run set with whatIf: ($($whatIf))"
    }

    Write-Host ""
    if ($changeSP -eq $false -or $whatIf) {
        Write-Host "> We won't edit SharePoint" -ForegroundColor Green
        Write-Output "SPO will not be changed" >> $logFilePath
    }
    elseif ($changeSP) {
        Write-Host "> We will make changes to SharePoint" -ForegroundColor Red
        Write-Output "SPO will be changed" >> $logFilePath
    }
    
    if ($changeTeams -eq $false -or $whatIf) {
        Write-Host "> We won't edit Teams" -ForegroundColor Green
        Write-Output "Teams will not be changed" >> $logFilePath
    }
    else {
        Write-Host "> We will make changes to Teams" -ForegroundColor Red
        Write-Output "Teams will be changed" >> $logFilePath
    }
    
    Write-Host ""
    Write-Host "SharePoint permissions editor" -ForegroundColor Green
    Write-Host ""
}

# Ask if we are enabling WhatIf
function askWhatIf {

    param (
        [bool]$whatIf
    )

    Write-Output "askWhatIf called with whatIf: $($whatIf)" >> $logFilePath

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to test run before making changes? (recommended!) (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $whatIf = convertAnswer -answer $userInput
            Write-Output "askWhatIf user input: $($userInput), converted to: $($whatIf)" >> $logFilePath
            
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
            Write-Output "ERROR in askWhatIf(): $_" >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are using a single user UPN or importing a list
function askUserScope {

    Write-Output "askUserScope called" >> $logFilePath

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Are we changing more than one user? (Yes or No): " -ForegroundColor yellow -NoNewline; $userInput = Read-Host
            $userScope = convertAnswer -answer $userInput
            Write-Output "askUserScope user input: $($userInput), converted to: $($userScope)" >> $logFilePath

            
            if ($null -eq $userScope) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                askUserScope  # Retry
            }
            return $userScope
        }
        catch {
            Write-Host "ERROR in askUserScope(): $_" -ForegroundColor Red
            Write-Output "ERROR in askUserScope(): $_" >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are making changes to SharePoint
function askChangeSP {

    Write-Output "askChangeSP called" >> $logFilePath

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to remove the user from SharePoint? (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $changeSP = convertAnswer -answer $userInput
            Write-Output "askChangeSP user input: $($userInput), converted to: $($changeSP)" >> $logFilePath

            if ($null -eq $changeSP) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                continue  # Retry
            }
            return $changeSP
        }
        catch {
            Write-Host "ERROR in askChangeSP(): $_" -ForegroundColor Red
            Write-Output "ERROR in askChangeSP(): $_" >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are making changes to Teams
function askChangeTeams {

    Write-Output "askChangeTeams called" >> $logFilePath

    while ($true) {
        try {
            showHeader -logFilePath $logFilePath
            Write-Host ""
            Write-Host "Do you want to remove the user from Teams? (Yes or No): " -ForegroundColor Yellow -NoNewline; $userInput = Read-Host
            $changeTeams = convertAnswer -answer $userInput
            Write-Output "askChangeTeams user input: $($userInput), converted to: $($changeTeams)" >> $logFilePath

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
            Write-Output "ERROR in askChangeTeams(): $_" >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask for the target users UPN
function askUserUPN {

    Write-Output "askUserUPN called" >> $logFilePath

    try {
        showHeader -logFilePath $logFilePath
        Write-Host ""
        Write-Host "Please provide the target user's email address: " -ForegroundColor Yellow -NoNewline; $userUPN = Read-Host
        Write-Output "askUserUPN user input: $($userUPN)" >> $logFilePath
        if (-not (validateEmail -emailAddress $userUPN)) {
            Write-Host """$userUPN""" " Does not look like a valid email address" -ForegroundColor Red
            Write-Output "askUserUPN validation failed for input: $($userUPN)" >> $logFilePath
            $userUPN = $null
            Start-Sleep -seconds 3
            askUserUPN # Retry
        }
        Write-Output "askUserUPN validation succeeded for input: $($userUPN)" >> $logFilePath

        Start-Sleep -Seconds 1
        return $userUPN
    }
    catch {
        Write-Host "ERROR in askUserUPN(): $_" -ForegroundColor Red
        Write-Output "ERROR in askUserUPN(): $_" >> $logFilePath
        Write-Host $sassMe -ForegroundColor Yellow
        Start-Sleep -Seconds 3
    }
}

function multipleUsers {

    param (
        [string]$csvFilePath
    )

    Write-Output "multipleUsers called" >> $logFilePath

    try {
        $userUPNs = @()
        Write-Host "Cleared UPN list"
    }
    catch {
        Write-Host "Failed to clear the UPN list"
        Write-Output "multipleUsers failed to clear the UPN list" >> $logFilePath
        Start-Sleep -Seconds 2
        Write-Output $_ >> $logFilePath
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
        Write-Output "multipleUsers user input for CSV path: $($csvFilePath)" >> $logFilePath
    }
    catch {
        Write-Host "Failed to read the user prompt"
        Write-Output "multipleUsers failed to read the user prompt" >> $logFilePath
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        Write-Output "multipleUsers() failed at breakpoint 1" >> $logFilePath
        exit
    }

    try {
        $users = Import-Csv -Path $csvFilePath
    }
    catch {
        Write-Host "Failed to import the CSV"
        Write-Output "multipleUsers failed to import the CSV" >> $logFilePath
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        Write-Output "multipleUsers() failed at breakpoint 2" >> $logFilePath
        exit
    }

    try {
        $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName
        foreach ($upn in $userUPNs) {
            $validation = validateEmail -emailAddress $upn
            if ($validation) {
                Write-Output "$($upn) validated" >> $logFilePath
                Write-Host "$($upn) validated"
            }
            else {
                Write-Output "$($upn) invalid, multipleUsers re-caled" >> $logFilePath
                Write-Host "$($upn) invalid, please check your CSV and try again"
                Start-Sleep -Seconds 3
                multipleUsers
            }
        }
    }
    catch {
        Write-Host "Failed to extract the UPNs"
        Write-Output "multipleUsers failed to extract the UPNs" >> $logFilePath
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        Write-Output "multipleUsers() failed at breakpoint 3" >> $logFilePath
        exit
    }
    
    showHeader -logFilePath $logFilePath
    Write-Host ""
    Write-host "These are the UPNs I read from that file, please check them before continuing:" -ForegroundColor Yellow
    Write-Host ""
    Write-Output "multipleUsers returned to caller with: $($userUpns)" >> $logFilePath

    Write-Output "multipleUsers returned to caller with:" >> $logFilePath
    foreach ($upn in $userUPNs) {
        Write-Output "$($upn)"  >> $logFilePath
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

    Write-Output "runPermissionChanges called with parameters: userUPNs=$($userUPNs), adminURL=$($adminURL), adminUPN=$($adminUPN), changeSP=$($changeSP), changeTeams=$($changeTeams)" >> $logFilePath

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

    Write-Output "getOptions called with parameters: whatIf=$($whatIf), userScope=$($userScope), changeSP=$($changeSP), changeTeams=$($changeTeams)" >> $logFilePath

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

    Write-Output "Returend getOptions to caller with:" >> $logFilePath
    Write-Output "whatIf      = $($whatIf)" >> $logFilePath
    Write-Output "userScope   = $($userScope)" >> $logFilePath
    Write-Output "userUPNs    = $($userUpns)" >> $logFilePath
    Write-Output "changeSP    = $($changeSP)" >> $logFilePath
    Write-Output "changeTeams = $($changeTeams)" >> $logFilePath

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

    Write-Output "askAdminURL called" >> $logFilePath

    taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
    Write-Output ">>>>>>>>>>>>>>> taskstatus called in askAdminURL with whatif: $($whatIf)" >> $logFilePath

    Write-Host "The portal address must include all slashes and the scheme or it will be rejected" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "I.E. https://contoso-admin.sharepoint.com/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please provide the SharePoint admin URL: " -ForegroundColor Yellow -NoNewline; $adminURL = Read-Host
    Write-Output "askAdminURL user input: $($adminURL)" >> $logFilePath
    if (-not (validateURL -url $adminURL)) {
        Write-Host """$adminURL""" " does not look like a valid SharePoint portal URL" -ForegroundColor Red
        Write-Output "askAdminURL validation failed for input: $($adminURL)" >> $logFilePath
        $adminURL = $null
        Start-Sleep -seconds 3
        askAdminURL
    }
    Write-Output "askAdminURL validation succeeded for input: $($adminURL)" >> $logFilePath
    return $adminURL
}

# Ask for and validate the SP admin UPN
function askAdminUPN {

    Write-Output "askAdminUPN called" >> $logFilePath

    taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
    Write-Output ">>>>>>>>>>>>>>> taskstatus called in askAdminUPN with whatif: $($whatIf)" >> $logFilePath

    Write-Host "The portal address must include all slashes and the scheme or it will be rejected" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "I.E. https://contoso-admin.sharepoint.com/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please provide an Exchange Administrator email address: " -ForegroundColor Yellow -NoNewline; $adminUPN = Read-Host
    Write-Output "askAdminUPN user input: $($adminUPN)" >> $logFilePath
    if (-not (validateEmail -emailAddress $adminUPN)) {
        Write-Host """$adminUPN""" " does not look like a valid email address" -ForegroundColor Red
        Write-Output "askAdminUPN validation failed for input: $($adminUPN)" >> $logFilePath
        $adminUPN = $null
        Start-Sleep -seconds 3
        askAdminUPN
    }
    Write-Output "askAdminUPN validation succeeded for input: $($adminUPN)" >> $logFilePath
    return $adminUPN
}

# Gather additional SharePoint details
function prepSharePoint {

    param (
        [string]$userUPN,
        [string]$adminURL,
        [string]$adminUPN
    )

    Write-Output "prepSharePoint called with parameters: userUPN=$($userUPN), adminURL=$($adminURL), adminUPN=$($adminUPN)" >> $logFilePath

    $adminURL = askAdminURL
    $adminUPN = askadminUPN

    userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
}

function doSharePointMulti {
    param (
        [array]$userUPNs,
        [string]$adminURL,
        [string]$adminUPN
    )
    
    Write-Output "doSharePointMulti called with parameters: userUPNs=$($userUPNs), adminURL=$($adminURL), adminUPN=$($adminUPN)" >> $logFilePath

    if ($changeSP) {
        showHeader -logFilePath $logFilePath
        Write-Host ""
        Write-Host "Editing SharePoint, please log in and wait..." -ForegroundColor Yellow

        $null = Connect-SPOService -Url $adminURL
        $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

        foreach ($site in $siteUrls) {
            try {
                Write-Host $site
                Write-Output "doSharePointMulti processing site: $($site)" >> $logFilePath
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
                Write-Host "Error adding admin to" $site ": " $_ -ForegroundColor Red
                Write-Output "Error in doSharePointMulti while adding admin to site $($site): $_" >> $logFilePath
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
                    Write-Host "$($userUPN): $($_)" -ForegroundColor Red
                    Write-Output "Error in doSharePointMulti while removing user $($userUPN) from site $($site): $_" >> $logFilePath
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

    Write-Output "doTeams called with parameters: userUPNs=$($userUPNs)" >> $logFilePath

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
                            Write-Host "$userUPN was removed from" $team.DisplayName -ForegroundColor Green
                        }
                        else {
                            Write-Host "Would remove $userUPN from $team" -ForegroundColor Yellow
                            $teamResult += $team.DisplayName
                        }
                    }
                    else {
                        Write-Host "$userUPN not found in " $team.DisplayName -ForegroundColor Red
                    }
                }
            }
            catch {
                Write-Host "Error in doTeams(): $_" -ForegroundColor Red
                Write-Output "Error in doTeams while processing team $($team.DisplayName): $_" >> $logFilePath
            }
            Write-Host "_______________________`n"
        }
        
        function reRunLive {

            Write-Output "reRunLive called" >> $logFilePath

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

    Write-Output "userConfirm called with parameters: userUPN=$($userUPN), adminURL=$($adminURL), adminUPN=$($adminUPN), userUpns=$($userUpns)" >> $logFilePath

    taskStatus -whatIf $whatIf -changeTeams $changeTeams -changeSP $changeSP
    Write-Output ">>>>>>>>>>>>>>> taskstatus called in userConfirm with whatif: $($whatIf)" >> $logFilePath

    if ($whatIf) {
        Write-Host "This is a TEST run. Please confirm the details are correct before continuing." -ForegroundColor Green
    }
    else { Write-Host "This is a LIVE run. Please confirm the details are correct before continuing." -ForegroundColor Yellow }
    Write-Host "whatIf: ($($whatIf))"
    Write-Host ""
    if ($userScope) {
        $upnCount = $userUpns.count
        Write-Host "We will remove $($upnCount) accounts listed in your CSV" -ForegroundColor Yellow
    }
    else { Write-Host "The account being removed is: $($userUPN)" -ForegroundColor Yellow }
    Write-Host "The SharePoint tenant being accessed is: $($adminURL)" -ForegroundColor Yellow
    Write-Host "The administrator account being used to make changes is: $($adminUPN)" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "Are these details correct?: " -ForegroundColor Yellow -NoNewline; $confirmPrompt = Read-Host
    $confirmPrompt = convertAnswer -answer $confirmPrompt
    Write-Host "Converted to: $($confirmPrompt)" -ForegroundColor Green
    Write-Output "userConfirm user input: $($confirmPrompt), converted to: $($confirmPrompt)" >> $logFilePath
    Start-Sleep -Seconds 1

    if ($confirmPrompt) {
        doSharePointMulti -userUPNs $userUpns -adminURL $adminURL -adminUPN $adminUPN
    }
    else {
        Write-Host "Restarting selection..." -ForegroundColor Yellow
        Write-Output "userConfirm restarting selection due to user input: $($confirmPrompt)" >> $logFilePath
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
    Write-Output "startScript called from startScript with parameters: whatIf=$($whatIf), userUPN=$($userUPN), userScope=$($userScope), csvFilePath=$($csvFilePath), adminURL=$($adminURL), adminUPN=$($adminUPN)" >> $logFilePath

    # Check admin session
    $null = checkAdminSession
    Write-Output "checkAdminSession called from startScript" >> $logFilePath

    # Check required modules
    $null = checkModules
    Write-Output "checkModules called from startScript" >> $logFilePath

    # Get user options
    $options = getOptions -whatIf $whatIf -userScope $userScope
    $changeTeams = $options.changeTeams
    $changeSP = $options.changeSP
    $whatif = $options.whatIf
    $userScope = $options.userScope
    $userUpns = $options.userUPNs

    # Ask for and validate additional details if required
    if ($options.userScope -eq $false) {
        $userUPN = askUserUPN
    }
    else {
        $userUpns = multipleUsers -csvFilePath $csvFilePath
    }

    # Ask for the admin and SPO details
    $adminURL = askAdminURL
    $adminUPN = askAdminUPN

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
