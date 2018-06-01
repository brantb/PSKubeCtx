<#
.SYNOPSIS
Sets the namespace in the current kubectl context.

.PARAMETER Name
The namespace to use.

.EXAMPLE
PS> ukn kube-system
Changes the namespace in the current context to 'kube-system'.
#>
function Use-KubectlNamespace {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $cfg = Get-KubectlConfig
    $current = $cfg.contexts | Where-Object { $_.name -eq $cfg.'current-context' }

    Write-Debug "Current context/namespace: $($current.name)/$($current.context.namespace)"

    $currentNs = $current.context.namespace
    $currentNs = if ($currentNs) { $currentNs } else { 'default' }

    if ($currentNs -ne $Name) {
        Write-Verbose "Switching to namespace $Name"
        Invoke-Kubectl config, set-context, $current.name, "--namespace=$Name"
    }
}
