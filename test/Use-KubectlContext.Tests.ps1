#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubeCtl {
    . "$PSScriptRoot\Helpers.ps1"

    Describe 'Use-KubectlContext' {
        Context 'The context exists' {
            Mock Invoke-Kubectl {
                "Switched to context `"$Name`""
            }

            It 'sets the context' {
                { Use-KubectlContext -Name expected } | Should -Not -Throw

                Assert-MockCalled Invoke-Kubectl -Scope It -ParameterFilter {
                    Test-ArrayEquality $Arguments 'config', 'use-context', 'expected'
                }
            }

            It 'has no output' {
                Use-KubectlContext -Name ignored | Should -BeNull
            }

            It 'writes to the information stream' {
                $infoStream = Use-KubectlContext -Name ignored 6>&1
                $infoStream | Should -Match "Switched to context"
            }
        }

        Context 'The context does not exist' {
            Mock Invoke-Kubectl -ModuleName PSKubeCtl {
                Write-Error "error: no context exists with the name: `"$Name`"."
            }
            It 'writes an error' {
                $errStream = Use-KubectlContext -Name nosuchcontext 2>&1
                $errStream | Should -Match "no context exists"
            }
            It 'does not write information' {
                $infoStream = Use-KubectlContext -Name nosuchcontext 6>&1 -ErrorAction SilentlyContinue
                $infoStream | Should -BeNull
            }
        }
    }
}
