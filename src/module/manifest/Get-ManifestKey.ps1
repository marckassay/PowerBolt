# NoExport: Get-ManifestKey
function Get-ManifestKey {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $true)]
        [ValidateSet("AliasesToExport", "FunctionsToExport", "RootModule", "TypesToProcess", "CmdletsToExport", "PrivateData", "FileList", "Author", "ModuleVersion", "CompanyName", "FormatsToProcess", "GUID", "Copyright")]
        [String]$Key
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
    
        try {
            $Results = (Import-PowerShellDataFile -Path $ModInfo.ManifestFilePath)[$Key]
        }
        catch {
        
        }

        $Results
    }
}