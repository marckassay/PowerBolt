class MKPowerShellDocObject {
    [string]$ModuleName
    [string]$Path = (Get-Location | Select-Object -ExpandProperty Path)
    [string]$MarkdownFolder = 'docs'
    [string]$Locale = 'en-US'
    [string]$OnlineVersionUrl
    [string]$OnlineVersionUrlTemplate
    [string]$OnlineVersionUrlPolicy = 'Auto'
    [string]$MarkdownSnippetCollection
    [bool]$NoReImportModule
    [object]$RootManifest
    [object]$RootModule
    [string]$ModuleFolder
    [string]$ModuleMarkdownFolder

    # design for Update-ReadmeFromPlatyPSMarkdown
    MKPowerShellDocObject(
        [string]$Path,
        [string]$MarkdownFolder
    ) {
        $this.Path = Resolve-Path $Path
        $this.MarkdownFolder = $MarkdownFolder
        
        $this.AssignRemainingFields()
    }

    # design for New-ExternalHelpFromPlatyPSMarkdown
    MKPowerShellDocObject(
        [string]$Path,
        [string]$MarkdownFolder,
        [string]$Locale
    ) {
        $this.Path = Resolve-Path $Path
        $this.MarkdownFolder = $MarkdownFolder
        $this.Locale = $Locale
        
        $this.AssignRemainingFields()
    }

    # design for Build-Documentation and Build-PlatyPSMarkdown
    MKPowerShellDocObject(
        [string]$Name,
        [string]$Path,
        [string]$MarkdownFolder,
        [string]$Locale,
        [string]$OnlineVersionUrlTemplate,
        [string]$OnlineVersionUrlPolicy,
        [object]$MarkdownSnippetCollection,
        [bool]$NoReImportModule
    ) {
        $this.ModuleName = $Name
        $this.Path = Resolve-Path $Path
        $this.MarkdownFolder = $MarkdownFolder
        $this.Locale = $Locale
        $this.OnlineVersionUrlTemplate = $OnlineVersionUrlTemplate
        $this.OnlineVersionUrlPolicy = $OnlineVersionUrlPolicy
        $this.MarkdownSnippetCollection = $MarkdownSnippetCollection
        $this.NoReImportModule = $NoReImportModule
        
        $this.AssignRemainingFields()
    }

    [void]AssignRemainingFields() {
        if ($this.Name) {
            $this.ModuleFolder = Get-Module $this.Name | `
                Select-Object -ExpandProperty Path | `
                Split-Path -Parent
        } 
        elseif ($this.Path) {
            # if Path was provided (hopefully .ps1, .psm1 or .psd1) ...
            if ((Test-Path -Path $this.Path -PathType Leaf) -eq $True) {
                $this.ModuleFolder = Split-Path -Path $this.Path -Parent 
                $this.ModuleName = Split-Path -Path $this.Path -LeafBase 
            }
            else {
                $this.ModuleFolder = $this.Path
                $this.ModuleName = Split-Path -Path $this.Path -Leaf 
            }
        }

        $this.RootManifest = Get-ChildItem -Path $this.Path -Filter '*.psd1' | `
            Select-Object -ExpandProperty FullName

        $this.RootModule = Get-ChildItem -Path $this.Path -Filter '*.psm1' | `
            Select-Object -ExpandProperty FullName
        if (-not $this.RootModule) {
            $this.RootModule = Get-ChildItem -Path $this.Path -Filter '*.psm1' | `
                Select-Object -ExpandProperty FullName
        }

        $this.ModuleMarkdownFolder = Join-Path -Path ($this.ModuleFolder) -ChildPath ($this.MarkdownFolder)
    }

    # TODO: need to have this functions arity better fitted for options
    # TODO: removed the following but may need to have OnlineVersionUrlValue back as param:
    #       $OnlineVersionUrlValue -f $FunctionName
    #       $MarkdownContent -replace '^(online version:)[\w\W]*$', "online version: $MarkdownURL" | Set-Content -Path $_.FullName
    [object[]] GetMarkdownSnippetCollection () {
        
        [object[]]$Collection = Get-ChildItem -Path ($this.ModuleMarkdownFolder + "\*.md") | `
            ForEach-Object {
            $MarkdownContent = Get-Content -Path $_.FullName
            $FunctionName = $_.BaseName

            $MarkdownContent | Where-Object {$_ -match "(?<=online version: ).*"} | Out-Null
            $MarkdownURL = $Matches.Values

            # building content for README...
            $TitleLine = "### [``$FunctionName``]($MarkdownURL)"
            # get the line directly below the '## SYNOPSIS' line
            $BodyContent = $MarkdownContent[$MarkdownContent.IndexOf('## SYNOPSIS') + 1]

            $(@{
                    FunctionName = $FunctionName
                    TitleLine    = $TitleLine
                    BodyContent  = $BodyContent
                })
        } | Write-Output

        return $Collection
    }
}