[bool]$testConnect = $null
$ip = 0
$result = @()

while ($ip -le 10) {
    $currentIP = "192.168.$ip.1"
    try {
        if (Test-Connection -ComputerName $currentIP -Count 1 -Quiet -TimeoutSeconds 1) {
            $testConnect = $true
            Write-Host "Connected on: $currentIP" -ForegroundColor Green
            $result += $currentIP
        } else {
            $testConnect = $false
            Write-Host "No connection on: $currentIP" -ForegroundColor Yellow
        }
    }
    catch {
        $testConnect = $false
        Write-Host "No connection on: $currentIP" -ForegroundColor Yellow
    }
    
    $ip++
}

return $result
