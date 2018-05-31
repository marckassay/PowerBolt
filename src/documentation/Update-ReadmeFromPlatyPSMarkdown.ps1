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
            $AppendageContent
            $ReadMePath = Join-Path -Path $Data.Path -ChildPath "\README*" -Resolve
            $ReadMeContents = Get-Content -Path $ReadMePath

            $MarkdownFolderItems = Get-ChildItem -Path $Data.ModuleMarkdownFolder -Include '*.md' -Recurse
            $MarkdownSnippetCollection = $Data.GetMarkdownSnippetCollection()

            $MarkdownSnippetCollection | ForEach-Object -Process {

                $FunctionName = $_.FunctionName
                $NewTitleLine = $_.TitleLine
                $NewBodyContent = $("    " + $_.BodyContent)

                $TitlePattern = "^(?<title>### \[.*$FunctionName.*\]\(http.*\))"
                $hasBeenUpdated = $False
                for ($index = 0; $index -lt $ReadMeContents.Count; $index++) {
                    if (($ReadMeContents[$index]) -Match $TitlePattern ) {
                        $ReadMeContents[$index] = $NewTitleLine
                        if (($index + 2) -le $ReadMeContents.Count) {
                            $ReadMeContents[$index + 2] = $NewBodyContent
                        }
                        $hasBeenUpdated = $true
                        break;
                    }
                }

                if ($hasBeenUpdated -eq $False) {
                    $AppendageContent += @(
                        "",
                        $NewTitleLine,
                        "",
                        $NewBodyContent
                    )
                }
            }

            if ($AppendageContent.Count -gt 0) {
                Add-Content -Path $ReadMePath -Value $AppendageContent | Out-Null
            }
            else {
                Set-Content -Path $ReadMePath -Value $ReadMeContents | Out-Null
            }
            
        }
        catch {
            Write-Error "Unable to update README file."
        }
    }
}