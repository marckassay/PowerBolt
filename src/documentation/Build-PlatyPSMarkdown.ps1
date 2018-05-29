using module .\.\MKPowerShellDocObject.psm1

function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $False)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate,

        [Parameter(Mandatory = $False)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeBeginBoundary = '## Functions',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = '## Roadmap',

        [Parameter(Mandatory = $False)]
        [string]$MarkdownSnippetCollection,
        
        [switch]
        $NoReImportModule
    ) 
    
    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Name,
                $Path,
                $MarkdownFolder,
                $Locale,
                $OnlineVersionUrlTemplate,
                $OnlineVersionUrlPolicy,
                $ReadMeBeginBoundary,
                $ReadMeEndBoundary,
                $MarkdownSnippetCollection,
                $NoReImportModule.IsPresent
            )
        }
    }

    process {
        if ($Data.OnlineVersionUrlPolicy -eq 'Auto') {
            if ((Get-Content ($Data.ModuleFolder + "\.git\config") -Raw) -match "(?<=\[remote\s.origin.\])[\w\W]*[url\s\=\s](http.*)[\n][\w\W]*(?=\[)") {
                $Data.OnlineVersionUrl = $Matches[1].Split('.git')[0] + "/blob/master/docs/{0}.md"
            }
            else {
                Write-Error "The parameter 'OnlineVersionUrlPolicy' was set to 'Auto' but unable to retrieve Git repo config file.  Would you like to continue?" -ErrorAction Inquire
                $Data.OnlineVersionUrlPolicy = 'Omit'
            }
        }

        $Data.ModuleMarkdownFolder = Join-Path -Path $Data.ModuleFolder -ChildPath $Data.MarkdownFolder
    
        $PredicateA = ((Test-Path -Path $Data.ModuleMarkdownFolder -PathType Container) -eq $False)
        try {
            $PredicateB = ((Get-Item $Data.ModuleMarkdownFolder -ErrorAction SilentlyContinue).GetFiles().Count -eq 0)
        }
        catch {
            $PredicateB = $False
        }

        if ($PredicateA -or $PredicateB) {
            New-Item -Path $Data.ModuleMarkdownFolder -ItemType Container -Force | Out-Null

            if ($Data.NoReImportModule -eq $False) {
                Remove-Module -Name $Data.ModuleName
                Import-Module -Name $Data.RootManifest -Force -Scope Global
            }
            New-MarkdownHelp -Module $Data.ModuleName -OutputFolder $Data.ModuleMarkdownFolder -ErrorAction SilentlyContinue | Out-Null
        }
        else {
            if ($Data.NoReImportModule -eq $False) {
                Remove-Module -Name $Data.ModuleName
                Import-Module -Name $Data.RootManifest -Force -Scope Global
            }

            Get-ChildItem -Path "$($Data.Path)\src\" -Recurse -Include '*.ps1' | `
                Get-Item | `
                Get-Content -Raw | `
                ForEach-Object {
                $NoExportMatches = [regex]::Matches($_, '(?<=NoExport)(?:[:\s]*?)(?<sanitized>\w*-\w*)')
                $NoExportMatches | `
                    ForEach-Object {
                    $MarkdownPath = "$($Data.ModuleMarkdownFolder)\$($_.Groups['sanitized'].Value).md"
                    if ($(Test-Path $MarkdownPath -Verbose)) {
                        Remove-Item -Path $MarkdownPath -Confirm
                    }
                }
            }

            Update-MarkdownHelp $Data.ModuleMarkdownFolder -ErrorAction SilentlyContinue | Out-Null
        }
        $Data.MarkdownSnippetCollection = [MKPowerShellDocObject]::CreateMarkdownSnippetCollection($Data.ModuleMarkdownFolder, $Data.OnlineVersionUrl)
    }

    end {
        Write-Output $Data
    }
}