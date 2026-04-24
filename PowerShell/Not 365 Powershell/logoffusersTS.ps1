$sessions = quser | ForEach-Object {
    if ($_ -match '(\S+)\s+(\d+)\s+(\S+)\s+(\d+:\d+)\s+(.*)') {
        [[PSCustomObject]@ {
            UserName = $matches[1]
            SessionID = $matches[2]
            State = $matches[3]
            IdleTime = $matches[4]
            LogonTime = $matches[5]
        }]
    }
}

foreach ($session in $sessions) {
    if ($session.State -eq 'Disc' -or ($session.IdleTime -match '(\d+)') -and [int]$matches[1] -gt 60) {
        Write-Host "Logging off $($session.UserName) with Session ID: $($session.SessionID)"
        logoff $session.SessionID
    }
}