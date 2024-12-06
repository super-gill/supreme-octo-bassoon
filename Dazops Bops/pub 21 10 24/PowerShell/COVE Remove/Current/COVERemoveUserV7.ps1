<#
.SYNOPSIS
    Remove a user from all Microsoft Teams and SharePoint sites.

.DESCRIPTION
    This script removes a user from all Teams teams and SharePoint sites, ensuring the user no longer appears in Cove.

.PARAMETER UserUPN
    The UPN of the user to be removed. Ignored if the -dir parameter is used.

.PARAMETER adminURL
    The admin URL for the SharePoint site. Automatically determined if not specified.

.PARAMETER adminUPN
    The admin UPN to be temporarily added as a site collection admin. Automatically determined if not specified.

.PARAMETER dir
    The directory of the UPN CSV if provided. When this parameter is used, the userUPN is ignored.

.PARAMETER CSV
    Flag to process users from a CSV file.

.PARAMETER whatIf
    Simulate the operation without making actual changes.

.PARAMETER teams
    Switch to remove the user(s) from Teams.

.PARAMETER sharepoint
    Switch to remove the user(s) from SharePoint.

.EXAMPLE
    Remove a single user from both Teams and SharePoint:

    .\removeUser.ps1 -UserUPN user@contoso.com -teams -sharepoint

.EXAMPLE
    Remove multiple users from both Teams and SharePoint from a CSV:

    .\removeUser.ps1 -dir c:\temp\users.csv -teams -sharepoint

.EXAMPLE
    Simulate the removal of multiple users from both Teams and SharePoint:

    .\removeUser.ps1 -whatIf -dir c:\temp\users.csv -teams -sharepoint
#>

param(
    [string]$UserUPN,
    [string]$dir,
    [bool]$whatIf = $true,
    [switch]$teams,
    [switch]$sharepoint
)

[string]$version = 7

try {
    if (-not $UserUPN -and -not $dir) {
        Clear-Host
        Write-Host ""
        Write-Host "No flags have been passed" -ForegroundColor Yellow
        Write-Host "Use ""Get-Help '.\CoveRemoveUser V$version.ps1' -Full"" for help and examples of how to run this script" -ForegroundColor Yellow
        Write-Host "The script will now end, no changes have been made" -ForegroundColor Yellow
        Write-Host ""
        exit
    }

}
catch { Write-Host "Failed, exit 001" }

try {
    if ($dir -gt 0) {
        Clear-Host
        Write-Host "CoveRemoveUser Version: $($version)`n"
        Write-Host "For this script to work the CSV must be formatted correctly, with the correct file type (CSV) you can make it in Notepad:`n" -ForegroundColor Yellow
        Write-Host "    UserPrincipalName"
        Write-Host "    user1@email.com"
        Write-Host "    user2@email.com"
        Write-Host "    user3@email.com"
        Write-Host "    user4@email.com`n"
        Write-Host "Make sure the first line contains the title ""UserPrincipalName"" and there are no commas at the end of each line.`n"
        Write-Host "Use ""Get-Help .\CoveRemoveUser V$($version).ps1 -Full"" for more information.`n"
        Write-Host "Press any key to continue..." -ForegroundColor yellow
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        Clear-Host
    }
}
catch { Write-Host "Failed, exit 002`n" }

Write-Host "`nCove User Remover Version $($version)`n" -ForegroundColor green

# Indicate that script is in simulation mode (WhatIf)
if ($whatIf) {
    Write-Host "******" -ForegroundColor Yellow
    Write-Host "WhatIf" -ForegroundColor Yellow
    Write-Host "******`n" -ForegroundColor Yellow
}

function validateEmail {
    param ([string]$emailAddress)
    try {
    return $emailAddress -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    } catch {
        Write-Host "Failed to verify the email: "$_
    }
}

function multipleUsers {
    param ([string]$dir)

    try {
        $userUPNs = @()
        $users = Import-Csv -Path $dir
        $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName -Unique
        $invalidUPNs = $userUPNs | Where-Object { -not (validateEmail $_) }
        
        if ($invalidUPNs.Count -gt 0) {
            Write-Host "Invalid UPNs:" -ForegroundColor Red
            $invalidUPNs | ForEach-Object { Write-Host $_ -ForegroundColor Red }
            exit
        }
        
        return $userUPNs
    }
    catch {
        Write-Host "`nFailed to process CSV" -ForegroundColor Red
        Write-Host "Check its the right file type (CSV)`n" -ForegroundColor Red
        Write-Host $_
        exit
    }
}

function doTeams {
    param (
        [string]$UserUPN,
        [string]$userUPNs
    )

    # Retrieve all Teams.
    $teams = Get-Team
    # foreach ($team in $teams) {Write-Host $team.displayname}
    
    foreach ($team in $teams) {
        foreach ($user in $userUPNs) {
            # Always output a message indicating the check is happening
            Write-Host "Checking [$($team.DisplayName)] for [$user]"

            try {
                # Attempt to get the team user and filter based on $UserUPN
                $teamUser = Get-TeamUser -GroupId $team.GroupId | Where-Object { $_.User -like $UserUPN }
                
                if ($teamUser) {
                    if (-not $whatIf) {
                        Remove-TeamUser -GroupId $team.GroupId -User $UserUPN
                        Write-Host "[$UserUPN] removed from [$($team.DisplayName)]" -ForegroundColor Yellow
                    }
                    else {
                        Write-Host ">> Would remove [$UserUPN] from [$($team.DisplayName)]" -ForegroundColor Yellow
                    }
                } 
                else {
                    # Output if the user was not found in the team
                    Write-Host "[$UserUPN] not found in [$($team.DisplayName)]"
                }
            }
            catch {
                Write-Host "[$UserUPN] - ERROR on [$($team.DisplayName)]: $_" -ForegroundColor Red
            }
        }
    }
}




function doSharePoint {
    param (
        [string]$adminUPN, 
        [string]$adminURL, 
        $userUPNs
    )

    Write-Host "`nChecking SharePoint Sites...`n"
    # Retrieve all site URLs excluding OneDrive.
    $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

    foreach ($site in $siteUrls) {
        Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $True | out-null

        foreach ($upn in $userUPNs) {
            try {
                $user = Get-SPOUser -Site $site -LoginName $upn -ErrorAction Stop | out-null
                if (-not $whatIf) {
                    Remove-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                    Write-Host "[$upn] - Removed from [$site]" -ForegroundColor Yellow
                    $localspresult += $site
                }
                else {
                    Write-Host "[$upn] - Would be removed from [$site]" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "[$upn] - ERROR on [$site]: $_"
            }
        }

        # Remove the site collection admin status for the adminUPN after processing all users.
        Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $False | out-null
    }
    return $localspresult
}
 
$foo = connect-microsoftteams
[void]($foo.account.id)

[string]$adminUPN = $foo.account.id

connect-exchangeonline
try {
    #$adminURL = ((Get-UnifiedGroup -Filter { ResourceProvisioningOptions -eq "Team" }).sharepointsiteurl).split(".")[0] + "-admin.sharepoint.com/"
    $sharepointSites = (Get-UnifiedGroup -Filter { ResourceProvisioningOptions -eq "Team" }).sharepointsiteurl
    $adminURL = ($sharepointSites -ne $null).split(".")[0] + "-admin.sharepoint.com/"
    write-host "Admin URL: $($adminURL)"
    Connect-SPOService -Url $adminURL
}
catch {
    Write-Host "Failed to get the Sharepoint admin portal URL, please provide it or check the user's UPN`n" -ForegroundColor red
    Write-Host "Users UPN passed to the script:     $($UserUPN) *if blank then null value" -ForegroundColor Yellow
    Write-Host "Admin Portal passed to the script:  $($adminURL) *if blank then null value`n" -ForegroundColor Yellow
    $adminurl = Read-Host -prompt "SharePoint Admin URL"
}

Connect-SPOService -Url $adminURL

if ($dir -ne "") {
    $userUPNs = multipleUsers -dir $dir

    Write-Host ""
    Write-Host "Processing SharePoint users from CSV"
    foreach ($upn in $userUPNs) {
        doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs @($upn)
    }

    Write-Host ""
    Write-Host "Processing Teams users from CSV"
    foreach ($upn in $userUPNs) {
        doTeams -UserUPN $upn
    }
}
else {
    if ($sharepoint) {
        $userUPNs = @($UserUPN)
        doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPN
    }

    if ($teams) {
        doTeams -UserUPN $UserUPN
    }
}
