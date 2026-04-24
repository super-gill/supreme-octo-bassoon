<#
.SYNOPSIS
    Remove the specified user from all Microsoft Teams teams.

.DESCRIPTION
    This script removes a target user from all Teams teams, ensuring the user no longer appears in Cove.
    It can optionally simulate the removal operation using the -WhatIf parameter.

.PARAMETER teamsUserUPN
    The user principal name (UPN) of the Teams user to be removed.

.PARAMETER whatIf
    Flag to indicate whether to perform a "WhatIf" operation (default is true).

.EXAMPLE
    .\removeTeamsUser.ps1 -teamsUserUPN user@contoso.com -whatIf $false
    This command removes the user user@contoso.com from all Teams teams.

.EXAMPLE
    .\removeTeamsUser.ps1 -teamsUserUPN user@contoso.com
    This command simulates the removal of the user user@contoso.com from all Teams teams.

.NOTES
    Author: Jason Mcdill
#>

param(
    [string]$teamsUserUPN,
    [bool]$whatIf = $true
)

param(
    $teamsUserUPN, # The UPN of the Teams user to be removed.
    $whatIf = $true # Flag WhatIf (default to true).
)

# Connect to Microsoft Teams.
Connect-MicrosoftTeams

# Initialize an array to store the results of team modifications.
$teamResult = @()

# Check if the users UPN is available.
if ($null -eq $teamsUserUPN) {
    # If not provided, prompt for the users UPN.
    $teamsUserUPN = Read-Host -Prompt "Please enter the users email address:"
}
# Retrieve all Teams teams teams teams teams.
$teams = (Get-Team)
    
# Iterate through each team.
foreach ($team in $teams) { 
    try {
        # Check if the user is a member of the current team.
        if (Get-TeamUser -GroupId $team.GroupId | Where-Object user -Like $teamsUserUPN) {
            if ($WhatIf -eq $false) {
                # If WhatIf is false, remove the user from the team.
                [void](Remove-TeamUser -GroupId $team.GroupId -User $teamsUserUPN)
                # Add the team name to the result array.
                $teamResult += ($team.DisplayName)
                Write-Host $teamsUserUPN" was removed from "$team.DisplayName
            }
            else {
                # If WhatIf is true, simulate the removal.
                Write-Host ">> Would remove $teamsUserUPN from " $team.displayName 
                # Add the team name to the result array.
                $teamResult += ($team.DisplayName)
            }
        }
        else {
            # If the user is not found in the team, display a message.
            Write-Host $teamsUserUPN " not found in "$team.DisplayName
        }
    }
    catch {
        # Catch and display any errors.
        Write-Host "ERROR: $_"
    }
    # Separate the output for each team with a line.
    Write-Host "_______________________`n"
}


# Display the list of teams that were or would have been edited.
if ($whatIf -eq $false) {
    Write-Host "The following Teams were edited:`n" $teamResult "`n`n"
}
else {
    Write-Host "The following Teams would have been edited:`n" $teamResult "`n`n"
}
