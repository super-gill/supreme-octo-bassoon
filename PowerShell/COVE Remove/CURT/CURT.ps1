param (
    [bool]$whatIf = $true,
    [bool]$userUPN,
    [bool]$userScope = $true,
    [string]$dir,
    [string]$adminURL,
    [string]$adminUPN
)

# Script details
[int]$version = 3
[string]$scriptName = [system.io.path]::GetFileName($PSCommandPath)
[string]$author = "Jason Mcdill"

# Global variables (hidden from the CLI)
[string]$sassMe = "Invalid answer"
[bool]$isadmin
$userUpns = @()
[string]$logFilePath

# General function to convert a yes/no value to boolean 
function convertAnswer {

    param (
        [string]$answer # Recievie the answer (yes/no/y/n etc) from the calling function
    )

    Write-Output "convertAnswer ran with $($answer) to be converted" >> $logFilePath
    write-output "whatIf = $($whatIf)" >> $logFilePath

    switch ($answer.ToLower()) {
        # Convert the answer to lower case and convert it to a boolean
        "yes" { return $true } # PS switches are way easier than JS switches
        "no" { return $false }
        "y" { return $true }
        "n" { return $false }
        default {
            Write-Output "$($MyInvocation.MyCommand.Name) failed to match $($answer)" >> $logFilePath
            write-output "whatIf = $($whatIf)" >> $logFilePath
            return $null # If the conversion fails return $null to the calling function so it knows it failed
        }
    }
}

# Function to validate email addresses
function validateEmail {

    param (
        [string]$emailAddress # Pass the email from the calling function
    )
    
    Write-Output "$($MyInvocation.MyCommand.Name) called | emailAddress reads $($emailAddress)" >> $logFilePath

    $emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' # Compare the email to an email regex
    
    # Output boolean depending on if it matches the regex or not
    if ($emailAddress -match $emailPattern) {
        Write-Output "$($MyInvocation.MyCommand.Name) returned true for $($emailAddress)" >> $logFilePath
        return $true
    }
    else {
        Write-Output "$($MyInvocation.MyCommand.Name) returned false for $($emailAddress)" >> $logFilePath
        return $false
    }
}

# Function to validate the URL
function validateURL {

    param (
        [string]$url # Pass the URL from the calling function
    )

    Write-Output "$($MyInvocation.MyCommand.Name) called | url reads $($url)" >> $logFilePath

    $urlPattern = '^https:\/\/[a-zA-Z0-9-]+\.sharepoint\.com\/$' # Compare the URL to a URL regex specifically looking for SP portal

    # Output boolean depending on if it matches the regex or not
    if ($url -match $urlPattern) {
        Write-Output "$($MyInvocation.MyCommand.Name) returned true" >> $logFilePath
        return $true
    }
    else {
        Write-Output "$($MyInvocation.MyCommand.Name) returned false" >> $logFilePath
        return $false
    }
}

function startLogging {

    param (
        [bool]$whatIf = $true,
        [bool]$userUPN,
        [bool]$userScope = $true,
        [string]$dir,
        [string]$adminURL,
        [string]$adminUPN
    )

    function createLog {

        showHeader
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
        Write-Output "=======================================================" >> $logFilePath
        Write-Output "" >> $logFilePath
        Write-Output "Loaded parameters:" >> $logFilePath 
        Write-Output "whatIf: $($whatIf)" >> $logFilePath
        Write-Output "userUPN: $($userUPN)" >> $logFilePath
        Write-Output "userScope: $($userScope)" >> $logFilePath
        Write-Output "dir: $($dir)" >> $logFilePath
        Write-Output "adminURL: $($adminURL)" >> $logFilePath
        Write-Output "adminUPN: $($adminUPN)" >> $logFilePath
        Write-Output "=======================================================" >> $logFilePath

        showInstructions
    }


    # Check if the current PowerShell session is running as administrator
    function checkAdminSession {

        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

        if ($isAdmin) {
            Write-Output "$($MyInvocation.MyCommand.Name) returned true" >> $logFilePath
            showHeader
            Write-Host ""
            Write-Host "Do not run this as an administrator, restart PowerShell as the logged in user."
            Write-Host ""
            Write-Host -NoNewLine 'Press any key to continue...'
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') # listen for a keypress
            Clear-Host
            Start-Sleep -seconds 5 # Dont actually hard fail on runas admin, just feint it
            showInstructions
        }
        else {
            Write-Output "$($MyInvocation.MyCommand.Name) returned false" >> $logFilePath
            showInstructions
            Write-Output $_ >> $logFilePath
        }
    }

    function checkModules {

        Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

        $teamsModule = get-module -ListAvailable -name MicrosoftTeams
        $SPModule = Get-Module -ListAvailable -name SharePointPnPPowerShellOnline
    
        if ($teamsModule -and $SPModule -ne $null) {
            Write-Output "$($MyInvocation.MyCommand.Name) SP and Teams modules are installed" >> $logFilePath
            showInstructions
        }
        else {
            showHeader
            Write-Host ""
            if ($false -eq $SPModule) {
                Write-Output "$($MyInvocation.MyCommand.Name) SP Module is not installed" >> $logFilePath
                Write-Host "The SharePoint poweshell module is not installed, you can install this module" -ForegroundColor Yellow
                Write-Host "from the Digital Origin Company Portal app." -ForegroundColor Yellow
                Write-Host "The script will now exit." -ForegroundColor Yellow
                Write-Host ""
            }
            if ($false -eq $teamsModule) {
                Write-Output "$($MyInvocation.MyCommand.Name) Teams module is not installed" >> $logFilePath
                Write-Host "The Teams poweshell module is not installed, you can install this module" -ForegroundColor Yellow
                Write-Host "from the Digital Origin Company Portal app." -ForegroundColor Yellow
                Write-Host "The script will now exit." -ForegroundColor Yellow
                Write-Host ""
            }
        }
    }
    $createLog = createLog
    $checkAdminSession = checkAdminSession
    $checkModules = checkModules
}

# Display the header
function showHeader {

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    # I didnt feel like doing anything actually productive tonight so here is an automatically adjusting and centering header.
    Clear-Host
    
    if ($isadmin) {
        Write-Host "[Running as administrator]"
    }
    
    # Define the box width
    $boxWidth = 60
    
    # Define the text lines
    $textLines = @(
        "Cove User Removal Tool",
        "Written by Jason Prime",
        "Version $($version)"
        "Log File: $($logFilePath)"
    )
    
    # Calculate the padding for each line
    $paddingLines = $textLines | ForEach-Object {
        $textLength = $_.Length
        $totalPadding = $boxWidth - $textLength - 4
        $leftPadding = " " * [math]::Floor($totalPadding / 2)
        $rightPadding = " " * [math]::Ceiling($totalPadding / 2)
        "$leftPadding$_$rightPadding"
    }
    
    # Output the header
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

    showHeader
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
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown') # listen for a keypress
    getOptions
}



# Present the current configuration of the script to the user
function taskStatus {

    param (
        [bool]$whatIf,
        [string]$changeSP,
        [bool]$changeTeams
    )

    Write-Output "$($MyInvocation.MyCommand.Name) called | whatIf: $($whatIf) | changeSP: $($changeSP) | changeTeams: $($changeTeams)" >> $logFilePath
    write-output "^ whatIf = $($whatIf)" >> $logFilePath

    showHeader
    Write-Host ""

    # Remind the user the status of WhatIf
    if ($whatIf) {
        Write-Host "> This is a test run" -ForegroundColor Green
    }
    else {
        Write-Host "> This is a live run, changes will be applied!" -ForegroundColor Red
        Write-Host "whatIf: ($($whatIf))"
    }

    # Remind the user the status of SP and Teams changes
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
    
    Write-Host ""
    Write-Host "SharePoint permissions editor" -ForegroundColor Green
    Write-Host ""
}

# Ask if we are enabling WhatIf
function askWhatIf {

    param (
        [bool]$whatIf
    )

    Write-Output "$($MyInvocation.MyCommand.Name) called | whatIf: $($whatIf)" >> $logFilePath
    write-output "^ whatIf = $($whatIf)" >> $logFilePath

    while ($true) {
        try {
            showHeader
            Write-Host ""
            $input = Read-Host -Prompt "Do you want to test run before making changes? (recommended!) (Yes or No)" 
            $whatIf = convertAnswer -answer $input
            Write-Output "$($MyInvocation.MyCommand.Name) called convertAnswer with input: $($input) and it was converted to $($whatIf)" >> $logFilePath
            
            if ($null -eq $whatIf) {
                Write-Host $sassMe -ForegroundColor Yellow
                $whatIf = $true
                Start-Sleep -Seconds 4
                askWhatIf  # Retry
            }
            Write-Host "Converted to: $($whatIf)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            if ($whatIf -eq $null) {
                Write-Host "I couldnt read the value of whatIf and set it to True"
                Start-Sleep 3 -Seconds
                $whatIf = $true
                return $whatIf
            }
            return $whatIf
        }
        catch {
            Write-Host "ERROR in askWhatIf(): $_" -ForegroundColor Red
            Write-Output $_ >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            askWhatIf  # Retry
        }
    }
}

# Ask if we are using a single user UPN or importing a list
function askUserScope {

    # param (
    #     [bool]$userScope # $true is single user $false is array
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    while ($true) {
        try {
            showHeader
            Write-Host ""
            $input = Read-Host -Prompt "Are we changing a single user or multiple? (Yes for single or No for import multiple)"
            $userScope = convertAnswer -answer $input
            Write-Output "$($MyInvocation.MyCommand.Name) called convertAnswer with input: $($input) and it was converted to $($userScope)" >> $logFilePath

            
            if ($null -eq $userScope) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                askUserScope  # Retry
            }
            
            Write-Host "Converted to: $($userScope)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $userScope
        }
        catch {
            Write-Host "ERROR in userScope(): $_" -ForegroundColor Red
            Write-Output $_ >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

# Ask if we are making changes to SharePoint
function askChangeSP {

    # param (
    #     [bool]$changeSP
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    while ($true) {
        try {
            showHeader
            Write-Host ""
            $input = Read-Host -Prompt "Do you want to remove the user from SharePoint? (Yes or No)"
            $changeSP = convertAnswer -answer $input
            Write-Output "$($MyInvocation.MyCommand.Name) called convertAnswer with input: $($input) and it was converted to $($changeSP)" >> $logFilePath

            
            if ($null -eq $changeSP) {
                Write-Host "Invalid input. Please enter Yes or No." -ForegroundColor Yellow
                Start-Sleep -Seconds 4
                continue  # Retry
            }
            
            Write-Host "Converted to: $($changeSP)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $changeSP
        }
        catch {
            Write-Host "ERROR in askChangeSP(): $_" -ForegroundColor Red
            Write-Output $_ >> $logFilePath
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}


# Ask if we are making changes to Teams
function askChangeTeams {

    # param (
    #     [bool]$changeTeams
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    while ($true) {
        try {
            showHeader
            Write-Host ""
            $input = Read-Host -Prompt "Do you want to remove the user from Teams? (Yes or No)" 
            $changeTeams = convertAnswer -answer $input
            Write-Output "$($MyInvocation.MyCommand.Name) called convertAnswer with input: $($input) and it was converted to $($changeTeams)" >> $logFilePath


            if ($null -eq $changeTeams) {
                Write-Host $sassMe -ForegroundColor Yellow
                $changeTeams = $null
                Start-Sleep -Seconds 4
                askChangeTeams  # Retry
            }

            Write-Host "Converted to: $($changeTeams)" -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $ChangeTeams
        }
        catch {
            Write-Host "ERROR in askChangeTeams(): $_" -ForegroundColor Red
            Write-Output $_
            Write-Host $sassMe -ForegroundColor Yellow
            Start-Sleep -Seconds 3
            askChangeTeams  # Retry
        }
    }
}

# Ask for the target users UPN
function askUserUPN {

    # param (
    #     [string]$userUPN
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    try {
        showHeader
        Write-Host ""
        $userUPN = Read-Host -Prompt "Please provide the target user's email address"
        if (-not (validateEmail -emailAddress $userUPN)) {
            Write-Host """$userUPN""" " Does not look like a valid email address" -ForegroundColor Red
            Write-Output "$($MyInvocation.MyCommand.Name) input failed (invalid): $($userUPN) re-called this function" >> $logFilePath
            $userUPN = $null
            Start-Sleep -seconds 3
            askUserUPN # Retry
        }
        Write-Host "$($userUPN) passed validation" -ForegroundColor Green
        Write-Output "$($MyInvocation.MyCommand.Name) input succeeded: $($userUPN)" >> $logFilePath

        Start-Sleep -Seconds 1
        return $userUPN
    }
    catch {
        Write-Host "ERROR in askUserUPN(): $_" -ForegroundColor Red
        Write-Output $_ >> $logFilePath
        Write-Host $sassMe -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        askUserUPN  # Retry
    }
}

function multipleUsers {

    param (
        [string]$dir
    )

    try {
        $userUPNs = @()  # Initialize an empty array
        Write-Host "Cleared UPN list"
    }
    catch {
        Write-Host "Failed to clear the UPN list"
        Write-Output "Failed to clear the UPN list"
        Start-Sleep -Seconds 2
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }

    Write-Output "$($MyInvocation.MyCommand.Name) called | dir: $($dir)" >> $logFilePath

    showHeader

    Write-Host ""
    Write-Host "You will need to provide a CSV containing a vertical list of all UPNs you want to modify" -ForegroundColor Yellow
    Write-Host "They must have a title that reads "UserPrincipalName" with no spaces I.E:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UserPrincipalName," -ForegroundColor Yellow
    Write-Host "user1@contoso.com," -ForegroundColor Yellow
    Write-Host "user2@contoso.com," -ForegroundColor Yellow
    Write-Host "user3@contoso.com," -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This list is not currently validated so double check the accuracy" -ForegroundColor Yellow
    Write-Host ""

    try {
        $dir = Read-Host -Prompt "Please provide the full path to the CSV (I.E C:\temp\users.csv)"
    }
    catch {
        Write-Host "Failed to read the user prompt"
        Write-Output "Failed to read the user prompt"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }

    try {
        $users = Import-Csv -Path $dir
    }
    catch {
        Write-Host "Failed to import the CSV"
        Write-Output "Failed to import the CSV"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }

    try {
        $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName
    }
    catch {
        Write-Host "Failed to add extract the UPNs"
        Write-Output "Failed to add extract the UPNs"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting  
    }
    
    Write-Host ""
    Write-host "These are the UPNs i read from that file, please check them before continuing:" -ForegroundColor Yellow
    Write-Host ""
    Write-Output $userUpns
    return # $userUpns  # Return the UPNs to caller
}

function runPermissionChanges {
    # Run the selected permission change functions

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    if ($changeSP) {
        prepSharePoint -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
    }
    if ($changeTeams) {
        doTeams -userUPN $userUPN
    }
}

# Run the question functions to gather inputs and options
function getOptions {
    param (
        $whatIf,
        [bool]$userScope,
        [bool]$changeSP,
        [bool]$changeTeams,
        [string]$userUPN
    )

    Write-Output "=======================================================" >> $logFilePath
    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath
    write-output "Passed parameters:" >> $logFilePath
    write-output "[whatIf]$whatIf" >> $logFilePath
    write-output "[userScope]$userScope" >> $logFilePath
    write-output "[changeSP]$changeSP" >> $logFilePath
    write-output "[changeTeams]$changeTeams" >> $logFilePath
    write-output "[userUPN]$userUPN" >> $logFilePath
    Write-Output "=======================================================" >> $logFilePath

    showHeader

    Write-Host ""
    Write-Host "Please follow the prompts below to proceed." -ForegroundColor Green
    Write-Host ""
    
    $whatIf = askWhatIf
    $userScope = askUserScope

    function checkUserScope {
        if ($false -eq $userScope) {
            param (
                [array]$userUpns

            )

            $selectedUPNs = multipleUsers
            
            showHeader
            Write-Host ""
            Write-Host "Selected UPNs:" -ForegroundColor Yellow
            Write-Host ""
            foreach ($upn in $selectedUPNs) {
                Write-Host "$($upn)" -ForegroundColor Green
            }
            Write-Host ""
            $confirm = Read-Host -Prompt "Confirm the UPNs have been read correctly"
            $confirm = convertAnswer -answer $confirm
            Write-Host "Converted to: $($confirm)" -ForegroundColor Green
            start-sleep -Seconds 1

            if ($false -eq $confirm) {
                Write-Host "Restarting selection..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
                getOptions # Restart options selection
            }
        }
        else { 
            $userUPN = askUserUPN 
        }
    }
    $checkUserScope = checkUserScope
    
    $changeSP = askChangeSP
    $changeTeams = askChangeTeams

    # Check if both $changeSP and $changeTeams are false
    if (-not ($changeSP -or $changeTeams)) {
        Write-Host "You selected No for both SharePoint and Teams changes. Restarting selection..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        getOptions -whatIf $whatIf -changeSP $changeSP -changeTeams $changeTeams -userUPN $userUPN
    }
    elseif ($askUserScope) {
        $userUPN = askUserUPN -userUPN $userUPN
    }
    runPermissionChanges -userUPN $userUpns -adminUPN $adminUPN -adminURL $adminURL
}
# Ask for and validate the SPO portal URL
function askAdminURL {

    # param (
    #     $adminURL
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    taskStatus
    Write-Host "The portal address must include all slashes and the scheme or it will be rejected" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "I.E. https://contoso-admin.sharepoint.com/" -ForegroundColor Yellow
    Write-Host ""
    $adminURL = Read-Host -Prompt "Please provide the SharePoint admin URL"
    if (-not (validateURL -url $adminURL)) {
        Write-Host """$adminURL""" " does not look like a valid SharePoint portal URL" -ForegroundColor Red
        $adminURL = $null
        Start-Sleep -seconds 3
        askAdminURL
    } 
    Write-Host "$($adminURL) passed validation" -ForegroundColor Green
    Start-Sleep -Seconds 1
    return $adminURL
}

# Ask for and validate the SP admin UPN
function askAdminUPN {

    # param (
    #     $adminUPN
    # )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    taskStatus
    Write-Host "The portal address must include all slashes and the scheme or it will be rejected" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "I.E. https://contoso-admin.sharepoint.com/" -ForegroundColor Yellow
    Write-Host ""
    $adminUPN = Read-Host -Prompt "Please provide an Exchange Administrator email address"
    if (-not (validateEmail -emailAddress $adminUPN)) {
        Write-Host """$adminUPN""" " does not look like a valid email address" -ForegroundColor Red
        $adminUPN = $null
        Start-Sleep -seconds 3
        askAdminUPN
    }
    Write-Host "$($adminUPN) passed validation" -ForegroundColor Green
    Start-Sleep -Seconds 1

    return $adminUPN
}

# Gather additional SharePoint details
function prepSharePoint {

    param (
        [string]$userUPN,
        [string]$adminURL,
        [string]$adminUPN
    )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    $adminURL = askAdminURL
    $adminUPN = askadminUPN

    # Let the user check and confirm their inputs
    userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
}

# =============

function doSharePoint {
    param (
        $adminURL,
        $adminUPN,
        $changeTeams,
        $changeSP
    )
    
    if ($changeSP) {

        # Connect to SPO and create an array
        showHeader
        Write-Host ""
        Write-Host "Editing SharePoint, please log in and wait..." -ForegroundColor Yellow

        $null = Connect-SPOService -Url $adminURL
        $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

        foreach ($site in $siteUrls) {
            # Check or add the site collection admin
            try {
                Write-Host $site
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
            }

            # Try to delete the user
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
                Write-Host $_ -ForegroundColor Red
            }
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $false > $null
            Write-Host "$adminUPN removed"
            Write-Host "_______________________________`n"
        }
        if ($whatIf -and ($changeTeams -eq $false)) {
            $runLive = Read-Host -Prompt "Do you want to run this live with the current settings?"
            convertAnswer -answer $runLive
            if ($runLive) {
                $whatIf = $false
                Write-Host "Called what if false with: userUPN: $($userUPN) adminURL: $($adminURL) adminUPN: $($adminUPN)"
                Start-Sleep -Seconds 5
                whatIfFalse -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
            }
        }
    }
}

function doSharePointMulti {
    param (
        $adminURL,
        $adminUPN,
        $changeTeams,
        $changeSP
    )

    [array]$userUpns = @("one@one.com", "wto@one.com", "three@one.com") # <<<<<<<<<<<<<<<<<<
    
    if ($changeSP) {

        # Connect to SPO and create an array
        showHeader
        Write-Host ""
        Write-Host "Editing SharePoint, please log in and wait..." -ForegroundColor Yellow

        $null = Connect-SPOService -Url $adminURL
        $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

        foreach ($site in $siteUrls) {
            # Check or add the site collection admin
            try {
                Write-Host $site
                $user = Get-SPOUser -Site $site -LoginName $adminUPN -ErrorAction Stop > $null
                if ($user.IsSiteCollectionAdmin) {
                    Write-Host "$adminUPN already an admin"
                }
                else {
                    Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $true > $null
                    if (-not $?) { 
                        Write-Host "Adding site collection admin failed, attempting to add a new owner..."
                        Set-SPOSite -Identity $adminURL -Owner $adminUPN -NoWait 
                    }
                    Write-Host "$adminUPN added as admin"
                }
            }
            catch {
                Write-Host "Error adding admin to" $site ": " $_ -ForegroundColor Red
            }

            # Try to delete the user
            foreach ($user in $userUpns) {
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
                    Write-Host "$($user): $($_)" -ForegroundColor Red
                }
            }
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $false > $null
            Write-Host "$adminUPN removed"
            Write-Host "_______________________________`n"
        }
        if ($whatIf -and ($changeTeams -eq $false)) {
            $runLive = Read-Host -Prompt "Do you want to run this live with the current settings?"
            convertAnswer -answer $runLive
            if ($runLive) {
                $whatIf = $false
                Write-Host "Called what if false with: userUPN: $($userUPN) adminURL: $($adminURL) adminUPN: $($adminUPN)"
                Start-Sleep -Seconds 5
                whatIfFalse -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
            }
        }
    }
}
# =====================

# Perform Teams actions
function doTeams {

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

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
        $teams = Get-Team # Comprenhensive  array of Teams teams

        foreach ($team in $teams) {
            try {
                # If a user that matches the value of $userUPN is found as a member or owner of the team
                if (Get-TeamUser -GroupId $team.GroupId | Where-Object user -Like $userUPN) {
                    if ($whatIf -eq $false) {
                        Remove-TeamUser -GroupId $team.GroupId -User $userUPN
                        $teamResult += $team.DisplayName
                        Write-Host "$userUPN was removed from" $team.DisplayName -ForegroundColor Green
                    }
                    else {
                        Write-Host "Would remove $userUPN from $team" -ForegroundColor Yellow
                        $teamResult += $team.DisplayName # Add the Teams displayname to the results array, unlike SP the inital array contains all Team info
                    }
                }
                else {
                    Write-Host "$userUPN not found in " $team.DisplayName -ForegroundColor Red
                }
            }
            catch {
                Write-Host "Error in doTeams(): $_" -ForegroundColor Red
            }
            Write-Host "_______________________`n"
        }
        
        function reRunLive {

            Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

            param (
                [string]$userUPN,
                [string]$adminURL,
                [string]$adminUPN
            )

            # If $whatIf is true and $changeSP is true offer to re-run the changes live
            if ($whatIf -and $changeSP) {
                $runLive = Read-Host -Prompt "Do you want to run this live with the current settings?"
                convertAnswer -answer $runLive
                if ($runLive) {
                    $whatIf = $false

                    userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN
                }
            }
            # If $whatIf is true and $changeSP is false offer to re-run the changes live
            if ($whatIf -and -not $changeSP) {
                $runLive = Read-Host -Prompt "Do you want to run this live with the current settings?"
                convertAnswer -answer $runLive
                if ($runLive) {
                    $whatIf = $false
                    doTeams
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

# Get the user to confirm they dont want to run a WhatIf first
function userConfirm {

    # This function call requires parameters to complete correctly
    # userConfirm -userUPN $userUPN -adminURL $adminURL -adminUPN $adminUPN

    param (
        [string]$userUPN,
        [string]$adminURL,
        [string]$adminUPN,
        [array]$userUpns
    )

    Write-Output "$($MyInvocation.MyCommand.Name) called" >> $logFilePath

    taskStatus
    if ($whatIf) {
        Write-Host "This is a TEST run. Please confirm the details are correct before continuing." -ForegroundColor Green
    }
    else { Write-Host "This is a LIVE run. Please confirm the details are correct before continuing." -ForegroundColor Yellow }
    Write-Host "whatIf: ($($whatIf))"
    Write-Host ""
    Write-Host "The account being removed is: $($userUPN) (Blank if array [FIX ME])" -ForegroundColor Yellow
    Write-Host "The SharePoint tenant being accessed is: $($adminURL)" -ForegroundColor Yellow
    Write-Host "The administrator account being used to make changes is: $($adminUPN)" -ForegroundColor Yellow
    Write-Host ""
    
    $confirmPrompt = Read-Host -Prompt "Are these details correct?"
    $confirmPrompt = convertAnswer -answer $confirmPrompt
    Write-Host "Converted to: $($confirmPrompt)" -ForegroundColor Green
    Start-Sleep -Seconds 1

    if ($confirmPrompt) {
        doSharePoint -adminURL $adminURL -adminUPN $adminUPN -userUPN $userUPN -userUpns $userUpns
    }
    else {
        Write-Host "Restarting selection..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        getOptions  # Restart options selection
    }
}

# Start the script

if ($userUPN -ne "") {
    Write-Host ""
    Write-Host "Running the script without the UI has been disabled, restarting in UI mode..." -ForegroundColor Red
    Write-Host ""
    Start-Sleep -seconds 3
    checkAdminSession
}

# Start the script

function startScript {
    param (
    [bool]$whatIf,
    [bool]$userUPN,
    [bool]$userScope,
    [string]$dir,
    [string]$adminURL,
    [string]$adminUPN
)

$null = startLogging
$null = 
}



# doSharePoint -changeSP $true -adminUPN "o365admin@pecan.org.uk" -adminURL "https://pecan-admin.sharepoint.com/" -userUPN "covetestuser@pecan.org.uk" -changeTeam $false -userUpns $null -userScope $true
# doSharePointMulti -userUpns $userUpns -changeSP $true -adminUPN "o365admin@pecan.org.uk" -adminURL "https://pecan-admin.sharepoint.com/" -userUPN "covetestuser@pecan.org.uk" -changeTeam $false -userUpns $null -userScope $true
