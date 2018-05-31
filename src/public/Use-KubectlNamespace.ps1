function Use-KubectlNamespace {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $cfg = Get-KubectlConfig
    $current = $cfg.contexts | Where-Object { $_.name -eq $cfg['current-context'] }

    Write-Debug "Current context/namespace: $($current.name)/$($current.context.namespace)"

    if ($current.context.namespace -ne $Name) {
        Write-Verbose "Switching to namespace $Name"
        Invoke-Kubectl config, set-context, $current.name, "--namespace=$Name"
    }
}
