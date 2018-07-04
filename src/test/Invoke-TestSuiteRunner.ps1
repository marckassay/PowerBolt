using module .\..\module\manifest\AutoUpdateSemVerDelegate.ps1

function Invoke-TestSuiteRunner {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $false)]
        [string]$TestFolderPath = 'test',

        [Parameter(Mandatory = $false,
            Position = 2,
            ValueFromPipeline = $false)]
        [string[]]$Exclude = 'mocks',

        [Parameter(Mandatory = $false,
            Position = 3,
            ValueFromPipeline = $false)]
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
        Set-Location $ModInfo.Path
        
        $TestPath = Join-Path -Path $ModInfo.Path -ChildPath $TestFolderPath -Resolve
        $ChildTestPaths = Get-ChildItem $TestPath -Exclude $Exclude -Directory | `
            Select-Object -ExpandProperty Name | `
            ForEach-Object {Join-Path -Path $TestPath -ChildPath $_}
            
        # FYI: https://github.com/pester/Pester/wiki/Invoke-Pester
        $ArgList = @{ Script = $ChildTestPaths; Show = $Show; PassThru = $PassThru.IsPresent }
    }

    process {
        Write-Host "Flow is now testing in: $TestPath" -ForegroundColor Green
        Start-Job -Name "JobPester" -ScriptBlock {
            param($AL) Invoke-Pester @AL
        } -ArgumentList $ArgList | Wait-Job -Force | ForEach-Object {Receive-Job -Name JobPester}
    }

    end {
        Import-Module ($ModInfo.Path)
        
        Pop-Location -StackName 'PriorTestLocation'
    }
}