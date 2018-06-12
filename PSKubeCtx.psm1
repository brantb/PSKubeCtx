# Source all files in src\
$sourceFiles = Get-ChildItem -Path "$PSScriptRoot\src" -Filter "*.ps1" -Recurse
$sourceFiles | ForEach-Object {
    . $_.FullName
}

# Export functions matching filenames in src\public
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
$sourceFiles | Where-Object { ($_.DirectoryName | Split-Path -Leaf) -eq 'public' } | ForEach-Object {
    Export-ModuleMember -Function $_.BaseName
}

New-Alias -Name ukc -Value Use-KubectlContext
New-Alias -Name ukn -Value Use-KubectlNamespace

Export-ModuleMember -Alias ukc, ukn
