#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubectx {
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
        }
    }
}
