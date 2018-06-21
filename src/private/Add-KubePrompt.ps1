# Add Kubernetes to the user's PowerShell prompt
function Add-KubePrompt {
    [CmdletBinding()]
    param()

    $powerlineEnabled = (GetConfiguration).PowerlineSupport

    if ($powerlineEnabled) {
        $powerlinePresent = Get-Module -ListAvailable -Name PowerLine
        if ($powerlinePresent) {
            Add-PowerLineBlock { Write-PSKubeCtxPowerline } -AutoRemove
        }
    }
}
