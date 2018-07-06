using module .\.\MKDocumentationInfo.psm1

function Build-Documentation {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $false)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $false)]
        [string]$OnlineVersionUrlTemplate = '',

        [Parameter(Mandatory = $false)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [switch]
        $NoReImportModule,

        [switch]
        $Force
    )

    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }
    
    begin {
        # Output Field Separator - default is ' '
        $OFS = ''
        
        $Name = $PSBoundParameters['Name']

        $DocInfo = [MKDocumentationInfo]::new(
            $Name,
            $Path,
            $MarkdownFolder,
            $Locale,
            $OnlineVersionUrlTemplate,
            $OnlineVersionUrlPolicy,
            $MarkdownSnippetCollection,
            $NoReImportModule.IsPresent
        )
    }

    end {
        Write-Host ("PowerEquip is now building documentation for " + $DocInfo.ModuleName) -ForegroundColor Green

        Write-Output $DocInfo | `
            Build-PlatyPSMarkdown -Force:$Force.IsPresent | `
            New-ExternalHelpFromPlatyPSMarkdown | `
            Update-ReadmeFromPlatyPSMarkdown

        $OFS = ' '
    }
}