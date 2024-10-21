$permissionsList = @()

$mailboxes = Get-Mailbox -ResultSize Unlimited
$everyUser = $mailboxes | Select-Object -ExpandProperty UserPrincipalName

foreach ($targetUser in $everyUser) {
    foreach ($mailbox in $mailboxes) {
        $permissions = Get-MailboxPermission -Identity $mailbox.UserPrincipalName | Where-Object { $_.User -eq $targetUser }

        foreach ($permission in $permissions) {
            $permissionsList += [PSCustomObject]@{
                Mailbox      = $mailbox.UserPrincipalName
                User         = $permission.User
                AccessRights = $permission.AccessRights
                Deny         = $permission.Deny
            }
        }
    }
}

$permissionsList | Format-Table -AutoSize

# Disconnect-ExchangeOnline -Confirm:$false
