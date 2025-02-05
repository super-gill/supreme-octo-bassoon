param(
    [string]$UserUPN,
    [string]$dir,
    [bool]$whatIf = $true,
    [switch]$teams,
    [switch]$sharepoint,
    [switch]$test
)

[array]$testSharePointSites = @("https://test.sharepoint.com/sites/TestSite1", "https://test.sharepoint.com/sites/TestSite2")
[array]$testTeamsTeams = @("Test Team 1", "Test Team 2")
[string]$version = 9

if ($test) {
    Clear-Host
    Write-Host "    Test Mode Enabled    " -ForegroundColor white -BackgroundColor green
}

if (-not $UserUPN -and -not $dir) {
    Clear-Host
    Write-Host "No flags have been passed" -ForegroundColor Yellow
    Write-Host "Use \"Get-Help '.\CoveRemoveUserV$version.ps1' -Full\" for help." -ForegroundColor Yellow
    exit
}

function validateEmail {
    param ([string]$emailAddress)
    return $emailAddress -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
}

function multipleUsers {
    param ([string]$dir)
    try {
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
    param ([string]$UserUPN, [array]$userUPNs)
    
    $teams = if ($test) { $testTeamsTeams } else { Get-Team }
    
    foreach ($team in $teams) {
        foreach ($user in $userUPNs) {
            Write-Host "Checking [$team] for [$user]"
            try {
                if ($whatIf) {
                    Write-Host ">> Would remove [$user] from [$team]" -ForegroundColor Yellow
                } else {
                    Remove-TeamUser -GroupId $team.GroupId -User $user
                    Write-Host "[$user] removed from [$team]" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "[$user] - ERROR on [$team]: $_" -ForegroundColor Red
            }
        }
    }
}

function doSharePoint {
    param ([string]$adminUPN, [string]$adminURL, [array]$userUPNs)
    
    Write-Host "Checking SharePoint Sites..."
    $siteUrls = if ($test) { $testSharePointSites } else { Get-SPOSite | Where-Object { $_.url -notlike "*-my.sharepoint.com*" } | Select-Object -ExpandProperty Url }
    
    foreach ($site in $siteUrls) {
        foreach ($upn in $userUPNs) {
            try {
                if ($whatIf) {
                    Write-Host "[$upn] - Would be removed from [$site]" -ForegroundColor Yellow
                } else {
                    Remove-SPOUser -Site $site -LoginName $upn
                    Write-Host "[$upn] - Removed from [$site]" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "[$upn] - ERROR on [$site]: $_" -ForegroundColor Red
            }
        }
    }
}

$adminUPN = (Connect-MicrosoftTeams).Account.Id
Connect-ExchangeOnline
try {
    $sharepointSites = Get-UnifiedGroup -Filter { ResourceProvisioningOptions -eq "Team" } | Select-Object -ExpandProperty SharePointSiteUrl
    $adminURL = ($sharepointSites -ne $null).split(".")[0] + "-admin.sharepoint.com/"
    Connect-SPOService -Url $adminURL
}
catch {
    Write-Host "Failed to retrieve SharePoint admin portal URL." -ForegroundColor Red
    $adminURL = Read-Host -Prompt "SharePoint Admin URL"
    Connect-SPOService -Url $adminURL
}

if ($dir) {
    $userUPNs = multipleUsers -dir $dir
    if ($sharepoint) { doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs $userUPNs }
    if ($teams) { doTeams -UserUPN $UserUPN -userUPNs $userUPNs }
} else {
    if ($sharepoint) { doSharePoint -adminUPN $adminUPN -adminURL $adminURL -userUPNs @($UserUPN) }
    if ($teams) { doTeams -UserUPN $UserUPN -userUPNs @($UserUPN) }
}
