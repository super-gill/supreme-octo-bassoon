Connect-ExchangeOnline

function Get-CalendarPermissions {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UPN
    )

    $mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
    Write-Host $($mailboxes)

    foreach ($mailbox in $mailboxes) {
        $CalendarFolderId = "$($mailbox.PrimarySmtpAddress):\Calendar"
        Write-Host $($CalendarFolderId)

        try {
            $permissions = Get-MailboxFolderPermission -Identity $CalendarFolderId -ErrorAction Stop

            foreach ($permission in $permissions) {
                if ($permission.User -eq $UPN) {
                    Write-Host "Permission found in mailbox: $($mailbox.PrimarySmtpAddress)" -ForegroundColor Green
                    Write-Host "Permission details: AccessRights=$($permission.AccessRights), SharingRole=$($permission.SharingPermissionFlags)"
                }
            }
        }
        catch {
            Write-Host "Failed to retrieve permissions for mailbox: $($mailbox.PrimarySmtpAddress). Error: $_" -ForegroundColor Red
        }
    }
}

$TargetUPN = Read-Host -Prompt "Enter the email address you want to search for"

Get-CalendarPermissions -UPN $TargetUPN