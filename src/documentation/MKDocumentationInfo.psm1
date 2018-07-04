using module .\..\module\manifest\Get-GitBranchName.ps1
using module .\..\dynamicparams\GetModuleNameSet.ps1

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
    [object]$ManifestPath
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

        $this.ManifestPath = Get-ChildItem -Path $this.Path -Filter '*.psd1' | `
            Select-Object -ExpandProperty FullName

        $this.RootModule = Get-ChildItem -Path $this.Path -Filter '*.psm1' | `
            Select-Object -ExpandProperty FullName
        if (-not $this.RootModule) {
            $this.RootModule = Get-ChildItem -Path $this.Path -Filter '*.psm1' | `
                Select-Object -ExpandProperty FullName
        }

        $this.ModuleMarkdownFolder = Join-Path -Path ($this.ModuleFolder) -ChildPath ($this.MarkdownFolder)

        if ($this.OnlineVersionUrlPolicy -eq 'Auto') {
            
            $BranchName = Get-GitBranchName -Path ($this.ModuleFolder)
            
            if ((Get-Content ($this.ModuleFolder + "\.git\config") -Raw) -match "(?<=\[remote\s.origin.\])(?:\s*)(?:url\s\=\s)(?'url'http.*)") {
                # TODO: this most likely will only work with Github file structure
                # TODO: docs folders needs to be a variable
                $this.OnlineVersionUrl = $Matches.url.Split('.git')[0] + "/blob/$BranchName/docs/{0}.md"
            }
            else {
                Write-Error "The parameter 'OnlineVersionUrlPolicy' was set to 'Auto' but unable to retrieve Git repo config file. Would you like to continue?" -ErrorAction Inquire
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

    [void] UpdateVersionUrls ([bool]$AddSourceAndTestFileLinks) {
        # Since New-MarkdownHelp OnlineVersionUrl parameter is only available in a specific parameter
        # set that is not used here; below is to assign 'onlineverion' field.
        Get-ChildItem -Path $this.ModuleMarkdownFolder -Include '*.md' -Recurse | `
            ForEach-Object {
            $FileContent = Get-Content $_.FullName -Raw
        
            # replace any value after 'online version:' with OnlineVersionUrl 
            $FileUrl = $this.OnlineVersionUrl -f $_.BaseName
            $FileContent = [regex]::Replace($FileContent, "(?<=online version:).*", " $FileUrl")

            # update any other exisiting urls with branchname that similiarly matches OnlineVersionUrl without
            # overwriting filename
            $UrlSegmentPriorToGitBranchName = $FileUrl.Split('blob')[0] + 'blob'
            $script:GitBranchName = [regex]::Match($FileUrl, "(?<=$UrlSegmentPriorToGitBranchName[\\|\/])[^\/|\\]*")
            $FileContent = [regex]::Replace($FileContent, "(?<=$UrlSegmentPriorToGitBranchName[\\|\/])[^\/|\\]*", $GitBranchName)
            
            $RelatedLinksContent = [regex]::Match($FileContent, '(?<=## RELATED LINKS)[\w\W]*$').Value
            $RelatedLinksContent = $RelatedLinksContent.TrimStart()

            $FileName = $_.BaseName

            if ($AddSourceAndTestFileLinks -eq $True) {
                $SourceAndTestFileLinks = GetFileLink -FileName $FileName
                
                if ($FileContent.Contains("[$FileName.ps1]")) {
                    $SourceAndTestFileLinks = ""
                }

                $SourceAndTestFileLinks += GetFileLink -FileName "$FileName.Tests"

                if ($FileContent.Contains("[$FileName.Tests.ps1]")) {
                    $SourceAndTestFileLinks = ""
                }

                if ($SourceAndTestFileLinks -ne "") {
                    $NuRelatedLinksContent = @"
`n
$SourceAndTestFileLinks
$RelatedLinksContent
"@
                    $FileContent = [regex]::Replace($FileContent, '(?<=## RELATED LINKS)[\w\W]*$', $NuRelatedLinksContent)
                }
            }
            else {
                $SourceAndTestFileLinks = GetFileLink -FileName $FileName
                $SourceAndTestFileLinks += GetFileLink -FileName "$FileName.Tests"

                $FileContent = $FileContent.Replace($SourceAndTestFileLinks, "")
            }

            Set-Content -Path $_.FullName -Value $FileContent -NoNewline
        }
    }
}

function GetFileLink ([string]$FileName) {
    $ModuleName = $this.ModuleName
    $GitBranchName = $script:GitBranchName
    $FilePath = Get-ChildItem ($this.Path) -Recurse | Where-Object {$_ -like "$FileName.ps1"} | Select-Object -ExpandProperty FullName
    if ($FilePath) {
        $FilePath = [regex]::Match($FilePath, "(?<=$ModuleName[\\|\/]).*") | Select-Object -ExpandProperty Value
        $Url = $FileUrl.Split($GitBranchName)[0] + ("$GitBranchName/$FilePath").Replace('\', '/')
        return "[$FileName.ps1](" + $Url + ")`n`n"
    }
    else {
        return ""
    }
}