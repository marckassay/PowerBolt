using module .\.\MKPowerShellDocObject.psm1

function Update-ReadmeFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$ReadMeBeginBoundary = '## Functions',

        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = '## RoadMap'
    )
    
    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Path,
                $MarkdownFolder,
                $ReadMeBeginBoundary,
                $ReadMeEndBoundary
            )
        }
    }

    end {
        try {
            $ReadMePath = Join-Path -Path $Data.Path -ChildPath "\README*" -Resolve
            [string]$ReadMeContents = Get-Content -Path $ReadMePath -Raw

            # check to see if ReadMeBeginBoundary exists, if not append it
            if (-not $($ReadMeContents -match $Data.ReadMeBeginBoundary)) {
                $ReadMeContents += @"


$($Data.ReadMeBeginBoundary)

"@
            }
            [regex]$InsertPointRegEx = "(?(?<=$($Data.ReadMeBeginBoundary))([\w\W]*?)|($))(?(?=$($Data.ReadMeEndBoundary))(?=$($Data.ReadMeEndBoundary))|($))"
            $ModuleMarkdownPath = Join-Path -Path $Data.Path -ChildPath $Data.MarkdownFolder
            $MarkdownSnippetCollection = [MKPowerShellDocObject]::CreateMarkdownSnippetCollection($ModuleMarkdownPath, $Data.OnlineVersionUrl)
            $ReadMeContents = $InsertPointRegEx.Replace($ReadMeContents, @"

$MarkdownSnippetCollection

"@, 1)
            Set-Content -Path $ReadMePath -Value $ReadMeContents | Out-Null
        }
        catch {
            Write-Error "Unable to update README file."
        }
    }
}