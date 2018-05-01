function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [PSCustomObject]$Data
    )

    if ($Data.OnlineVersionUrlPolicy -eq 'Auto') {
        if ((Get-Content ($Data.ModuleFolder + "\.git\config") -Raw) -match "(?<=\[remote\s.origin.\])[\w\W]*[url\s\=\s](http.*)[\n][\w\W]*(?=\[)") {
            $Data.OnlineVersionUrl = $Matches[1].Split('.git')[0] + "/blob/master/docs/{0}.md"
        }
        else {
            Write-Error "The parameter 'OnlineVersionUrlPolicy' was set to 'Auto' but unable to retrieve Git repo config file." -ErrorAction Inquire
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
        New-Item -Path $Data.ModuleMarkdownFolder -ItemType Container -Force

        if ($Data.NoReImportModule -eq $False) {
            Import-Module $Data.RootModule -Force

            "restarting"
            Start-Sleep -Seconds 3
            "started"
        }
        New-MarkdownHelp -Module $Data.ModuleName -OutputFolder $Data.MarkdownFolder
    }
    else {
        if ($Data.NoReImportModule -eq $False) {
            Import-Module $Data.RootModule -Force
            Start-Sleep -Seconds 3
        }
        Update-MarkdownHelp $Data.MarkdownFolder
    }

    [string]$Data.MarkdownSnippetCollection = Get-ChildItem -Path ($Data.ModuleMarkdownFolder + "\*.md") | ForEach-Object {
        $FileContents = Get-Content -Path $_.FullName
        $FunctionName = $_.BaseName
        $MarkdownURL = $Data.OnlineVersionUrl -f $FunctionName

        # replace 'online version' value in markdown help file
        $FileContents -replace '^(online version:)[\w\W]*$', "online version: $MarkdownURL" | Set-Content -Path $_.FullName

        # building content for README...
        $TitleLine = ("### [``````$FunctionName``````]($MarkdownURL)").Trim()
        $SynopsisLine = $FileContents[$FileContents.IndexOf('## SYNOPSIS') + 1]

        # this here-string indents $SynopsisLine by four spaces so that it resides in a rectanglar background
        @"

$TitleLine

    $SynopsisLine

"@
    }

    $Data
}