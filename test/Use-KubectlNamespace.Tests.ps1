#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubectl {
    . "$PSScriptRoot\Helpers.ps1"

    Describe 'Use-KubectlNamespace' {
        Mock Invoke-Kubectl {
            'Context "something" modified.'
        }
        Mock Get-KubectlConfig {
            [pscustomobject]@{
                'current-context' = 'minikube'
                contexts          = @(
                    [pscustomobject]@{
                        name    = 'minikube'
                        context = [pscustomobject]@{
                            namespace = 'default'
                        }
                    }
                )
            }
        }
        It 'sets the namespace in the current context' {
            Use-KubectlNamespace -Name ignored

            Assert-MockCalled Invoke-Kubectl -Scope It -ParameterFilter {
                Test-ArrayEquality $Arguments 'config', 'set-context', 'minikube', '--namespace=ignored'
            }
        }

        It 'does nothing when the namespace is correct' {
            Use-KubectlNamespace -Name default

            Assert-MockCalled Invoke-Kubectl -Scope It -Times 0 -Exactly
        }
    }
}
