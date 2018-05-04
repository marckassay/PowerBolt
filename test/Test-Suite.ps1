function Test-Suite {
    [CmdletBinding()]
    Param(
    )

    begin {
        Push-Location -StackName 'TestSuite'
        $ModulePath = Get-Module MK.PowerShell.4PS -OutVariable Module | Select-Object -Property Path
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
            Join-Path -ChildPath '.\MK.PowerShell.4PS.psd1' -Resolve
        
        Import-Module -Name $ManifestPath

        Pop-Location -StackName 'TestSuite'
    }
}
Test-Suite