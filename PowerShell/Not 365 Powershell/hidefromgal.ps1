$names = Import-Csv C:\temp\names.csv
# CSV should just be a list of usernames like:
# john.smith
# sam.bants
# derrik.derrikson


foreach ($row in $names) {
    $firstProp = $row.PSObject.Properties | Select-Object -First 1 -ExpandProperty Name
    $id = $row.$firstProp

    try {
        Set-ADUser -Identity $id -Replace @{msExchHideFromAddressLists = $true} -ErrorAction Stop
        Write-Host "$id done!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed $id - $($_.Exception.Message)" -ForegroundColor Red
    }
}