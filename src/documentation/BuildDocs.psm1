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

function Build-PlatyPSDocs {
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
        [string]$ReadMeBeginBoundary = '## Functions',
        
        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = '## Roadmap',
        
        [switch]
        $NoReImportModule
    )
    
    $Data = [PsCustomObject]@{
        ModuleName                = $Name
        Path                      = Resolve-Path $Path
        MarkdownFolder            = $MarkdownFolder
        Locale                    = $Locale
        OnlineVersionUrl          = ''
        OnlineVersionUrlTemplate  = $OnlineVersionUrlTemplate
        OnlineVersionUrlPolicy    = $OnlineVersionUrlPolicy
        ReadMeBeginBoundary       = $ReadMeBeginBoundary
        ReadMeEndBoundary         = $ReadMeEndBoundary
        NoReImportModule          = $NoReImportModule.IsPresent
        RootModule                = $null
        ModuleFolder              = ''
        ModuleMarkdownFolder      = ''
        MarkdownSnippetCollection = $null
    }
    
    if ($Name) {
        $Data.ModuleFolder = Get-Module $Name | `
            Select-Object -ExpandProperty Path | `
            Split-Path -Parent
    } 
    elseif ($Path) {
        # if Path was provided (hopefully .ps1, .psm1 or .psd1) ...
        if ((Test-Path -Path $Path -PathType Leaf) -eq $True) {
            $Data.ModuleFolder = Split-Path -Path $Path -Parent 
            $Data.ModuleName = Split-Path -Path $Path -LeafBase 
        }
        else {
            $Data.ModuleFolder = $Path
            $Data.ModuleName = Split-Path -Path $Path -Leaf 
        }
    }

    $Data.RootModule = Get-ChildItem -Filter '*.psm1' | `
        Select-Object -ExpandProperty FullName
    if (-not $Data.RootModule) {
        $Data.RootModule = Get-ChildItem -Filter '*.psm1' | `
            Select-Object -ExpandProperty FullName
    }

    $Data | `
        Build-PlatyPSMarkdown | `
        New-ExternalHelpFromPlatyPSMarkdown | `
        Update-ReadmeFromPlatyPSMarkdown
}

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

function New-ExternalHelpFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [PSCustomObject]$Data
    )

    $HelpLocaleFolder = Join-Path -Path $Data.ModuleFolder -ChildPath $Data.Locale
    if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
        New-Item -Path $HelpLocaleFolder -ItemType Container
    }
    New-ExternalHelp -Path $Data.ModuleMarkdownFolder -OutputPath $HelpLocaleFolder -Force | `
        Out-Null
    
    $Data
}

function Update-ReadmeFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [PSCustomObject]$Data
    )
    
    try {
        $ReadMeContents = Get-FileObject -FilePath ($Data.ModuleFolder + "\README*")

        # check to see if ReadMeBeginBoundary exists, if not append it
        if (-not $($ReadMeContents.FileContent -match $Data.ReadMeBeginBoundary)) {
            $ReadMeContents.FileContent += @"


$($Data.ReadMeBeginBoundary)

"@
        }
        [regex]$InsertPointRegEx = "(?(?<=$($Data.ReadMeBeginBoundary))([\w\W]*?)|($))(?(?=$($Data.ReadMeEndBoundary))(?=$($Data.ReadMeEndBoundary))|($))"
        $ReadMeContents.FileContent = $InsertPointRegEx.Replace($ReadMeContents.FileContent, @"

$($Data.MarkdownSnippetCollection)

"@, 1)
        $ReadMeContents | Write-File | Out-Null
    }
    catch {
        Write-Error "Unable to update README file."
    }
}