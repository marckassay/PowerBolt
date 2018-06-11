function Invoke-TestSuiteRunner {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]
        $Path = (Get-Location | Select-Object -ExpandProperty Path)
    )

    DynamicParam {
        return GetModuleNameSet
    }

    begin {
        Push-Location -StackName 'TestSuite'

        $MI = Get-ModuleInfo @PSBoundParameters

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