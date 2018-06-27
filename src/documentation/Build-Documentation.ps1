using module .\.\MKDocumentationInfo.psm1

function Build-Documentation {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate = '',

        [Parameter(Mandatory = $False)]
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
        Write-Host ("Flow is now building documentation for " + $DocInfo.ModuleName) -ForegroundColor Green

        Write-Output $DocInfo | `
            Build-PlatyPSMarkdown -Force:$Force.IsPresent | `
            New-ExternalHelpFromPlatyPSMarkdown | `
            Update-ReadmeFromPlatyPSMarkdown

        $OFS = ' '
    }
}