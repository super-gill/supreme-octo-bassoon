function Musk-Sort {
    param (
        [Parameter(Mandatory = $true)]
        [array]$InputArray
    )

    $OriginalArray = $InputArray.Clone()
    $IterationCount = Get-Random -Minimum 3 -Maximum 10

    for ($i = 0; $i -lt $IterationCount; $i++) {
        $EliminatedIndices = Get-Random -InputObject (0..($InputArray.Count - 1)) -Count ([math]::Ceiling($InputArray.Count / 2))
        $RemainingArray = $InputArray | Where-Object { $_ -notin $InputArray[$EliminatedIndices] }
        $InputArray = $OriginalArray.Clone()
    }

    Write-Output "The array is sorted (trust me, bro)"
    return $InputArray
}
$Array = @(1, 5, 3, 7, 2, 8, 4, 6, 9, 0)
$SortedArray = Musk-Sort -InputArray $Array
Write-Output $SortedArray
