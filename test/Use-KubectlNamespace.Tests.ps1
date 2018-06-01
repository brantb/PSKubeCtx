#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubeCtx {
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
                            namespace = 'namespace'
                            cluster   = 'cluster'
                            user      = 'user'
                        }
                    }
                )
            }
        }
        It 'updates the current context' {
            Use-KubectlNamespace -Name ignored

            Assert-MockCalled Invoke-Kubectl -Scope It -ParameterFilter {
                Test-ArrayEquality $Arguments 'config', 'set-context', 'minikube', '--namespace=ignored'
            }
        }

        It 'does nothing when the requested namespace is the current namespace' {
            Use-KubectlNamespace -Name namespace

            Assert-MockCalled Invoke-Kubectl -Scope It -Times 0 -Exactly
        }

        Context 'Current namespace is blank' {
            Mock Get-KubectlConfig {
                [pscustomobject]@{
                    'current-context' = 'minikube'
                    contexts          = @(
                        [pscustomobject]@{
                            name    = 'minikube'
                            context = [pscustomobject]@{
                                cluster = 'cluster'
                                user    = 'user'
                            }
                        }
                    )
                }
            }
            It 'defaults to "default"' {
                Use-KubectlNamespace -Name default

                Assert-MockCalled Invoke-Kubectl -Scope It -Times 0 -Exactly
            }
        }
    }
}
