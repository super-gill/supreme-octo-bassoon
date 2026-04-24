Import-Module Microsoft.Graph.Users

# Connect to Microsoft 365
Connect-MgGraph -Scopes "User.Read.All"

# Get all users
$allUsers = Get-MgUser -All

# Filter licensed users locally
$licensedUsers = $allUsers | Where-Object { $_.AssignedLicenses.Count -gt 0 }

Write-Host "Number of licensed users: $($licensedUsers.Count)"

if ($licensedUsers.Count -eq 0) {
    Write-Host "No licensed users found."
} else {
    # Create an array to store user details
    $userDetails = @()

    foreach ($user in $licensedUsers) {
        # Get user's creation date
        $createdDate = $user.CreatedDateTime

        # Add user details to the array
        $userDetails += [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            CreationDate = $createdDate
        }
    }

    # Print the details to the console
    $userDetails | Format-Table -AutoSize
}
