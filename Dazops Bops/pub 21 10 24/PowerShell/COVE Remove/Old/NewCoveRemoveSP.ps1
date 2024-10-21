<#
.SYNOPSIS
    Remove special permissions in SharePoint and associated share links.

.PARAMETER adminURL
    The admin URL for the SharePoint site.

.PARAMETER userUPN
    The user principal name (UPN) to be removed.

.PARAMETER whatIf
    Simulate the operation.

.PARAMETER adminUPN
    The admin user principal name (UPN) to be temporarily added as a site collection admin.

.PARAMETER dir
    The directory of the UPN CSV.

.PARAMETER CSV
    Flag to process users from a CSV file.

.EXAMPLE
    .\deleteCoveLicenses.ps1 -adminURL https://contoso-admin.sharepoint.com/ -userUPN user@contoso.com -adminUPN admin@contoso.com

.EXAMPLE
    .\deleteCoveLicenses.ps1 -adminURL https://contoso-admin.sharepoint.com/ -adminUPN admin@contoso.com -dir c:\temp\users.csv -CSV

.EXAMPLE
    .\deleteCoveLicenses.ps1 -whatIf -adminURL https://contoso-admin.sharepoint.com/ -adminUPN admin@contoso.com -dir c:\temp\users.csv -CSV
#>

param(
    [string]$adminURL,
    [string]$userUPN,
    [switch]$whatIf,
    [string]$adminUPN,
    [string]$dir,
    [switch]$CSV
)

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

function doSharePoint {
    param ([string]$adminUPN, [string]$adminURL, $userUPNs)

    Connect-SPOService -Url $adminURL
    $siteUrls = (Get-SPOSite | Where-Object url -notlike "*-my.sharepoint.com*").url

    foreach ($upn in $userUPNs) {
        foreach ($site in $siteUrls) {
            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $True

            try {
                $user = Get-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                if (-not $whatIf) {
                    Remove-SPOUser -Site $site -LoginName $upn -ErrorAction Stop
                }
                Write-Host "[$upn] checked on [$site]"
            }
            catch {
                Write-Host "[$upn] - ERROR on [$site]: $_"
            }

            Set-SPOUser -Site $site -LoginName $adminUPN -IsSiteCollectionAdmin $False
        }
    }
}

if ($CSV) {
    $userUPNs = multipleUsers -dir $dir
    doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs
}
else {
    $userUPNs = @($userUPN)
    doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs
}
