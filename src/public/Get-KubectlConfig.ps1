<#
.SYNOPSIS
Displays current kubeconfig settings.
#>#
function Get-KubectlConfig {
    [CmdletBinding()] param ()

    $config = Invoke-Kubectl config, view, --output, json | ConvertFrom-Json

    # Add a 'current-namespace' property
    $current = $config.contexts | Where-Object { $_.name -eq $config.'current-context' }
    $ns = if ($current.context.namespace) { $current.context.namespace } else { 'default' }
    $config | Add-Member -MemberType 'NoteProperty' -Name 'current-namespace' -Value $ns

    $config
}
