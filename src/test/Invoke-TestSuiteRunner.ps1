# NoExport: Invoke-TestSuiteRunner
function Invoke-TestSuiteRunner {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True,
            Position = 1,
            ParameterSetName = "ByPath")]
        $Path = (Get-Location | Select-Object -ExpandProperty Path)
    )

    DynamicParam {
        return GetModuleNameSet -Position 0 -ParameterSetName 'ByName' -Mandatory
    }

    begin {
        $Name = $PSBoundParameters['Name']

        if ($Name) {
            $MI = Get-MKModuleInfo -Name $Name
        }
        else {
            $MI = Get-MKModuleInfo -Path $Path
        }

        Set-Location ($MI.ModuleBase)
        
        # Test-ModuleManifest $MI.ManifestPath | Remove-Module
    }

    process {
       Invoke-Command {Invoke-Pester -Script "$($MI.ModuleBase)\test"}
    }

    end {
        # Import-Module -Name ($MI.ModuleBase)
    }
}