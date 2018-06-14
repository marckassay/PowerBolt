class MKDocumentationInfo {
    [string]$ModuleName
    [string]$Path
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
    static [string]$SemVerRegExPattern = "(?'MAJOR'0|(?:[1-9]\d*))\.(?'MINOR'0|(?:[1-9]\d*))\.(?'PATCH'0|(?:[1-9]\d*))(?:-(?'prerelease'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?(?:\+(?'build'(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*))(?:\.(?:0|(?:[1-9A-Za-z-][0-9A-Za-z-]*)))*))?"

    # design for Update-ReadmeFromPlatyPSMarkdown
    MKDocumentationInfo(
        [string]$Name,
        [string]$Path,
        [string]$MarkdownFolder
    ) {
        $this.ModuleName = $Name
        $this.Path = $Path
        $this.MarkdownFolder = $MarkdownFolder
        
        $this.AssignRemainingFields()
    }

    # design for New-ExternalHelpFromPlatyPSMarkdown
    MKDocumentationInfo(
        [string]$Name,
        [string]$Path,
        [string]$MarkdownFolder,
        [string]$Locale
    ) {
        $this.ModuleName = $Name
        $this.Path = $Path
        $this.MarkdownFolder = $MarkdownFolder
        $this.Locale = $Locale
        
        $this.AssignRemainingFields()
    }

    # design for Build-Documentation and Build-PlatyPSMarkdown
    MKDocumentationInfo(
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
        $this.Path = $Path
        $this.MarkdownFolder = $MarkdownFolder
        $this.Locale = $Locale
        $this.OnlineVersionUrlTemplate = $OnlineVersionUrlTemplate
        $this.OnlineVersionUrlPolicy = $OnlineVersionUrlPolicy
        $this.MarkdownSnippetCollection = $MarkdownSnippetCollection
        $this.NoReImportModule = $NoReImportModule
        
        $this.AssignRemainingFields()
    }

    [void]AssignRemainingFields() {
        if ($this.ModuleName) {
            $this.ModuleFolder = Get-Module $this.ModuleName | `
                Select-Object -ExpandProperty Path | `
                Split-Path -Parent
        } 
        else {
            if (-not $this.Path) {
                $this.Path = '.'
            }
            $this.Path = Resolve-Path $this.Path.TrimEnd('\', '/') | Select-Object -ExpandProperty Path

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

        if ($this.OnlineVersionUrlPolicy -eq 'Auto') {
            
            $BranchName = Get-GitBranch -gitDir ($this.ModuleFolder + "\.git").Trim('(', ')')
            if ($BranchName -match [MKDocumentationInfo]::SemVerRegExPattern) {
                if ((Get-Content ($this.ModuleFolder + "\.git\config") -Raw) -match "(?<=\[remote\s.origin.\])[\w\W]*[url\s\=\s](http.*)[\n][\w\W]*(?=\[)") {
                    # TODO: this most likely will only work with Github file structure
                    $this.OnlineVersionUrl = $Matches[1].Split('.git')[0] + "/blob/$BranchName/docs/{0}.md"
                }
            }
            else {
                Write-Error "The parameter 'OnlineVersionUrlPolicy' was set to 'Auto' but unable to retrieve Git repo config file.  Would you like to continue?" -ErrorAction Inquire
                $this.OnlineVersionUrlPolicy = 'Omit'
            }
        }
    }

    # TODO: need to have this functions arity better fitted for options
    # TODO: removed the following but may need to have OnlineVersionUrlValue back as param:
    #       $OnlineVersionUrlValue -f $FunctionName
    # TODO: use StringBuilder here
    [string] GetMarkdownSnippetCollectionString () {
        
        [string]$SnippetCollectionString += Get-ChildItem -Path ($this.ModuleMarkdownFolder + "\*.md") | `
            ForEach-Object {
            $MarkdownContent = Get-Content -Path $_.FullName
            $FunctionName = $_.BaseName

            $MarkdownContent | Where-Object {$_ -match "(?<=online version: ).*"} | Out-Null
            $MarkdownURL = $Matches.Values

            # building content for README...
            $TitleLine = "#### [``$FunctionName``]($MarkdownURL)"
            # get the line directly below the '## SYNOPSIS' line
            $BodyContent = $MarkdownContent[$MarkdownContent.IndexOf('## SYNOPSIS') + 1]

            $Snippet = @"
`n
$TitleLine

$BodyContent
"@
            $Snippet
        } | Write-Output

        return $SnippetCollectionString
    }

    [void] UpdateOnlineVersionUrl () {
        # Since New-MarkdownHelp OnlineVersionUrl parameter is only available in a specific parameter
        # set that is not used here; below is to assign 'onlineverion' field.
        Get-ChildItem -Path $this.ModuleMarkdownFolder -Include '*.md' -Recurse | `
            ForEach-Object {
            $FileContent = Get-Content $_.FullName -Raw
        
            # replace any value after 'online version:' with OnlineVersionUrl 
            $FileUrl = $this.OnlineVersionUrl -f $_.BaseName
            $FileContent = [regex]::Replace($FileContent, "(?<=online version:).*", " $FileUrl")

            # update any other exisiting urls that similiarly matches OnlineVersionUrl without
            # overwriting filename
            $UrlSegmentPriorToGitBranchName = $FileUrl.Split('blob')[0] + 'blob'
            $SemVerMatched = [regex]::Match($FileUrl, [MKDocumentationInfo]::SemVerRegExPattern)
     
            if ($SemVerMatched.Success) {
                $MDFolder = $this.MarkdownFolder
                $FileContent = [regex]::Replace($FileContent, "(?<=$UrlSegmentPriorToGitBranchName[\\|\/]).*?(?=[\\|\/]$MDFolder)", $SemVerMatched.Value)
            }
        
            Set-Content -Path $_.FullName -Value $FileContent -NoNewline
        }
    }
}