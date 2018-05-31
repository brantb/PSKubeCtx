function Test-ArrayEquality {
    param(
        [Parameter(Position = 0)]
        [psobject[]]$ReferenceObject,

        [Parameter(Position = 1)]
        [psobject[]]$DifferenceObject
    )

    $differences = Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $DifferenceObject -SyncWindow 0
    return ($differences.Length -eq 0)
}
