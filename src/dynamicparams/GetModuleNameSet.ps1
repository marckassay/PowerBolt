
using module .\New-DynamicParam.ps1

function GetModuleNameSet {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Name = 'Name',

        [Parameter(Mandatory = $false)]
        [int]$Position = 0,

        [Parameter(Mandatory = $false)]
        [string]$ParameterSetName = 'ByName',

        [switch]$Mandatory,

        [switch]$ValueFromPipeline
    )

    [string[]]$ModuleNames = Get-Module -All | `
        Where-Object {$_.Guid -ne '00000000-0000-0000-0000-000000000000'} | `
        Select-Object -ExpandProperty Name
    $PSBoundParameters.Add('ValidateSet', $ModuleNames)
    
    if ($PSBoundParameters.ContainsKey('Name') -eq $false) {
        $PSBoundParameters.Add('Name', $Name)
    }
        
    if ($PSBoundParameters.ContainsKey('Position') -eq $false) {
        $PSBoundParameters.Add('Position', $Position)
    }
        
    if ($PSBoundParameters.ContainsKey('ParameterSetName') -eq $false) {
        $PSBoundParameters.Add('ParameterSetName', $ParameterSetName)
    }
        
    if ($PSBoundParameters.ContainsKey('Mandatory') -eq $false) {
        $PSBoundParameters.Add('Mandatory', $false)
    }
        
    if ($PSBoundParameters.ContainsKey('ValueFromPipeline') -eq $false) {
        $PSBoundParameters.Add('ValueFromPipeline', $false)
    }

    $DynamicParam = New-DynamicParam @PSBoundParameters
    $DynamicParam
}