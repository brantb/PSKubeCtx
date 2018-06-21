<#
.SYNOPSIS
Sets the current kubectl context.

.DESCRIPTION
Long description

.PARAMETER Name
The name of the context to use.

.EXAMPLE
PS> Use-KubectlContext -Name minikube

Uses the context for the minikube cluster.
#>
function Use-KubectlContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0,
            HelpMessage = "Enter the context to switch to.")]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    Invoke-Kubectl config, use-context, $Name
}
