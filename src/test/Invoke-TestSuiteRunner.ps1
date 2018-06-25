using module .\..\module\manifest\AutoUpdateSemVerDelegate.ps1

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
        [string]$TestFolderPath = 'test',

        [Parameter(Mandatory = $False,
            Position = 2,
            ValueFromPipeline = $False)]
        [string[]]$Excludes = 'mocks'
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

        AutoUpdateSemVerDelegate($ModInfo.Path)

        Push-Location -StackName 'PriorTestLocation'
        
        $ScriptPath = Join-Path -Path $ModInfo.Path -ChildPath $TestFolderPath -Resolve
        $ScriptPaths += Get-ChildItem $ScriptPath -Exclude $Excludes | `
            Select-Object -ExpandProperty FullName
        # FYI: https://github.com/PowerShell/Plaster/blob/master/docs/en-US/Invoke-Plaster.md
        $ArgList = @{ Script = $ScriptPaths; PassThru = $true }
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