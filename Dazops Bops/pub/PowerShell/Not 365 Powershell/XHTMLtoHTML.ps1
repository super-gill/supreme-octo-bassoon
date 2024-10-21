# Path to the input XHTML file
$inputFile = "C:\Users\Jason.McDill\OneDrive - Digital Origin Solutions\Documents\AZDevOps\Helpdesk-1\PowerShell\xhtmlconvertme.xhtml"

# Path to the output HTML file
$outputFile = "C:\Users\Jason.McDill\OneDrive - Digital Origin Solutions\Documents\AZDevOps\Helpdesk-1\PowerShell\output.html"

# Read the XHTML file content as a single string
$xhtmlContent = [System.IO.File]::ReadAllText($inputFile)

# Remove XML declaration
$htmlContent = $xhtmlContent -replace '<\?xml.*\?>', ''

# Change DOCTYPE to HTML5
$htmlContent = $htmlContent -replace '<!DOCTYPE[^>]*>', '<!DOCTYPE html>'

# Remove xmlns attribute
$htmlContent = $htmlContent -replace 'xmlns="[^"]*"', ''

# Convert self-closing tags to HTML compatible format
$htmlContent = $htmlContent -replace '<(\w+)\s*/>', '<$1>'

# Save the converted content as HTML
[System.IO.File]::WriteAllText($outputFile, $htmlContent)

Write-Output "Conversion complete. The HTML file is saved at: $outputFile"
