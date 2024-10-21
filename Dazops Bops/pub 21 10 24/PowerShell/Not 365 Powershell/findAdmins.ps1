# Discover accounts with administrator roles in on prem AD

# Load the Active Directory module if not already loaded
Import-Module ActiveDirectory

# Define the admin groups you want to check
$adminGroups = @(
    "Domain Admins",
    "Enterprise Admins",
    "Administrators"
)

# Create an empty array to store the results
$adminUsers = @()

# Iterate through each admin group and get its members
foreach ($group in $adminGroups) {
    try {
        $members = Get-ADGroupMember -Identity $group -Recursive
        foreach ($member in $members) {
            if ($member.objectClass -eq "user") {
                $user = Get-ADUser -Identity $member -Properties DisplayName, SamAccountName
                $userDetails = [PSCustomObject]@{
                    DisplayName   = $user.DisplayName
                    SamAccountName = $user.SamAccountName
                    Role           = $group
                }
                $adminUsers += $userDetails
            }
        }
    }
    catch {
        Write-Host "Error retrieving members of group: $group"
    }
}

# Display the results
$adminUsers | Select-Object DisplayName, SamAccountName, Role | Sort-Object DisplayName | Format-Table -AutoSize

# Export the results to a CSV file if needed
$adminUsers | Select-Object DisplayName, SamAccountName, Role | Sort-Object DisplayName | Export-Csv -Path "AdminUsers.csv" -NoTypeInformation
