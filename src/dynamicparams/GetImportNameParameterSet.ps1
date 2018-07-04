using module .\New-DynamicParam.ps1

function GetImportNameParameterSet {
    [CmdletBinding(PositionalBinding = $false)]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$ProfilePath,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Uncomment", "Comment")]
        [String]
        $LineStatus,

        [Parameter(Mandatory = $false)]
        [int]$Position = 0,
        
        [switch]$ByPassForDocumentation,

        [switch]$Mandatory
    )

    $ProfileRaw = Get-Content -Path $ProfilePath -Raw
    if ($ProfileRaw) {
        if ($LineStatus -eq "Uncomment") {
            $ModuleBases = [regex]::Matches($ProfileRaw, "^\s*(?<!\#)\s*(?:Import-Module).*[\\|\/](?<ModuleName>\S*)", [System.Text.RegularExpressions.RegexOptions]::Multiline) | `
                ForEach-Object {$_.Groups['ModuleName'].Value}
        }
        else {
            $ModuleBases = [regex]::Matches($ProfileRaw, "[\#]+\s*(?:Import-Module).*[\\|\/](?<ModuleName>\S*)") | `
                ForEach-Object {$_.Groups['ModuleName'].Value}
        }
    }

    New-DynamicParam -Name 'Name' -Position $Position -ValidateSet $ModuleBases -Mandatory:$Mandatory.IsPresent
}