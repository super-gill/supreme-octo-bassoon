# Module that disables hibernate

param (
    [bool]$whatIf = $true
)

<#

.SYNOPSIS

.DESCRIPTION

.PARAMETER Name

.PARAMETER Extension

.INPUTS

.OUTPUTS

.EXAMPLE

.LINK

#>

function disableHibernation {
    $output = powercfg /a
    if ($output -match "Hibernation has not been enabled") {
        Write-Output "Hibernation is already disabled."
    }
    elseif ($output -match "The following sleep states are available on this system:" -and $output -match "Hibernate") {
        Write-Output "Disabling hibernation..."
        if ($whatIf) { Write-Host "would run powercfg /h off" } else { powercfg /h off }
        Write-Output "Hibernation has been disabled."
    }
    else {
        Write-Output "Unable to determine hibernation status."
    }
}

disableHibernation