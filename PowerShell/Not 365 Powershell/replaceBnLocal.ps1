param (
    [string]$doUser = "ITSupport2",
    [string]$bnUser = "bn",
    [string]$password = "Polar98Bear!"
)

Clear-Host

# Function to check if th euser exists
function userExists {
    param (
        [string]$username
    )
    try {
        $existingUsers = Get-LocalUser | Where-Object { $_.Name -eq $username }
        return $existingUsers.Count -gt 0
    }
    catch {
        Write-Error "Error checking if user exists: $_"
        return $false
    }
}

# Function to check if a user is an administrator
function IsAdministrator {
    param (
        [string]$username
    )
    try {
        # Known issue with get-localgroup, use net localgroup
        $adminGroupMembers = net localgroup "Administrators" | Select-String "^\S" | ForEach-Object { $_.ToString().Trim() }
        # I dont need this foreach now that im using net localgroup use -contains <<<,
        return $adminGroupMembers -contains $username
    }
    catch {
        Write-Error "Error checking if user is an administrator: $_"
        return $false
    }
}

# Check if the BN exists and remove it
if (userExists -username $bnUser) {
    try {
        Remove-LocalUser -Name $bnUser
    }
    catch {
        Write-Error "Error removing user $($bnUser): $_"
    }
}

# Remove this trycatch its pointless now <<<,
# Check if the doUser exists
if (userExists -username $doUser) {

    try {
        # Change the password 
        $user = Get-LocalUser -Name $doUser
        $user | Set-LocalUser -Password (ConvertTo-SecureString $password -AsPlainText -Force)
    }
    catch {
        Write-Error "Error changing the password for $($doUser): $_"
    }

        try {
        # Ensure the user is an administrator
        if (-not (IsAdministrator -Username $doUser)) {
            Add-LocalGroupMember -Group "Administrators" -Member $doUser
        }
    }
    catch {
        Write-Error "Error adding $doUser to the Administrators group: $_"
    }
} else {
    
    try {
        # Create the user if it didn't exist
        New-LocalUser -Name $doUser -Password (ConvertTo-SecureString $password -AsPlainText -Force) -FullName "DO Administrator" -Description "DO Admin User Account"
    }
    catch {
        Write-Error "Error creating new user $($doUser): $_"
    }

    try {
        # Add the user to the Administrators group if it wasn't a member
        Add-LocalGroupMember -Group "Administrators" -Member $doUser
    }
    catch {
        Write-Error "Error adding $($doUser) to the Administrators group: $_"
    }
}
