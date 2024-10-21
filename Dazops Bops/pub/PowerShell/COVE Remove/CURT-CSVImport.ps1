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


# provided for reference but never actually called
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

function multipleUsers {

    param (
        [string]$dir
    )

    try { $userUPNs = $null
    } catch {
        Write-Host "Failed to clear the UPN list"
        Write-Output "Failed to clear the UPN list"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }
    
    Write-Output "$($MyInvocation.MyCommand.Name) called | dir: $($dir)" >> $logFilePath

    # showHeader commented out for test

    Write-Host ""
    Write-Host "You will need to provide a CSV containing a vertical list of all UPNs you want to modify" -ForegroundColor Yellow
    Write-Host "They must have a title that reads "UserPrincipalName" with no spaces I.E:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UserPrincipalName" -ForegroundColor Yellow
    Write-Host "user1@contoso.com" -ForegroundColor Yellow
    Write-Host "user2@contoso.com" -ForegroundColor Yellow
    Write-Host "user3@contoso.com" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This list is not currently validated so double check the accuracy" -ForegroundColor Yellow
    Write-Host ""
    try {
    $dir = Read-Host -Prompt "Please provide the full path to the CSV (I.E C:\temp\users.csv)"
    } catch {
        Write-Host "Failed to find the file"
        Write-Output "Failed to find the file"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }

    try {
    $users = Import-Csv -Path $dir
    } catch {
        Write-Host "Failed to import the CSV"
        Write-Output "Failed to import the CSV"
        Start-Sleep -Seconds 3
        Write-Output $_ >> $logFilePath
        exit # needs to go somewhere instead of just quitting
    }

    try {
    $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName
    } catch {
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
    return $userUpns  # Return the UPNs to caller
}


function checkUserScope {
    param (
        [array]$userUpns
    )

    if ($false -eq $userScope) {


        $selectedUPNs = multipleUsers

        Write-Host "Selected UPNs:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host $($selectedUPNs)
        # foreach ($upn in $selectedUPNs) {
        #     Write-Host $upn
        # }
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
        # $userUPN = askUserUPN commented out for test
    }
}
$userScope = $false
$checkUserScope = checkUserScope