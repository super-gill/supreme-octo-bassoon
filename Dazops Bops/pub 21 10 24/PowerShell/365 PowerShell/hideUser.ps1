$users = @(
    "user@mail.com",
    "user2@mail.com",
    "user3@mail.com"
)

foreach ($user in $users) {
    try {
        Set-Mailbox -Identity $user -HiddenFromAddressListsEnabled $true
    } catch {
        Write-Host "failed on $($user)"
    }
}