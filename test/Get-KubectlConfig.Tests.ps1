#Requires -Module @{ ModuleName='Pester'; ModuleVersion='4.3'}

InModuleScope PSKubeCtl {
    . "$PSScriptRoot\Helpers.ps1"

    Describe 'Get-KubectlConfig' {
        Mock Invoke-Kubectl {
            [pscustomobject]@{
                'current-context' = 'minikube'
                contexts          = @(
                    [pscustomobject]@{
                        name    = 'minikube'
                        context = [pscustomobject]@{
                            cluster   = 'minikube'
                            user      = 'minikube'
                            namespace = 'default'
                        }
                    }
                )
            } | ConvertTo-Json
        }

        It 'gets the current config' {
            Get-KubectlConfig | Should -Not -BeNullOrEmpty

            Assert-MockCalled Invoke-Kubectl -Scope It -ParameterFilter {
                Test-ArrayEquality $Arguments 'config', 'view', '--output', 'json'
            }
        }
    }
}
