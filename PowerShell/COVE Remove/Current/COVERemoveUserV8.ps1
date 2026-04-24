# --- SCRIPT-LEVEL PARAMS (accept flags when you run .\script.ps1 ...) ---
[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param(
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('UPN','UserPrincipalName')]
    [string[]] $UserUPN,

    [ValidateScript({ -not $_ -or (Test-Path $_) })]
    [string] $Path,

    [switch] $Teams,
    [switch] $SharePoint,
    [string] $AdminUrl,
    [string] $AdminUPN
)

function Remove-M365UserAccess {
<#
.SYNOPSIS
  Remove one or more users from all Microsoft Teams and SharePoint sites.
#>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('UPN','UserPrincipalName')]
        [string[]] $UserUPN,

        [ValidateScript({ -not $_ -or (Test-Path $_) })]
        [string] $Path,

        [switch] $Teams,
        [switch] $SharePoint,
        [string] $AdminUrl,
        [string] $AdminUPN
    )

    begin {
        $emailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        $targets = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

        function Add-Target([string]$u) {
            if ([string]::IsNullOrWhiteSpace($u)) { return }
            if ($u -match $emailPattern) { [void]$targets.Add($u.Trim()) }
            else { Write-Warning "Skipping invalid UPN: $u" }
        }

        if ($Path) {
            try {
                $csv = Import-Csv -Path $Path
                foreach ($r in $csv) { Add-Target $r.UserPrincipalName }
            } catch {
                throw "Failed to read CSV '$Path'. Ensure header 'UserPrincipalName'. $_"
            }
        }

        $sum = [ordered]@{
            TeamsRemoved      = @()
            TeamsNotFound     = @()
            SharePointRemoved = @()
            SharePointErrors  = @()
        }

        if (-not $Teams -and -not $SharePoint) {
            Write-Verbose "No scope switches provided; defaulting to Teams + SharePoint."
            $Teams = $true; $SharePoint = $true
        }

        $connectedTeams = $false
        $connectedSPO   = $false
        $adminUpnInUse  = $null
    }
    process {
        foreach ($u in $UserUPN) { Add-Target $u }
    }
    end {
        if ($targets.Count -eq 0) { Write-Information "No valid UPNs to process." -InformationAction Continue; return }

        Write-Verbose ("Targets: " + ($targets -join ', '))

        # --- TEAMS ---
        if ($Teams) {
            try {
                if (-not (Get-Module MicrosoftTeams -ListAvailable)) {
                    throw "MicrosoftTeams module not found. Install-Module MicrosoftTeams"
                }
                if (-not $connectedTeams) { Connect-MicrosoftTeams | Out-Null; $connectedTeams = $true }

                $allTeams = Get-Team
                Write-Verbose ("Found {0} team(s)" -f $allTeams.Count)

                foreach ($t in $allTeams) {
                    $teamUsers = Get-TeamUser -GroupId $t.GroupId | Select-Object -ExpandProperty User
                    if (-not $teamUsers) { continue }

                    $foundAny = $false
                    foreach ($u in $targets) {
                        if ($teamUsers -contains $u) {
                            $foundAny = $true
                            if ($PSCmdlet.ShouldProcess("$u in Team '$($t.DisplayName)'","Remove-TeamUser")) {
                                try {
                                    Remove-TeamUser -GroupId $t.GroupId -User $u -ErrorAction Stop
                                    $sum.TeamsRemoved += "$u :: $($t.DisplayName)"
                                    Write-Verbose "Removed $u from '$($t.DisplayName)'"
                                } catch {
                                    Write-Warning "Failed to remove $u from '$($t.DisplayName)': $_"
                                }
                            }
                        }
                    }

                    if (-not $foundAny) {
                        foreach ($u in $targets) {
                            if ($teamUsers -notcontains $u) {
                                $sum.TeamsNotFound += "$u :: $($t.DisplayName)"
                            }
                        }
                    }
                }
            } catch {
                Write-Warning "Teams phase error: $_"
            }
        }

        # --- SHAREPOINT ---
        if ($SharePoint) {
            try {
                if (-not (Get-Module Microsoft.Online.SharePoint.PowerShell -ListAvailable)) {
                    throw "SharePoint Online Management Shell module not found. Install-Module Microsoft.Online.SharePoint.PowerShell"
                }

                if (-not $AdminUrl) {
                    try {
                        if (-not (Get-ConnectionInformation -ErrorAction SilentlyContinue | Where-Object Service -eq "ExchangeOnline")) {
                            Connect-ExchangeOnline -ShowBanner:$false | Out-Null
                        }
                        $spUrl = (Get-UnifiedGroup -ResultSize 1 | Where-Object { $_.SharePointSiteUrl }) |
                                 Select-Object -ExpandProperty SharePointSiteUrl -First 1
                        if ($spUrl) {
                            $tenant = ([Uri]$spUrl).Host.Split('.')[0]
                            $AdminUrl = "https://$tenant-admin.sharepoint.com"
                            Write-Verbose "Derived AdminUrl: $AdminUrl"
                        }
                    } catch {
                        Write-Verbose "Admin URL discovery via EXO failed/skip: $_"
                    }

                    if (-not $AdminUrl) {
                        throw "Could not determine SharePoint Admin URL. Pass -AdminUrl https://<tenant>-admin.sharepoint.com"
                    }
                }

                if (-not $connectedSPO) { Connect-SPOService -Url $AdminUrl; $connectedSPO = $true }

                if (-not $AdminUPN) {
                    try {
                        $adminUsers = Get-SPOUser -Site $AdminUrl -Limit All -ErrorAction Stop | Where-Object { $_.IsSiteAdmin }
                        $AdminUPN = $adminUsers | Select-Object -First 1 -ExpandProperty LoginName
                    } catch {
                        Write-Verbose "Could not enumerate admins on $($AdminUrl): $($_)"
                    }
                }
                if ($AdminUPN) {
                    $adminUpnInUse = $AdminUPN
                    Write-Verbose "Using AdminUPN for temp site admin: $adminUpnInUse"
                } else {
                    Write-Verbose "Proceeding without temporary site admin elevation (ensure your current identity has rights)."
                }

                $sites = Get-SPOSite -Limit All | Where-Object Url -NotLike "*-my.sharepoint.com*"
                Write-Verbose ("Found {0} SharePoint site(s)" -f $sites.Count)

                foreach ($s in $sites) {

                    # grant temp SCA if we have an admin to elevate
                    if ($adminUpnInUse) {
                        try {
                            Set-SPOUser -Site $s.Url -LoginName $adminUpnInUse -IsSiteCollectionAdmin $true -ErrorAction Stop | Out-Null
                        } catch {
                            Write-Warning "Could not grant site admin: $($adminUpnInUse) on $($s.Url): $_"
                        }
                    }

                    foreach ($u in $targets) {
                        if ($PSCmdlet.ShouldProcess("$u on Site '$($s.Url)'","Remove-SPOUser")) {
                            try {
                                Remove-SPOUser -Site $s.Url -LoginName $u -ErrorAction Stop
                                $sum.SharePointRemoved += "$u :: $($s.Url)"
                                Write-Verbose "Removed $u from $($s.Url)"
                            } catch {
                                $sum.SharePointErrors += "$u :: $($s.Url) :: $($_.Exception.Message)"
                            }
                        }
                    }

                    if ($adminUpnInUse) {
                        try {
                            Set-SPOUser -Site $s.Url -LoginName $adminUpnInUse -IsSiteCollectionAdmin $false -ErrorAction SilentlyContinue | Out-Null
                        } catch { }
                    }
                }
            } catch {
                Write-Warning "SharePoint phase error: $_"
            }
        }

        Write-Information "== Removal summary ==" -InformationAction Continue
        if ($Teams) {
            Write-Information ("Teams removed: {0}" -f $sum.TeamsRemoved.Count) -InformationAction Continue
            Write-Information ("Teams not found (user not in team): {0}" -f $sum.TeamsNotFound.Count) -InformationAction Continue
        }
        if ($SharePoint) {
            Write-Information ("SharePoint removed: {0}" -f $sum.SharePointRemoved.Count) -InformationAction Continue
            if ($sum.SharePointErrors.Count) {
                Write-Warning ("SharePoint errors: {0}" -f $sum.SharePointErrors.Count)
            }
        }

        [pscustomobject]@{
            Targets              = [string]($targets -join ', ')
            TeamsRemoved         = $sum.TeamsRemoved
            TeamsNotFound        = $sum.TeamsNotFound
            SharePointRemoved    = $sum.SharePointRemoved
            SharePointErrors     = $sum.SharePointErrors
            AdminUrlUsed         = $AdminUrl
            AdminUPNUsed         = $adminUpnInUse
        }
    }
}

# --- FORWARD ALL SCRIPT PARAMS INTO THE FUNCTION ---
Remove-M365UserAccess @PSBoundParameters
