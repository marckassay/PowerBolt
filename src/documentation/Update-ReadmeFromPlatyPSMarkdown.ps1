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