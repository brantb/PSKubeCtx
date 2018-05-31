# Simple wrapper for the kubectl command so invocations can be mocked out.
function Invoke-Kubectl {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string[]] $Arguments
    )

    Write-Verbose "Invoking kubectl with arguments: $Arguments"
    & kubectl $Arguments
}
