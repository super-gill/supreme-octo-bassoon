param (
    [string]$filePath = ".\words.txt",
    [string]$outputPath = ".\words-filtered.txt"
)

[int32]$count = 0
Clear-Host

[array]$words = Get-Content $filePath
[array]$filteredWords = @()

[int32]$totalWords = $words.Count

try {

    foreach ($word in $words) {
        if ($word -notmatch '\d' -and $word.Length -gt 3 -and $word -notlike '*-*' -and $word -notlike '*.' -and $word.Substring(1) -notmatch '[A-Z]') {
            [void]$filteredWords.Add($word)
        }
        $count++
        [decimal]$percent = [math]::Round(($count / $totalWords) * 100, 2)
        Write-Host "Processing words: $percent%" -NoNewline -ForegroundColor Green
        Write-Host "`r" -NoNewline
    }

    $filteredWords | Set-Content $outputPath
    Write-Host ""
    Write-Host "The output contains $($filteredWords.count) words"

}
catch {
    Write-Host "Word filter failed:"
    Write-Host ""
    Write-Error $_
}

# Jason Mcdill