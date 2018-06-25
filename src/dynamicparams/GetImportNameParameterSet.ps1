using module .\New-DynamicParam.ps1

function GetImportNameParameterSet {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ProfilePath,

        [Parameter(Mandatory = $True)]
        [ValidateSet("Uncomment", "Comment")]
        [String]
        $LineStatus,

        [Parameter(Mandatory = $False)]
        [int]$Position = 0,
        
        [switch]$ByPassForDocumentation,

        [switch]$Mandatory
    )

    $ProfileRaw = Get-Content -Path $ProfilePath -Raw
    if ($ProfileRaw) {
        if ($LineStatus -eq "Uncomment") {
            $ModuleBases = [regex]::Matches($ProfileRaw, "(?<=Import-Module ).*\\(\S*)") | ForEach-Object {$_.Groups[1].Value}
        }
        else {
            $ModuleBases = [regex]::Matches($ProfileRaw, "(?<=\# Import-Module ).*\\(\S*)") | ForEach-Object {$_.Groups[1].Value}
        }
    }

    New-DynamicParam -Name 'Name' -Position $Position -ValidateSet $ModuleBases -Mandatory:$Mandatory.IsPresent
}