
function Search-Items {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $True)]
        [String]$Path,

        [Parameter(Mandatory = $True)]
        [String[]]$Pattern,

        [Parameter(Mandatory = $False)]
        [String[]]$Include,

        [Parameter(Mandatory = $False)]
        [String[]]$Exclude,

        [switch]$Recurse
    )

    Get-ChildItem $Path -Include $Include -Exclude $Exclude -Recurse:$Recurse.IsPresent -PipelineVariable Fi | `
        Get-Content | `
        Select-String -Pattern $Pattern -PipelineVariable Ss | `
        ForEach-Object {
        @"
Item: $($Fi.FullName)
$Ss.Line

"@
    }
}