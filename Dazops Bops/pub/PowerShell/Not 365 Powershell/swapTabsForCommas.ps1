$filePath = "C:\temp\tabs.txt"


try { $content = Get-Content -Path $filePath
    Write-Host $($content)
} catch {
    Write-Host "failed to get-content"
} 

try { $modifiedContent = $content -replace "`t", ","
} catch {
    Write-Host "failed to swap tabs"
}

Set-Content -Path $filePath -Value $modifiedContent

Write-Host "File has been written successfully with tabs replaced by commas."
