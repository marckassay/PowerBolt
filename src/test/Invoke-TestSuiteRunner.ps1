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

        Push-Location -StackName 'TestSuite'

        if ($Name) {
            $MI = Get-ModuleInfo -Name $Name
        }
        else {
            $MI = Get-ModuleInfo -Path $Path
        }

        Set-Location ($MI.ModuleBase)
        
        Get-Item -Path . -Include '*.psd1' -OutVariable ManifestItem | Test-ModuleManifest | Remove-Module
    }

    process {
        Invoke-Pester -Script "$($MI.ModuleBase)\test"
    }

    end {
        Import-Module -Name ($MI.ModuleBase)
        
        Pop-Location -StackName 'TestSuite'
    }
}