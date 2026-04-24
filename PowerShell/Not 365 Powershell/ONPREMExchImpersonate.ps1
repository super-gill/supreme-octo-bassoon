<#
.SYNOPSIS
    Sets Exchange admin impersonation privileges for a specified user.

.DESCRIPTION
    This script assigns the necessary impersonation privileges to an Exchange admin user.
    It includes creating a management role assignment and adding Active Directory permissions for Exchange impersonation.

    Exchange 2010 or later only.

.PARAMETER user
    The user to whom the impersonation privileges will be assigned.

.EXAMPLE
    .\Set-ExchangeAdminImpersonation.ps1 -user "domain\user"
    This command sets the Exchange admin impersonation privileges for the specified user.
    Use only the provided format for the username.

.NOTES
    Author: Jason Mcdill
#>

param (
    [string]$user
)

# Attempt to create and assign the impersonation role to the specified user.
try {
    New-ManagementRoleAssignment -Name "MigrationimpersonationAssignment" -Role "applicationimpersonation" -User $user
}
catch {
    Write-Host "Failed to create and assign the impersonation role to $($user)"
}

# Attempt to add Active Directory permissions for Exchange impersonation.
try {
    Get-ExchangeServer | Add-ADPermission -User $user -ExtendedRights ms-Exch-EPI-Impersonation -InheritanceType None
}
catch {
    Write-Host "Failed to add impersonation permissions on Exchange Server for $($user)"
}

# Attempt to add Active Directory permissions for mailbox database impersonation.
try {
    Get-MailboxDatabase | Add-ADPermission -User $user -ExtendedRights ms-Exch-EPI-May-Impersonate -InheritanceType None
}
catch {
    Write-Host "Failed to add impersonation permissions on Mailbox Database for $($user)"
}
