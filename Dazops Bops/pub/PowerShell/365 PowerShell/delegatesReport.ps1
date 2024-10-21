# Report delegate permissions per UPN

$upnArray = @()
$mailboxes = Get-Mailbox -ResultSize Unlimited
foreach ($mailbox in $mailboxes) {
    $upnArray += $mailbox.UserPrincipalName
}


foreach ($upn in $upnArray) {
    Write-Host "UPN: $upn"
    $delegatePermissions = Get-MailboxPermission -Identity $upn |
        Where-Object { $_.IsInherited -eq $false }
    $delegatePermissions | Format-Table -AutoSize
    Write-Host
    $formattedOutput = ($delegatePermissions | Format-Table -AutoSize | Out-String).TrimEnd()
    $outputFilePath = "C:\DelegatePermissions.txt"
    Add-Content -Path $outputFilePath -Value "UPN: $upn`r`n"
    Add-Content -Path $outputFilePath -Value $formattedOutput
    Add-Content -Path $outputFilePath -Value "`r`n"
}

Write-Host "Output saved to: $outputFilePath"
