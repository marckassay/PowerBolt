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

        [Parameter(Mandatory = $False)]
        [int]$Depth = 15,

        [switch]$Recurse
    )

    [hashtable[]]$Results = Get-ChildItem $Path -Include $Include -Exclude $Exclude -Depth $Depth -Recurse:$Recurse.IsPresent -PipelineVariable Fi -File | `
        Get-Content | `
        Select-String -Pattern $Pattern -PipelineVariable Ss | `
        ForEach-Object -Process {
        $Result = @{
            Item        = $Fi
            MatchedLine = $Ss.Line
            Match       = $Ss.Matches[0].Value.Trim()
        }
        $Result
    }

    $Results
}