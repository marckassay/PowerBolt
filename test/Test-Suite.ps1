# TODO: needs to execute when $MKPowerShellModuleName is not installed too.
function Test-Suite {
    [CmdletBinding()]
    Param(
        $MKPowerShellModuleName
    )

    begin {
        Push-Location -StackName 'TestSuite'
        $ModulePath = Get-Module $MKPowerShellModuleName -OutVariable Module | Select-Object -Property Path
        $ModuleFolder = $ModulePath | `
            Split-Path -Parent

        if ($ModulePath) {
            $Module | Remove-Module -ErrorAction SilentlyContinue
            Remove-Module MKPowerShellDocObject -ErrorAction SilentlyContinue
        }
    }

    process {
        Invoke-Pester -Script "$ModuleFolder\test"
    }

    end {
        $ManifestPath = $ModuleFolder | `
            Join-Path -ChildPath "$MKPowerShellModuleName.psd1" -Resolve
        
        Import-Module -Name $ManifestPath

        Pop-Location -StackName 'TestSuite'
    }
}
Test-Suite -MKPowerShellModuleName 'MK.PowerShell.4PS'