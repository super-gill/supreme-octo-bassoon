# Module that disables sleep

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

function Disable-SleepStates {
    $output = powercfg /a
    $sleepStates = @("S1", "S2", "S3", "Hybrid Sleep")
    $disableCommands = @{}

    foreach ($state in $sleepStates) {
        if ($output -match "Standby \($state\)" -or $output -match "$state") {
            Write-Output "$state is available and will be disabled."
            if ($whatIf) { Write-Host "would run disableCommands[$state] = "Disable"" } else { $disableCommands[$state] = "Disable" }
        }
        else {
            Write-Output "$state is not available or already disabled."
        }
    }
}

if ($disableCommands.Count -gt 0) {
    Write-Output "Disabling sleep states..."
    Write-Host "would run powercfg /change standby-timeout-ac 0"
    Write-Host "powercfg /change standby-timeout-dc 0"
    Write-Host "powercfg /change monitor-timeout-ac 0"
    Write-Host "powercfg /change monitor-timeout-dc 0"
    Write-Output "Sleep states have been disabled."
}
else {
    Write-Output "No sleep states to disable."
}
