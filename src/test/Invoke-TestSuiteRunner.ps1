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
        $ArgList = @{ Script = $ScriptPath; PassThru = $true }
        
        Remove-Module -Name $ModInfo.Name
    }

    process {
        Start-Job -Name "JobPester" -ScriptBlock {
            param($P)  Invoke-Pester @P
        } -ArgumentList $ArgList | Wait-Job
    }

    end {
        Import-Module -Name ($ModInfo.Path)
        
        Pop-Location -StackName 'PriorTestLocation'
    }
}