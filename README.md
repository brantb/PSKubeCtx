# PSKubeCtx

PSKubeCtl is a utility to manage and switch between kubectl contexts, inspired by [kubectx].

[kubectx]: https://github.com/ahmetb/kubectx

## Features/usage

PSKubeCtl provides the following cmdlets to manage your kubectl context:

*   `Use-KubectlContext` (`ukc`) - Switches to a context, like `kubectl config use-context foobar`
*   `Use-KubectlNamespace` (`ukn`) - Changes the namespace in the current context, like `kubectl config set-context <current> --namespace=foobar`
*   `Get-KubectlConfig` - Like `kubectl config view`

## Installing from the PowerShell Gallery

```powershell
Install-Module PSKubeCtx
```

## Future additions

*   Tab-completion of context names
*   [Powerline][powerline] support (to Zembed the current context in your prompt)

[powerline]: https://github.com/Jaykul/PowerLine
