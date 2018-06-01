<#
.SYNOPSIS
Displays current kubeconfig settings.
#>#
function Get-KubectlConfig {
    [CmdletBinding()] param ()

    Invoke-Kubectl config, view, --output, json | ConvertFrom-Json
}
