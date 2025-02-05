$printers = Get-PrinterDriver
$installer


$exclude = @("Microsoft","PDF","XPS","One","3H Plotter")

foreach ($printer in $printers) {
    if ($exclude -notcontains $driver.name) {
        try {
            Remove-PrinterDriver -name $printer.name -ErrorAction Stop
        } catch {
            Write-Host _$.ERROR
        }
    }
}

try {
    Add-PrinterDriver -name "HP E87750Z"
}