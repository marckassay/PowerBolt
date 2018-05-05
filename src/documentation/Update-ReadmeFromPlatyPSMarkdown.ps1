function Update-ReadmeFromPlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$ReadMeBeginBoundary = '## Functions',

        [Parameter(Mandatory = $False)]
        [string]$ReadMeEndBoundary = '## RoadMap'
    )
    
    if ($Data) {
        $Path = $Data.ModuleFolder 
        $MarkdownFolder = $Data.ModuleMarkdownFolder
        $ReadMeBeginBoundary = $Data.ReadMeBeginBoundary
        $ReadMeEndBoundary = $Data.ReadMeEndBoundary
    }

    try {
        $ReadMeContents = Get-FileObject -FilePath ($Path + "\README*")

        # check to see if ReadMeBeginBoundary exists, if not append it
        if (-not $($ReadMeContents.FileContent -match $ReadMeBeginBoundary)) {
            $ReadMeContents.FileContent += @"


$($ReadMeBeginBoundary)

"@
        }
        [regex]$InsertPointRegEx = "(?(?<=$($ReadMeBeginBoundary))([\w\W]*?)|($))(?(?=$($ReadMeEndBoundary))(?=$($ReadMeEndBoundary))|($))"
        $ModuleMarkdownPath = Join-Path -Path $Path -ChildPath $MarkdownFolder
        $MarkdownSnippetCollection = [MKPowerShellDocObject]::CreateMarkdownSnippetCollection($ModuleMarkdownPath, '')
        $ReadMeContents.FileContent = $InsertPointRegEx.Replace($ReadMeContents.FileContent, @"

$MarkdownSnippetCollection

"@, 1)
        $ReadMeContents | Write-File | Out-Null
    }
    catch {
        Write-Error "Unable to update README file."
    }
}