using module .\.\MKDocumentationInfo.psm1

function New-ExternalHelpFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $True, 
            ParameterSetName = "ByPipe")]
        [MKDocumentationInfo]$DocInfo,

        [Parameter(Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$OutputFolder = 'en-US'
    )

    DynamicParam {
        return GetModuleNameSet -Mandatory -Position 0
    }
    
    begin {
        $Name = $PSBoundParameters['Name']
        
        if (-not $DocInfo) {
            $DocInfo = [MKDocumentationInfo]::new(
                $Name,
                $Path,
                $MarkdownFolder,
                $OutputFolder
            )
        }
    }

    end {
        $MarkdownFolder = Join-Path -Path $DocInfo.Path -ChildPath $DocInfo.MarkdownFolder

        $HelpLocaleFolder = Join-Path -Path $DocInfo.Path -ChildPath $DocInfo.Locale

        if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
            New-Item -Path $HelpLocaleFolder -ItemType Container | Out-Null
        }

        New-ExternalHelp -Path $MarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
            Out-Null
        
        Write-Output $DocInfo
    }
}