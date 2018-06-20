using module .\.\MKModuleInfo.psm1

function Update-ModuleExports {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false)]
        [string]$SourceFolderPath = 'src',

        [Parameter(Mandatory = $false)]
        [string[]]$Include = @('*.ps1', '*.psm1'),
 
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = '*.Tests.ps1',

        [switch]
        $PassThru
    )

    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        if ($PSBoundParameters.Name) {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }
        else {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }

        $ModInfo | Update-RootModuleUsingStatements | Update-ManifestFunctionsToExportField
    }
}
