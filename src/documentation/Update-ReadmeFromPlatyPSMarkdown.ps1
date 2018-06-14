using module .\.\MKDocumentationInfo.psm1

function Update-ReadmeFromPlatyPSMarkdown {
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
        [string]$MarkdownFolder = 'docs'
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

            $ReadMePath = $DocInfo.Path + "\README.md"
            if ((Test-Path -Path $ReadMePath) -eq $false) {
                New-Item -Path $ReadMePath -ItemType File
            }

            $ReadMeContent = Get-Content -Path $ReadMePath -Raw
            $ExistingSnippetPattern = "^(#### \[.*\w+-\w+.*\]\(http.*\))(\s*)(?<body>[\w\W]+?)(?(?=####)(?=####)|(\z))"

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
                $MarkdownSnippetCollection = $MarkdownSnippetCollection.Insert(0, $SubSectionTitle)
                $FirstIndex = $ReadMeContent.Length
            }
            
            # if the file isnt new..., else just assign $MarkdownSnippetCollection
            if ($FirstIndex) {
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