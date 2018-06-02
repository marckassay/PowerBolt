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
        [string]$MarkdownFolder = 'docs'
    )
    
    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Path,
                $MarkdownFolder
            )
        }
    }

    end {
        try {
            $MarkdownSnippetCollection = $Data.GetMarkdownSnippetCollectionString()

            $ReadMePath = Join-Path -Path $Data.Path -ChildPath "\README*" -Resolve
            $ReadMeContent = Get-Content -Path $ReadMePath -Raw
            $ExistingSnippetPattern = "^(### \[.*\w+-\w+.*\]\(http.*\))(\s*)(?<body>[\w\W]+?)(?(?=###)(?=###)|(\z))"
            $FirstIndex = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -First 1 -ExpandProperty Index
            if($FirstIndex){
                $LastIndex = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -Last 1 -ExpandProperty Index
                $LastLength = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -Last 1 -ExpandProperty Length
                $ReadMeContent = $ReadMeContent.Remove($FirstIndex, (($LastIndex+$LastLength)-$FirstIndex))

                # TODO: may want to use StringBuilder here
                $MarkdownSnippetCollection = $MarkdownSnippetCollection.Trim()
            } else {
                $SubSectionTitle = @"

## API
"@
                # TODO: may want to use StringBuilder here
                $MarkdownSnippetCollection = $MarkdownSnippetCollection.Insert(0,$SubSectionTitle)
                $FirstIndex = $ReadMeContent.Length
            }

            
            $ReadMeContent.Insert($FirstIndex, $MarkdownSnippetCollection) | Set-Content -Path $ReadMePath | Out-Null
        }
        catch {
            Write-Error "Unable to update README file."
        }
    }
}