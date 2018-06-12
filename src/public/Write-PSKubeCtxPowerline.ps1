<#
.SYNOPSIS
    Writes prompt text with the current kubectl context and namespace.
.EXAMPLE
    PS> Add-PowerLineBlock { Write-PSKubeCtxPowerline }
    Adds the current kubectl context and namespace to your PowerLine prompt.
#>
function Write-PSKubeCtxPowerline {
    [CmdletBinding()]
    param (
        [Parameter()]
        [pscustomobject] $KubeConfig,
        [Parameter()]
        [pscustomobject] $ModuleConfig
    )

    if (-not $KubeConfig) { $KubeConfig = Get-KubectlConfig }
    if (-not $ModuleConfig) { $ModuleConfig = GetConfiguration }

    $ctx = $KubeConfig.'current-context'
    $ns = $KubeConfig.'current-namespace'

    # Context
    $contextText = @(
        $ModuleConfig.ContextPrefix
        $ctx
        $ModuleConfig.ContextSuffix
    ) -join ''

    $contextText | New-PromptText -Fg $ModuleConfig.ContextForeground -Bg $ModuleConfig.ContextBackground

    # Namespace
    $showNamespace = ($ns -ne 'default' -or -not $ModuleConfig.HideNamespaceIfDefault)
    if ($showNamespace) {
        $nsText = @(
            $ModuleConfig.NamespacePrefix
            $ns
            $ModuleConfig.NamespaceSuffix
        ) -join ''
        $nsText | New-PromptText -Fg $ModuleConfig.NamespaceForeground -Bg $ModuleConfig.NamespaceBackground
    }
}
