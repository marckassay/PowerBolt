function Invoke-TestSuiteRunner {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $False,
            Position = 1,
            ValueFromPipeline = $False)]
        [string]$TestFolderPath = 'test'
    )

    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }
    
    begin {
        $Name = $PSBoundParameters['Name']

        if ($Name) {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }
        else {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }

        Push-Location -StackName 'PriorTestLocation'
        
        $ScriptPath = Join-Path -Path $ModInfo.Path -ChildPath $TestFolderPath -Resolve

        # FYI: https://github.com/PowerShell/Plaster/blob/master/docs/en-US/Invoke-Plaster.md
        $ArgList = @{ Script = $ScriptPath; PassThru = $true }
    }

    process {
        Start-Job -Name "JobPester" -ScriptBlock {
            param($P)  Invoke-Pester @P
        } -ArgumentList $ArgList | Wait-Job
    }

    end {
        Import-Module ($ModInfo.Path) -Global -Force
        
        Pop-Location -StackName 'PriorTestLocation'
    }
}