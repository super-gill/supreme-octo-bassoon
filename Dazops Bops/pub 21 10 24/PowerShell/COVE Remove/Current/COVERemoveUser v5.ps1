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

$spResult = @()
$teamsResult = @()
[string]$version = 5

if ($dir -gt 0) {
    Clear-Host
    Write-Host "CoveRemoveUser Version: $($version)"
    Write-Host ""
    Write-Host "For this script to work the CSV must be formatted correctly:"
    Write-Host ""
    Write-Host "UserPrincipalName"
    Write-Host "user1@email.com"
    Write-Host "user2@email.com"
    Write-Host "user3@email.com"
    Write-Host "user4@email.com"
    Write-Host ""
    Write-Host "Make sure the first line contains the title ""UserPrincipalName"" and there are no commas at the end of each line."
    Write-Host ""
    Write-Host "This script will remove the 365 permissions that cant be changed in Cove, you must still delete backup data and disable backups for each user in Cove."
    Write-Host ""
    Write-Host "On completion you must wait for Cove to perform another backup to see changes."
    Write-Host ""
    Write-Host "Use ""Get-Help .\removeUser.ps1 -Full"" for more information."
    Write-Host ""
    Write-Host "Press any key to continue..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Clear-Host
}

Write-Host ""
Write-Host "Version $($version)"
Write-Host ""

# Indicate that script is in simulation mode (WhatIf)
if ($whatIf) {
    Write-Host ""
    Write-Host "******" -ForegroundColor Yellow
    Write-Host "WhatIf" -ForegroundColor Yellow
    Write-Host "******" -ForegroundColor Yellow
    Write-Host ""
}

function validateEmail {
    param ([string]$emailAddress)
    return $emailAddress -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
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
        Write-Host "Failed to process CSV" -ForegroundColor Red
        exit
    }
}

function doTeams {
    param ([string]$UserUPN)

    # Retrieve all Teams.
    $teams = Get-Team
    
    foreach ($team in $teams) { 
        try {
            if (Get-TeamUser -GroupId $team.GroupId | Where-Object user -Like $UserUPN) {
                if (-not $whatIf) {
                    Remove-TeamUser -GroupId $team.GroupId -User $UserUPN
                    Write-Host "[$UserUPN] removed from [$($team.DisplayName)]" -ForegroundColor Yellow
                }
                else {
                    Write-Host ">> Would remove [$UserUPN] from [$($team.DisplayName)]" -ForegroundColor Yellow
                }
                $teamsResult += $team.DisplayName
            }
        }
        catch {
            Write-Host "[$UserUPN] - ERROR on [$($team.DisplayName)]: $_"
        }
    }
}

function doSharePoint {
    param (
        [string]$adminUPN, 
        [string]$adminURL, 
        $userUPNs
    )

    # Retrieve all site URLs excluding OneDrive.
    $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

    foreach ($site in $siteUrls) {
        Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $True

        foreach ($upn in $userUPNs) {
            try {
                $user = Get-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                if (-not $whatIf) {
                    Remove-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                    Write-Host "[$upn] Removed from [$site]" -ForegroundColor Yellow
                }
                else {
                    Write-Host ">> Would remove [$upn] from [$site]" -ForegroundColor Yellow
                }
                $spResult += $site
            }
            catch {
                Write-Host "[$upn] - ERROR on [$site]: $_"
            }
        }

        # Remove the site collection admin status for the adminUPN after processing all users.
        Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $False
    }
}
 
$foo = connect-microsoftteams
$foo.account.id

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
        doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs
    }

    if ($teams) {
        doTeams -UserUPN $UserUPN
    }
}

# Display the modified SharePoint sites and Teams
Write-Host ""
Write-Host "Summary of changes:"  -ForegroundColor Yellow
Write-Host ""
Write-Host "SharePoint sites edited:" -ForegroundColor Yellow
if ($spResult.Count -gt 0) {
    Write-Host $spResult
}
else {
    Write-Host "No SharePoint sites were edited"
}

Write-Host ""
Write-Host "Teams edited:"  -ForegroundColor Yellow
if ($teamsResult.Count -gt 0) {
    Write-Host $teamsResult
}
else {
    Write-Host "No Teams teams were edited"
}
