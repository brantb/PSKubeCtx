# PSKubeCtx

PSKubeCtx is a utility to manage and switch between kubectl contexts, inspired by [kubectx].

[kubectx]: https://github.com/ahmetb/kubectx

## Features/usage

PSKubeCtx provides the following cmdlets to manage your kubectl context:

-   `Use-KubectlContext` (`ukc`) - Switches to a context, like `kubectl config use-context foobar`
-   `Use-KubectlNamespace` (`ukn`) - Changes the namespace in the current context, like `kubectl config set-context <current> --namespace=foobar`
-   `Get-KubectlConfig` - Like `kubectl config view`, but in the form of a `PSCustomObject`

## PowerLine prompt support

PSKubeCtx will automatically add the current Kubernetes context/namespace to your PowerShell prompt if the [PowerLine][powerline] module is available. The formatting and coloring can be customized using the `Set-PSKubeCtxPromptSetting` cmdlet (or disabled entirely).

[powerline]: https://github.com/Jaykul/PowerLine

## Installing from the PowerShell Gallery

```powershell
Install-Module PSKubeCtx
```

## Future ideas

-   Tab-completion of context names
