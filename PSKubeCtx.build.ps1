param(
    $RepositoryName = 'PSGallery',
    $NuGetApiKey,
    $Editor
)

$moduleName = 'PSKubeCtx'
$buildDest = Join-Path $BuildRoot "build\$moduleName"

# Synopsis: Clean the build destination folder
task Clean {
    Remove-Item -Force -Recurse $buildDest -ErrorAction SilentlyContinue
}

# Synopsis: Create the build destination folder
task CreateOutputFolder {
    New-Item -ItemType Directory $buildDest -Force | Out-Null
}

# Synopsis: Copy module files to the build destination folder
task CopyToOutput @{
    Partial = $true
    Inputs  = {
        # From this scriptblock, return the files to to copy to the destination folder.
        Get-ChildItem -Path "$BuildRoot\src" -Recurse -File
        Get-Item -Path "$BuildRoot\$moduleName.psd1"
        Get-Item -Path "$BuildRoot\$moduleName.psm1"
        Get-Item -Path "$BuildRoot\Configuration.psd1"
    }
    Outputs = {
        process { $_.Replace($BuildRoot, $buildDest) }
    }
    Jobs    = {
        begin {
            # Create empty directories
            $Outputs | Split-Path -Parent | Select-Object -Unique | ForEach-Object { mkdir -Force $_ } | Out-Null
        }
        process { Copy-Item $_ $2 }
    }
}

# Synopsis: Build the module
task Build CreateOutputFolder, CopyToOutput

# Synopsis: Run Pester tests
task Test Build, {
    Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
    Import-Module $buildDest
    $pesterOption = if ($Editor -eq 'VSCode') {
        @{ IncludeVSCodeMarker = $true }
    }
    else {
        @{}
    }
    Invoke-Pester -PesterOption $pesterOption
}

# Synopsis: Publish the module to the PowerShell Gallery
task Publish Clean, Build, Test, {
    $manifestPath = Join-Path $buildDest "$moduleName.psd1"
    $manifest = Test-ModuleManifest $manifestPath

    # Ensure the version number has been updated
    Test-ModulePublished -Name $moduleName -Version $manifest.Version -Repository $RepositoryName -AssertUnpublished | Out-Null

    Publish-Module -Verbose -Path $buildDest -NuGetApiKey (property NuGetApiKey) -Repository $RepositoryName
}

# Synopsis: Default task
Task . Test

