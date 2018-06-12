#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubectx {
    . "$PSScriptRoot\Helpers.ps1"

    Describe 'Get-KubectlConfig' {
        Context 'happy path' {
            Mock Invoke-Kubectl {
                [pscustomobject]@{
                    'current-context' = 'minikube'
                    contexts          = @(
                        [pscustomobject]@{
                            name    = 'minikube'
                            context = [pscustomobject]@{
                                cluster   = 'minikube-cluster'
                                user      = 'minikube-user'
                                namespace = 'kube-system'
                            }
                        }
                        [pscustomobject]@{
                            name    = 'aks'
                            context = [pscustomobject]@{
                                cluster   = 'aks-cluster'
                                user      = 'aks-user'
                                namespace = 'default'
                            }
                        }
                    )
                } | ConvertTo-Json -depth 100
            }

            It 'gets the current config' {
                Get-KubectlConfig | Should -Not -BeNullOrEmpty

                Assert-MockCalled Invoke-Kubectl -Scope It -ParameterFilter {
                    Test-ArrayEquality $Arguments 'config', 'view', '--output', 'json'
                }
            }

            It 'adds a current-namespace property' {
                $config = Get-KubectlConfig
                $config.'current-namespace' | Should -BeExactly 'kube-system'
            }

        }

        Context 'current context has no explicit namespace' {
            Mock Invoke-Kubectl {
                [PSCustomObject]@{
                    'current-context' = 'context'
                    contexts          = @(
                        [PSCustomObject]@{
                            name = 'context'
                            user = 'user'
                        }
                    )
                } | ConvertTo-Json -Depth 100
            }

            It 'defaults to the "default" namespace' {
                $config = Get-KubectlConfig
                $config.'current-namespace' | Should -BeExactly 'default'
            }
        }
    }
}
