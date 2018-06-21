<#
.SYNOPSIS
    Configures the output of Write-PSKubeCtxPowerline.
.NOTES
    Foreground/Background colors can be specified using any of the formats supported by [PoshCode.Pansies.RgbColor]::new, e.g.
    - CSS-style strings (#00FF00)
    - XTerm indexes
    - System.ConsoleColor

    Set a color value to $null to unset.

.EXAMPLE
    PS> Set-PSKubeCtxPromptSetting -ContextForeground "#0000FF"
    Sets the text color of the context to blue.
#>
function Set-PSKubeCtxPromptSetting {
    [CmdletBinding()]
    param (
        # Do not display the namespace in the prompt if it is 'default'.
        [switch] $HideNamespaceIfDefault,
        # Text prepended to the context.
        [string] $ContextPrefix,
        # Text appended to the context.
        [string] $ContextSuffix,
        # Foreground color of context.
        [Alias('CFg')]
        [string] $ContextForeground,
        # Background color of context.
        [Alias('CBg')]
        [string] $ContextBackground,
        # Text prepended to the namespace.
        [string] $NamespacePrefix,
        # Text appended to the namespace.
        [string] $NamespaceSuffix,
        # Foreground color of namespace.
        [Alias('NFg')]
        [string] $NamespaceForeground,
        # Background color of namespace.
        [Alias('NBg')]
        [string] $NamespaceBackground,
        # Enable automatic PowerLine support
        [switch] $PowerLineSupport
    )

    $config = GetConfiguration

    switch ($PSBoundParameters.Keys) {
        'ContextPrefix' { $config.$_ = $PSBoundParameters[$_] }
        'ContextSuffix' { $config.$_ = $PSBoundParameters[$_] }
        'ContextForeground' { $config.$_ = $PSBoundParameters[$_] }
        'ContextBackground' { $config.$_ = $PSBoundParameters[$_] }
        'NamespacePrefix' { $config.$_ = $PSBoundParameters[$_] }
        'NamespaceSuffix' { $config.$_ = $PSBoundParameters[$_] }
        'NamespaceForeground' { $config.$_ = $PSBoundParameters[$_] }
        'NamespaceBackground' { $config.$_ = $PSBoundParameters[$_] }
        'HideNamespaceIfDefault' { $config.$_ = [bool]$PSBoundParameters[$_] }
        'PowerLineSupport' { $config.$_ = [bool]$PSBoundParameters[$_] }
    }

    Export-Configuration $config
    $script:Configuration = $config
}
