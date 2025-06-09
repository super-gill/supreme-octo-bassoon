param (
    [string]$Path
)

if (-not $Path) {
    $Path = Read-Host -Prompt "Provide a path to the csv"
}

$samplesPerAgent = 3

$tickets = Import-Csv -Path $Path

$dateOpenedRaw = $tickets | Where-Object { $_.'Date Opened' } | Select-Object -First 1 -ExpandProperty 'Date Opened'
try {
    $parsedDate = [datetime]::Parse($dateOpenedRaw)
    $outputFileName = "$($parsedDate.ToString('yyyy-MM-dd')).csv"
}
catch {
    Write-Error "Could not parse 'Date Opened' from the CSV."
    exit 1
}

$sampledTickets = foreach ($group in $tickets | Group-Object Agent) {
    $count = [Math]::Min($samplesPerAgent, $group.Count)
    $group.Group | Get-Random -Count $count
}

$sampledTickets | Select-Object Agent, 'Ticket ID' | Export-Csv -Path $outputFileName -NoTypeInformation

Write-Host "Sample saved to $outputFileName"
