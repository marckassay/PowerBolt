function Test-4PS {
    [CmdletBinding()]
    Param(
    )

    begin {
        $ModulePath = Get-Module MK.PowerShell.4PS -OutVariable Module | Select-Object -Property Path
        if ($ModulePath) {
            $Module | Remove-Module -ErrorAction SilentlyContinue
            Remove-Module MKPowerShellDocObject -ErrorAction SilentlyContinue
        }
    }

    process {
        Invoke-Pester -Script . -EnableExit
    }

    end {
        $ManifestPath = $ModulePath | `
            Split-Path -Parent | `
            Join-Path -ChildPath '.\MK.PowerShell.4PS.psd1' -Resolve
        
        Import-Module -Name $ManifestPath
    }
}
Test-4PS