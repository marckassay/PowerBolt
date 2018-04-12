function Build-Docs {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Name,
        
        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = '.\docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US'<#,
        [Parameter(Mandatory = $False)]
        [string]$ReadMeInsertPoint = "## Usage",

        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate = 'https://github.com/{username}/{reponame}/blob/master/docs/{functionname}.md',

        [Parameter(Mandatory = $False)]
        [string[]]$Exclude,

        [Parameter(Mandatory = $False)]
        [string[]]$Include,

        [switch]
        $NoOnlineVersionUrl 
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
        # if file was provided (hopefully .ps1, .psm1 or .psd1)...
        if ((Test-Path -Path $Path -PathType Leaf) -eq $True) {
            $ModuleFolder = Split-Path -Path $Path -Parent 
            $ModuleName = Split-Path -Path $Path -LeafBase 
        }
        else {
            $ModuleFolder = $Path
            $ModuleName = Split-Path -Path $Path -Leaf 
        }
    }
    
    $ModuleMarkdownFolder = Join-Path -Path $ModuleFolder -ChildPath $MarkdownFolder
    
    $PredicateA = ((Test-Path -Path $ModuleMarkdownFolder -PathType Container) -eq $False)
    try {
        $PredicateB = ((Get-Item $ModuleMarkdownFolder -ErrorAction SilentlyContinue ).GetFiles().Count -eq 0)
    }
    catch {
        $PredicateB = $False
    }

    # Part 2 - markdown files
    if ($PredicateA -or $PredicateB) {
        New-Item -Path $ModuleMarkdownFolder -ItemType Container -Force

        Import-Module $RootModule -Force -ArgumentList $(Get-Variable PSScriptRoot -ValueOnly)
        New-MarkdownHelp -Module $ModuleName -OutputFolder $MarkdownFolder
    }
    else {
        Import-Module $RootModule -Force -ArgumentList $(Get-Variable PSScriptRoot -ValueOnly)
        Update-MarkdownHelp $MarkdownFolder
    }
 
    $MarkdownSnippetCollection = Get-ChildItem -Path "$ModuleMarkdownFolder\*.md" | ForEach-Object {
        $FileContents = Get-Content -Path $_.FullName
        
        @{
            Name     = $_.BaseName
            Synopsis = $FileContents[$FileContents.IndexOf('## SYNOPSIS') + 1]
        }
    }
    
    # Part 3 - help maml
    $HelpLocaleFolder = Join-Path -Path $ModuleFolder -ChildPath $Locale
    if ((Test-Path -Path $HelpLocaleFolder -PathType Container) -eq $False) {
        New-Item -Path $HelpLocaleFolder -ItemType Container
    }
    New-ExternalHelp -Path $ModuleMarkdownFolder -OutputPath $HelpLocaleFolder -Force

    # Part 4 - update README with markdown snippets
    <#
    [string]$ReadMeContents = Get-Content -Path "$ModuleFolder\README*"
     $StartInsert = $ReadMeContents.IndexOf($ReadMeInsertPoint) + 1
    $EndInsert = $ReadMeContents.IndexOf('## Roadmap') - 1

    $ReadMeContents.Remove($StartInsert, ($EndInsert - $StartInsert))
    $ReadMeContents.Insert($StartInsert, $MarkdownSnippetCollection) 
    #>
    Out-File -FilePath "$ModuleFolder\README*" -InputObject $MarkdownSnippetCollection -Append
}
Build-Docs