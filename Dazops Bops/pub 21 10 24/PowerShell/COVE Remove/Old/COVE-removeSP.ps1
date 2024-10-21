<#
.SYNOPSIS
    Remove special permissions in SharePoint and any share links associated with the specified user.

.DESCRIPTION
    This script removes special permissions for a user in SharePoint to ensure the user no longer appears in Cove.
    It also removes any share links associated with the user.
    The script can simulate the operation using the -WhatIf parameter.

.PARAMETER adminURL
    The admin URL for the SharePoint site.

.PARAMETER userUPN
    The user principal name (UPN) of the user to be removed.

.PARAMETER whatIf
    Flag to indicate whether to perform a "WhatIf" operation (default is true).

.PARAMETER adminUPN
    The admin user principal name (UPN) to be temporarily added as a site collection admin.

.PARAMETER dir
    The directory of the UPN CSV if provided. When this parameter is used, the userUPN is ignored.

.EXAMPLE
    .\deleteCoveLicenses.ps1 -adminURL https://contoso-admin.sharepoint.com/ -userUPN user@contoso.com -adminUPN admin@contoso.com -dir c:\temp\users.csv
    This command removes the user user@contoso.com from all SharePoint sites specified by the admin URL.

.EXAMPLE
    .\deleteCoveLicenses.ps1 -whatIf -adminURL https://contoso-admin.sharepoint.com/ -userUPN user@contoso.com -adminUPN admin@contoso.com -dir c:\temp\users.csv
    This command simulates the removal of the user user@contoso.com from all SharePoint sites specified by the admin URL.

.NOTES
    Author: Jason Mcdill
#>

param(
    [string]$adminURL, # The admin URL for the SharePoint site.
    [string]$userUPN, # The UPN of the user to be removed.
    [switch]$whatIf = $true, # Flag WhatIf (default to true).
    [string]$adminUPN, # The admin UPN to be added as a site collection admin.
    [string]$dir, # The directory to the UPN CSV.
    [switch]$CSV # Tell the script you have a CSV.
)

# Array to store user UPNs
[array]$userUPNs = @()

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
        Start-Sleep -Seconds 3
        return $false  # Return false to indicate failure
    }

    Clear-Host
    Write-Host "You will need to provide a CSV containing a vertical list of all UPNs you want to modify" -ForegroundColor Yellow
    Write-Host "They must have a title that reads 'UserPrincipalName' with no spaces I.E:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UserPrincipalName," -ForegroundColor Yellow
    Write-Host "user1@contoso.com," -ForegroundColor Yellow
    Write-Host "user2@contoso.com," -ForegroundColor Yellow
    Write-Host "user3@contoso.com," -ForegroundColor Yellow
    Write-Host ""
    $dir = Read-Host -Prompt "Please enter the directory to your properly formatted user UPN list"

    try {
        $users = Import-Csv -Path $dir
    }
    catch {
        Write-Host "Failed to import the CSV"
        Write-Output "Failed to import the CSV"
        Start-Sleep -Seconds 3
        return $false  # Return false to indicate failure
    }

    try {
        $userUPNs = $users | Select-Object -ExpandProperty UserPrincipalName -Unique
    }
    catch {
        Write-Host "Failed to extract the UPNs"
        Write-Output "Failed to extract the UPNs"
        Start-Sleep -Seconds 3
        return $false  # Return false to indicate failure  
    }

    Write-Host ""
    Write-Host "These are the UPNs I read from that file, please check them before continuing:" -ForegroundColor Yellow
    Write-Host ""
    $userUPNs | ForEach-Object { Write-Host $_ }
    Write-Host ""
    Write-Host "multipleUsers() returned to caller"
    return $userUPNs  # Return the UPNs to caller
}

function doSharePoint {
    param (
        [string]$adminUPN,
        [string]$adminURL,
        [array]$userUPNs
    )

    # Connect to the SharePoint Online service.
    Connect-SPOService -Url $adminURL

    # Retrieve all site URLs excluding personal sites.
    $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

    # Iterate through each user UPN.
    foreach ($upn in $userUPNs) {
        # Iterate through each site URL.
        foreach ($site in $siteUrls) {
            # Add the admin user as a site collection admin.
            Write-Host "Adding Site Collection Admin for: `n$site"
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $True

            # Try to delete the user from the site.
            try {
                $user = Get-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                Write-Host "User found in site $site"

                if (-not $whatIf) {
                    # If WhatIf is false, remove the user from the site.
                    Remove-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                    if ($?) {
                        Write-Output "Removed user from $site"
                    }
                    else {
                        Write-Output "Remove failed for $site"
                    }
                }
                else {
                    # If WhatIf is true, simulate the removal.
                    Write-Host "Would remove $($user.loginname)"
                }
            }
            catch {
                # Catch and display any errors that occur.
                Write-Host "ERROR: $_"
            }
            # Remove the admin user from the site collection admin role.
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $False
            Write-Host "Removed $adminUPN from site collection admin"
            Write-Host "_______________________________`n"
        }
    }
}

function getUserUPN { 
    $userUPN = Read-Host -Prompt "Please provide the userUPN"
    return $userUPN
}

function getAdminUPN { 
    $adminUPN = Read-Host -Prompt "Please provide the adminUPN"
    return $adminUPN
}

function getAdminURL { 
    $adminURL = Read-Host -Prompt "Please provide the adminURL"
    return $adminURL
}

if ($CSV) {

    Clear-Host
    Write-Host ""
    Write-Host "You will need to provide a CSV containing a vertical list of all UPNs you want to modify" -ForegroundColor Yellow
    Write-Host "They must have a title that reads 'UserPrincipalName' with no spaces I.E:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "UserPrincipalName," -ForegroundColor Yellow
    Write-Host "user1@contoso.com," -ForegroundColor Yellow
    Write-Host "user2@contoso.com," -ForegroundColor Yellow
    Write-Host "user3@contoso.com," -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This list is not currently validated so double check the accuracy" -ForegroundColor Yellow
    Write-Host ""

    Write-Host ""
    Write-Host "multipleUsers() called by main"
    $userUPNs = multipleUsers -dir $dir

    if ([string]::IsNullOrEmpty($adminUPN)) {
        Write-Host "main called getAdminUPN()"
        $adminUPN = getAdminUPN
    }
    if ([string]::IsNullOrEmpty($adminURL)) {
        Write-Host "main called getAdminURL()"
        $adminURL = getAdminURL
    }

    Write-Host "main called doSharePoint"
    doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs

}
else {
    # Ensure all required parameters are now present
    if ($null -eq $userUPN) {
        Write-Host "main called getUserUPN()"
        $userUPN = getUserUPN
    }
    
    if ($null -eq $adminUPN) {
        Write-Host "main called getAdminUPN()"
        $adminUPN = getAdminUPN
    }
    
    if ($null -eq $adminURL) {
        Write-Host "main called getAdminURL()"
        $adminURL = getAdminURL
    }
    
    $userUPNs = @($userUPN)
    
    Write-Host "main called doSharePoint"
    doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs
}
