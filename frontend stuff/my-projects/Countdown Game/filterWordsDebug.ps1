param (
    [string]$filePath = ".\words.txt",
    [string]$outputPath = ".\words-filtered.txt",
    [string]$debugFilePath = ".\debug-log.txt"  # Added this parameter
)

[int32]$count = 0
Clear-Host

[array]$words = Get-Content $filePath
$filteredWords = [System.Collections.ArrayList]::new()

[int32]$totalWords = $words.Count

try {
    foreach ($word in $words) {
        $isFiltered = $false

        if ($word -match '\d') {
            Write-Output "Filtered out (contains digits): $word" >> $debugFilePath
            $isFiltered = $true
        }
        if ($word.Length -le 3) {
            Write-Output "Filtered out (length <= 3): $word" >> $debugFilePath
            $isFiltered = $true
        }
        if ($word -like '*-*') {
            Write-Output "Filtered out (contains hyphen): $word" >> $debugFilePath
            $isFiltered = $true
        }
        if ($word -like '*.*') {
            Write-Output "Filtered out (contains period): $word" >> $debugFilePath
            $isFiltered = $true
        }
        if ($word -match '^[A-Z]') {
            Write-Output "Filtered out (contains uppercase letters): $word" >> $debugFilePath
            $isFiltered = $true
        }

        if (-not $isFiltered) {
            [void]$filteredWords.Add($word)
        }

        $count++
        [decimal]$percent = [math]::Round(($count / $totalWords) * 100, 2)
        Write-Host "Processing words: $percent%" -NoNewline -ForegroundColor Green
        Write-Host "`r" -NoNewline
    }

    $filteredWords | Set-Content $outputPath
    Write-Host ""
    Write-Host "The output contains $($filteredWords.Count) words"

}
catch {
    Write-Host "Word filter failed:"
    Write-Host ""
    Write-Error $_
}

# Jason Mcdill
