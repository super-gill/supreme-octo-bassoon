<#
.SYNOPSIS
    Retrieves the password expiry date for Active Directory users.

.DESCRIPTION
    This script retrieves the password expiry date for all enabled Active Directory users whose passwords do not have the "Password Never Expires" setting.
    The script needs to be run on an Active Directory server.

.PARAMETER ExportCsv
    Switch parameter to specify whether to export the results to a CSV file.

.PARAMETER CsvPath
    The path where the CSV file should be saved if ExportCsv is specified.

.EXAMPLE
    .\Get-ADUserPasswordExpiry.ps1
    This command retrieves the password expiry date for all relevant Active Directory users and displays it in the console.

.EXAMPLE
    .\Get-ADUserPasswordExpiry.ps1 -ExportCsv -CsvPath "c:\temp\passwordexpiration.csv"
    This command retrieves the password expiry date for all relevant Active Directory users and exports the results to a CSV file.
    
.NOTES
    Author: [Your Name]
    Version: 1.0
#>

param (
    [switch]$ExportCsv,
    [string]$CsvPath = "c:\temp\passwordexpiration.csv"
)

# Retrieve all enabled AD users whose passwords are set to expire
$users = Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
    Select-Object -Property "DisplayName", @{
        Name = "ExpiryDate"
        Expression = {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}
    }

# Display the results in the console
$users | Format-Table -AutoSize

# Export the results to a CSV file if the ExportCsv switch is specified
if ($ExportCsv) {
    $users | Export-Csv -Path $CsvPath -NoTypeInformation
    Write-Host "Results exported to $CsvPath"
}
