function Use-KubectlContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Invoke-Kubectl config, use-context, $Name | Write-Information
}
