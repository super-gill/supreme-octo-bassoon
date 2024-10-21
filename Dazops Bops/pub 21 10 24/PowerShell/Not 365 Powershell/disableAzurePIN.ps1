# Remove and disable Azure PIN login when not using intune

$path = "HKLM:\SOFTWARE\Policies\Microsoft"
$key = "PassportForWork"
$name = "Enabled"
$value = "0"
 
# Delete existing pins
$passportFolder = "C:\Windows\ServiceProfiles\LocalService\AppData\Local\Microsoft\Ngc"
if(Test-Path -Path $passportFolder)
{
Takeown /f $passportFolder /r /d "Y"
ICACLS $passportFolder /reset /T /C /L /Q
 
Remove-Item –path $passportFolder –recurse -force

New-Item -Path $path -Name $key –Force
New-ItemProperty -Path $path\$key -Name $name -Value $value -PropertyType DWORD -Force
}