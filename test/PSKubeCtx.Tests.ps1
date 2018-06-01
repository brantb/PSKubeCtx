#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}
$ModuleName = 'PSKubeCtx'
$ModulePath = Join-Path $PSScriptRoot "..\build\$ModuleName\" | Resolve-Path
$ModuleManifestPath = Join-Path $ModulePath "$ModuleName.psd1"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should -BeTrue
    }

    # Test that exported functions and public scripts match 1:1
    $manifest = Get-Module -ListAvailable $ModulePath
    $publicScripts = Get-ChildItem -Path (Join-Path $ModulePath 'src/public') -Filter '*.ps1' -ErrorAction SilentlyContinue
    $publicScripts | ForEach-Object {
        $expected = $_.BaseName
        It "Manifest exports a function named '$expected'" {
            $manifest.ExportedFunctions.Keys -contains $expected | Should -BeTrue
        }
    }

    $manifest.ExportedFunctions.Keys | ForEach-Object {
        $expected = $_
        It "Source code has a script named '$expected.ps1'" {
            $publicScripts.BaseName -contains $expected | Should -BeTrue
        }
    }
}

