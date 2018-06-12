function GetConfiguration {
    [CmdletBinding()]
    param()

    # This gets called every time we display a prompt, so cache the current config in memory
    if (-not $script:Configuration) {
        $script:Configuration = Import-Configuration
    }
    $script:Configuration
}
