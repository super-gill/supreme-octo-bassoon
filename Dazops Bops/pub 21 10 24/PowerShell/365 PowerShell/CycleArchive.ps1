param (
    [switch]$whatif
)

Write-Host "whatIf: $($whatif)"
Write-Host ""

$usersWithArchiveActiveBefore = Get-Mailbox -Filter { ArchiveStatus -eq 'Active' } | Select-Object UserPrincipalName
$userswithArhciveDisabledBefore = Get-Mailbox -filter { ArchiveStatus -eq 'none'} | Select-Object UserPrincipalName

# cycle users with active archives
foreach ($user in $usersWithArchiveActiveBefore) {
    $userPrincipalName = $user.UserPrincipalName

    # Disable archiving
    if ($whatIf) { 
        Write-Host "Would disable: $($userPrincipalName)"
    }
    else {
        Disable-Mailbox -Archive -Identity $userPrincipalName
        Write-Host "Disabled archive for user: $userPrincipalName"
        Start-Sleep -Seconds 5 #some of the archives dont disable if its less than 5
    }
    
    # Enable archiving
    if ($whatIf) {
        Write-Host "Would disable: $($userPrincipalName)"
    }
    else {
        Enable-Mailbox -Archive -Identity $userPrincipalName
        Write-Host "Enabled archive for user: $userPrincipalName"
        Start-Sleep -Seconds 5 #as above but re-enabling
    }
}

$usersWithArchiveAfter = Get-Mailbox -Filter { ArchiveStatus -eq 'Active' } | Select-Object UserPrincipalName
$missingArchives = Compare-Object -ReferenceObject $usersWithArchiveBefore.UserPrincipalName -DifferenceObject $usersWithArchiveAfter.UserPrincipalName

if ($missingArchives) {
    Write-Host "Following mailboxes did nothave their archieves re-enabled:"
    $missingArchives | ForEach-Object {
        Write-Host $_.InputObject
    }
}
else {
    Write-Host "All mailboxes have been cycled" -ForegroundColor Green
}