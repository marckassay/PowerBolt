function Get-FileObject {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [switch]$WhatIf
    )

    $Data = [PsCustomObject]@{
        FileItem               = $null
        FileContent            = ''
        FileEOL                = ''
        FileEncoding           = $null
        EncodingNotCompatiable = $false
        SameEOLAsRequested     = $false
        EmptyFile              = $false
        EndsWithEmptyNewLine   = $false
        Modified               = $false
        WhatIf                 = $WhatIf.IsPresent
    }
    
    Write-Verbose ("Opening: " + $FilePath)
    $Data.FileItem = Get-Item -Path $FilePath

    # unicode: U+000D | byte (decimal): 13 | html: \r\n | powershell: `r`n
    [byte]$CR = 0x0D
    # unicode: U+000A | byte (decimal): 10 | html: \n | powershell: `n
    [byte]$LF = 0x0A
    # TODO: would be nice to pipe StreamReader into Test-Encoding...
    $Data.EncodingNotCompatiable = !(Test-Encoding -Path $Data.FileItem.FullName 'utf8')

    if ($Data.EncodingNotCompatiable -eq $false) {

        $StreamReader = New-Object -TypeName System.IO.StreamReader -ArgumentList $Data.FileItem.FullName
            
        $Data.FileEncoding = $StreamReader.CurrentEncoding
            
        if ($Data.FileEncoding -is [System.Text.UTF8Encoding]) {
            
            $Data.FileContent = $StreamReader.ReadToEnd()
            
            $FileAsBytes = [System.Text.Encoding]::UTF8.GetBytes($Data.FileContent)
            $FileAsBytesLength = $FileAsBytes.Length
        }

        $IndexOfLF = $FileAsBytes.IndexOf($LF)
        if (($IndexOfLF -ne -1) -and ($FileAsBytes[$IndexOfLF - 1] -ne $CR)) {
            $Data.FileEOL = 'LF'
            if ($FileAsBytesLength) {
                $Data.EndsWithEmptyNewLine = ($FileAsBytes.Get($FileAsBytesLength - 1) -eq $LF) -and `
                ($FileAsBytes.Get($FileAsBytesLength - 2) -eq $LF)
            }
        }
        elseif (($IndexOfLF -ne -1) -and ($FileAsBytes[$IndexOfLF - 1] -eq $CR)) {
            $Data.FileEOL = 'CRLF'
            if ($FileAsBytesLength) {
                $Data.EndsWithEmptyNewLine = ($FileAsBytes.Get($FileAsBytesLength - 1) -eq $LF) -and `
                ($FileAsBytes.Get($FileAsBytesLength - 3) -eq $LF)
            }
        }
        else {
            $Data.FileEOL = 'unknown'
        }
            
        $StreamReader.Close()
    }

    $Data
}

function Write-File {
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]$Data
    )

    if (($Data.EmptyFile -eq $false) -and `
        ($Data.EncodingNotCompatiable -eq $false)) {
 
        if ($Data.WhatIf -eq $false) {
            New-Object -TypeName System.IO.StreamWriter -ArgumentList $Data.FileItem.FullName -OutVariable StreamWriter | Out-null

            try {
                $StreamWriter.Write($Data.FileContent)
                $StreamWriter.Flush()
                $StreamWriter.Close()
            }
            catch {
                Write-Error ("EndOfLine threw an exception when writing to: " + $Data.FileItem.FullName)
            }
        }
        $Data.Modified = $true
    }
    # free-up memory; no longer need FileContent data
    $Data.FileContent = '[removed]'
    
    $Data
}

function Build-Docs {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Name,
        
        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate,

        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeBeginBoundary = "## Functions",
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = "## Roadmap",
        
        [switch]
        $NoReImportModule
        <#,
        [Parameter(Mandatory = $False)]
        [string[]]$Exclude,

        [Parameter(Mandatory = $False)]
        [string[]]$Include,
        #>
    )

    # Part 1 - obtain info about module and/or path
    $ModuleFolder
    $ModuleName = $Name 

    $RootModule = Get-ChildItem -Path $ModuleFolder  -Include '*.psm1' -Recurse | `
        Select-Object -ExpandProperty Name | `
        Resolve-Path | `
        Select-Object -ExpandProperty Path

    if ($Name) {
        $ModuleFolder = Get-Module $Name | Select-Object -ExpandProperty Path | Split-Path -Parent
    } 
    elseif ($Path) {
        # if file was provided (hopefully .ps1, .psm1 or .psd1) ...
        if ((Test-Path -Path $Path -PathType Leaf) -eq $True) {
            $ModuleFolder = Split-Path -Path $Path -Parent 
            $ModuleName = Split-Path -Path $Path -LeafBase 
        }
        else {
            $ModuleFolder = $Path
            $ModuleName = Split-Path -Path $Path -Leaf 
        }
    }

    if ($OnlineVersionUrlPolicy -eq 'Auto') {
        if ((Get-Content "$ModuleFolder\.git\config" -Raw) -match "(?<=\[remote\s.origin.\])[\w\W]*[url\s\=\s](http.*)[\n][\w\W]*(?=\[)") {
            $OnlineVersionUrlTemplate = $Matches[1].Split('.git')[0] + "/blob/master/docs/{0}.md"
        }
        else {
            Write-Error "The parameter 'OnlineVersionUrlPolicy' was set to 'Auto' but unable to retrieve Git repo config file." -ErrorAction Inquire
        }
    }

    # Part 2 - markdown files
    $ModuleMarkdownFolder = Join-Path -Path $ModuleFolder -ChildPath $MarkdownFolder
    
    $PredicateA = ((Test-Path -Path $ModuleMarkdownFolder -PathType Container) -eq $False)
    try {
        $PredicateB = ((Get-Item $ModuleMarkdownFolder -ErrorAction SilentlyContinue ).GetFiles().Count -eq 0)
    }
    catch {
        $PredicateB = $False
    }

    if ($PredicateA -or $PredicateB) {
        New-Item -Path $ModuleMarkdownFolder -ItemType Container -Force

        if ($NoReImportModule.IsPresent -eq $False) {
            Import-Module $RootModule -Force
            Start-Sleep -Seconds 3
        }
        New-MarkdownHelp -Module $ModuleName -OutputFolder $MarkdownFolder
    }
    else {
        if ($NoReImportModule.IsPresent -eq $False) {
            Import-Module $RootModule -Force
            Start-Sleep -Seconds 3
        }
        Update-MarkdownHelp $MarkdownFolder
    }
 
    [string]$MarkdownSnippetCollection = Get-ChildItem -Path "$ModuleMarkdownFolder\*.md" | ForEach-Object {
        $FileContents = Get-Content -Path $_.FullName
        $FunctionName = $_.BaseName
        $MarkdownURL = $OnlineVersionUrlTemplate -f $FunctionName
        
        $TitleLine = "### [``````$FunctionName``````]($MarkdownURL)"
        $SynopsisLine = $FileContents[$FileContents.IndexOf('## SYNOPSIS') + 1]

        # this here-string indents $SynopsisLine by four spaces so that it resides in a rectanglar background
        @"

$TitleLine

    $SynopsisLine
"@ | Out-String
    }
    
    # Part 3 - help maml
    $HelpLocaleFolder = Join-Path -Path $ModuleFolder -ChildPath $Locale
    if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
        New-Item -Path $HelpLocaleFolder -ItemType Container
    }
    New-ExternalHelp -Path $ModuleMarkdownFolder -OutputPath $HelpLocaleFolder -Force

    # Part 4 - update README with markdown snippets
    $ReadMeContents = Get-FileObject -FilePath "$ModuleFolder\README*"
    $ReadMeRegEx = "(?(?<=$ReadMeBeginBoundary)([\w\W]*?)|($))(?(?=$ReadMeEndBoundary)()|($))"
    if ($ReadMeContents.FileContent -match $ReadMeRegEx) {
        $ReadMeContents.FileContent = ($ReadMeContents.FileContent -replace $ReadMeRegEx, @"

$MarkdownSnippetCollection

"@ | Out-String)
        $ReadMeContents | Write-File | Out-Null
    }
    else {
        Write-Error "Unable to update README file."
    }
}
Build-Docs