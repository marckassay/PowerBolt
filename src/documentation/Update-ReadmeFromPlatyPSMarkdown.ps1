using module .\.\MKDocumentationInfo.psm1

function Update-ReadmeFromPlatyPSMarkdown {
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
        [string]$FileName = 'README.md'
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
                $MarkdownFolder
            )
        }
    }

    end {
        try {
            $MarkdownSnippetCollection = $DocInfo.GetMarkdownSnippetCollectionString()

            $ReadMePath = Join-Path -Path $DocInfo.ModuleFolder -ChildPath $FileName
            if ((Test-Path -Path $ReadMePath) -eq $false) {
                New-Item -Path $ReadMePath -ItemType File
            }

            $ReadMeContent = Get-Content -Path $ReadMePath -Raw
            $ExistingSnippetPattern = "(?<link>#### \[.*\w+-\w+.*\]\(http.*\))(?:\s*)(?<body>[\w\W]+?)(?(?=####)(?=####)|(?=(?:##|\z)))"

            if ($ReadMeContent) {
                $FirstIndex = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -First 1 -ExpandProperty Index
            }

            if ($FirstIndex) {
                $LastIndex = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -Last 1 -ExpandProperty Index
                $LastLength = [regex]::Matches($ReadMeContent, $ExistingSnippetPattern, 'm') | Select-Object -Last 1 -ExpandProperty Length
                $ReadMeContent = $ReadMeContent.Remove($FirstIndex, (($LastIndex + $LastLength) - $FirstIndex))

                # TODO: may want to use StringBuilder here
                $MarkdownSnippetCollection = $MarkdownSnippetCollection.Trim()
            }
            else {
                $SubSectionTitle = @"

## API
"@
                # TODO: may want to use StringBuilder here
                $FirstIndex = 0
                $MarkdownSnippetCollection = $MarkdownSnippetCollection.Insert($FirstIndex, $SubSectionTitle)
                $MarkdownSnippetCollection += [Environment]::NewLine
            }
            
            # if: the file isn't new $FirstIndex will not be 0... else: $FirstIndex will be 0, just assign $MarkdownSnippetCollection
            if ($FirstIndex) {
                # TODO: yeah StringBuilder can be used here for sure or fix regex
                $ReadMeContent = $ReadMeContent.Insert($FirstIndex, [Environment]::NewLine)
                $ReadMeContent = $ReadMeContent.Insert($FirstIndex, [Environment]::NewLine)
                $ReadMeContent.Insert($FirstIndex, $MarkdownSnippetCollection) | Set-Content -Path $ReadMePath | Out-Null
            }
            else {
                Set-Content -Path $ReadMePath -Value $MarkdownSnippetCollection | Out-Null
            }
        }
        catch {
            Write-Error "Unable to update README file."
        }
    }
}