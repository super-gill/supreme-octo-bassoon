<#
Return a report of all legacy MFA configurations
#>

<#

Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication  Basic -AllowRedirection
Import-PSSession $Session
Get-Mailbox

#>

Connect-MsolService

Write-Host "Finding Azure Active Directory Accounts..."
# Connect-ExchangeOnline
Connect-MsolService
$Users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true} | Where-Object { $_.UserType -ne "Guest" } #where-object {$_.isLicensed -eq $true} | 
$Report = [System.Collections.Generic.List[Object]]::new()
Write-Host "Processing" $Users.Count "accounts..." 
ForEach ($User in $Users) {
    $MFAEnforced = $User.StrongAuthenticationRequirements.State
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True" }).MethodType
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) {
        Switch ($DefaultMFAMethod) {
            "OneWaySMS" { $MethodUsed = "One-way SMS" }
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" }
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" }
        }
    }
    Else {
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used" 
    }
  
    $ReportLine = [PSCustomObject] @{
        User        = $User.UserPrincipalName
        Name        = $User.DisplayName
        MFAUsed     = $MFAEnforced
        MFAMethod   = $MethodUsed 
        PhoneNumber = $MFAPhone
    }
                 
    $Report.Add($ReportLine) 
}

Write-Host "Report is in c:\temp\MFAUsers.CSV"
$Report | Select-Object User, Name, MFAUsed, MFAMethod, PhoneNumber | Sort-Object Name | Out-GridView
$Report | Sort-Object Name | Export-CSV -NoTypeInformation -Encoding UTF8 "c:\temp\MFAUsers.csv"