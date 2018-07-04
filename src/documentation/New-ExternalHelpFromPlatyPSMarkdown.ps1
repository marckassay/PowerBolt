using module .\.\MKDocumentationInfo.psm1

function New-ExternalHelpFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true, 
            ParameterSetName = "ByPipe")]
        [MKDocumentationInfo]$DocInfo,

        [Parameter(Mandatory = $false)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $false)]
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
        $MarkdownFolder = Join-Path -Path $DocInfo.ModuleFolder -ChildPath $DocInfo.MarkdownFolder

        $HelpLocaleFolder = Join-Path -Path $DocInfo.ModuleFolder -ChildPath $DocInfo.Locale

        if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $false) {
            New-Item -Path $HelpLocaleFolder -ItemType Container | Out-Null
        }

        New-ExternalHelp -Path $MarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
            Out-Null
        
        Write-Output $DocInfo
    }
}