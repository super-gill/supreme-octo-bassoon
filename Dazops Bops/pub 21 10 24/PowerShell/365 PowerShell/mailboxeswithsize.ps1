$mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox | Select-Object DisplayName, ProhibitSendQuota
$mailboxSizes = Get-MailboxStatistics -ResultSize Unlimited | Select-Object DisplayName, TotalItemSize

$results = @()
foreach ($mailbox in $mailboxes) {
    $size = $mailboxSizes | Where-Object { $_.DisplayName -eq $mailbox.DisplayName }
    if ($size) {
        $results += [PSCustomObject]@{
            DisplayName = $mailbox.DisplayName
            CurrentSize = $size.TotalItemSize.ToString()
            MaxSize = $mailbox.ProhibitSendQuota
        }
    }
}

$results | Format-Table -AutoSize