# Module to set visual effects to "Adjust for best performance"
# Super experimental WIP!

param (
    [bool]$whatIf = $true,
    [bool]$showHelp = $false
)

if ($showHelp) {

    [string]$author = "Jason Mcdill"
    [int]$version = 1
    [string]$scriptName = [system.io.path]::GetFileName($PSCommandPath)

    Clear-Host
    Write-Host "Showing help" -ForegroundColor Yellow
    
    Write-Host ""
    
    Write-Host "Title: " -ForegroundColor Yellow
    Write-Host $scriptName
    
    Write-Host ""
    
    Write-Host "Version: " -ForegroundColor Yellow
    Write-Host $version
    
    Write-Host ""
    
    Write-Host "Description: " -ForegroundColor Yellow
    Write-Host "This module sets ""Adjust for best performance"" option in advanced system settings then enabled smooth text and contents while dragging"

    Write-Host ""
    
    Write-Host "Example 1:  " -ForegroundColor Yellow
    Write-Host ".\bestPerformance.ps1 -whatIf $true"
    
    Write-Host ""
    
    Write-Host "Example 2:  " -ForegroundColor Yellow
    Write-Host ".\bestPerformance.ps1 -whatIf $false"

    Write-Host ""

    Write-Host "Author: " -ForegroundColor Yellow
    Write-Host $author
    
    Write-Host ""
    exit
}


# Registry path for visual effects settings
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

# Set all visual effects to off (best performance)
$settings = @(
    "AnimateMinMax",
    "ComboBoxAnimation",
    "CursorShadow",
    "DragFullWindows",
    "DropShadow",
    "FontSmoothing",
    "ListBoxSmoothScrolling",
    "ListviewAlphaSelect",
    "MenuAnimation",
    "SelectionFade",
    "TaskbarAnimations",
    "Themes",
    "ToolTipAnimation",
    "UseDesktopIniCache",
    "WebView",
    "WindowAnimation"
)

foreach ($setting in $settings) {
    if ($whatIf) { Write-Host "Would set $($setting) to Value 0" } else { Set-ItemProperty -Path $regPath -Name $setting -Value 0 }
}

Write-Output ""
Write-Output "Enabling..."
# Registry path for visual effects settings
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    
# Enable "Smooth edges of screen fonts"
if ($whatIf) { Write-Host "Would set FontSmoothing to Value 2" } else { Set-ItemProperty -Path $regPath -Name "FontSmoothing" -Value 2 }
    
# Enable "Show contents while dragging"
if ($whatIf) { Write-Host "Would set DragFullWindows to Value 1" } else { Set-ItemProperty -Path $regPath -Name "DragFullWindows" -Value 1 }