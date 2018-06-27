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
        [string[]]$Excludes = 'mocks',

        [Parameter(Mandatory = $False,
            Position = 3,
            ValueFromPipeline = $False)]
        [Pester.OutputTypes[]]$Show = @('Header', 'Fails'),

        [switch]$PassThru
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
        # FYI: https://github.com/pester/Pester/wiki/Invoke-Pester
        $ArgList = @{ Script = $ScriptPaths; Show = $Show; PassThru = $PassThru.IsPresent }
    }

    process {
        Write-Host "Flow is now testing in: $ScriptPath" -ForegroundColor Green
        Start-Job -Name "JobPester" -ScriptBlock {param($P) Invoke-Pester @P} -ArgumentList $ArgList | `
            Wait-Job -Force | `
            ForEach-Object {Receive-Job -Name JobPester}
    }

    end {
        Import-Module ($ModInfo.Path)
        
        Pop-Location -StackName 'PriorTestLocation'
    }
}