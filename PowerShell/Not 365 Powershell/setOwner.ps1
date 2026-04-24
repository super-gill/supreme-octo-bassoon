[string]$path = c":\shared\work"
[string]$username = "administrator"
[switch]$whatIf

function changePerm {
    param (
        [string]$path,
        [string]$username
    )

    $acl = get-acl -path $path
    $acl.setowner([System.Security.Principal.NTAccount]$username)

    set-acl -path $path -aclobject $acl

}

$items = Get-ChildItem -path $path -recurse -force

foreach ($item in $items) {

    try {
        if (whatIf) {
            Write-Output "Changed $($item.fullname)"
        }
        else {

            set-owner -path $item.fullname
            Write-Output "Changed $($item.fullname)"
        }
    }
    catch {
        Write-Output "Failed $($item.fullname)"
    }

}

changePerm -path $path -ausername $username