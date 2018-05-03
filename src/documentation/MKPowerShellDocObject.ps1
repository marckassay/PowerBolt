class MKPowerShellDocObject {
    [string]$ModuleName
    [string]$Path = (Get-Location | Select-Object -ExpandProperty Path)
    [string]$MarkdownFolder = 'docs'
    [string]$Locale = 'en-US'
    [string]$OnlineVersionUrl
    [string]$OnlineVersionUrlTemplate
    [string]$OnlineVersionUrlPolicy = 'Auto'
    [string]$ReadMeBeginBoundary = '## Functions'
    [string]$ReadMeEndBoundary = '## RoadMap'
    [string]$MarkdownSnippetCollection
    [bool]$NoReImportModule
    [object]$RootManifest
    [object]$RootModule
    [string]$ModuleFolder
    [string]$ModuleMarkdownFolder

    MKPowerShellDocObject(
        [string]$Name,
        [string]$Path,
        [string]$MarkdownFolder,
        [string]$Locale,
        [string]$OnlineVersionUrlTemplate,
        [string]$OnlineVersionUrlPolicy,
        [string]$ReadMeBeginBoundary,
        [string]$ReadMeEndBoundary,
        [string]$MarkdownSnippetCollection,
        [bool]$NoReImportModule
    ) {
        $this.ModuleName = $Name
        $this.Path = Resolve-Path $Path
        $this.MarkdownFolder = $MarkdownFolder
        $this.Locale = $Locale
        $this.OnlineVersionUrlTemplate = $OnlineVersionUrlTemplate
        $this.OnlineVersionUrlPolicy = $OnlineVersionUrlPolicy
        $this.ReadMeBeginBoundary = $ReadMeBeginBoundary
        $this.ReadMeEndBoundary = $ReadMeEndBoundary
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
    }

    static [string]CreateMarkdownSnippetCollection ([string]$Path, [string]$OnlineVersionUrlValue = '') {
        
        $_MarkdownSnippetCollection = Get-ChildItem -Path ($Path + "\*.md") | ForEach-Object {
            $FileContents = Get-Content -Path $_.FullName
            $FunctionName = $_.BaseName
            $MarkdownURL = $OnlineVersionUrlValue -f $FunctionName

            # replace 'online version' value in markdown help file
            $FileContents -replace '^(online version:)[\w\W]*$', "online version: $MarkdownURL" | Set-Content -Path $_.FullName

            # building content for README...
            $TitleLine = ("### [``````$FunctionName``````]($MarkdownURL)").Trim()
            $SynopsisLine = $FileContents[$FileContents.IndexOf('## SYNOPSIS') + 1]

            # this here-string indents $SynopsisLine by four spaces so that it will be rendered in
            # a rectanglar background shadow
            @"

$TitleLine

    $SynopsisLine

"@
        }

        return $_MarkdownSnippetCollection
    }
}