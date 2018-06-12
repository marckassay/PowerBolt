
using module .\New-DynamicParam.ps1

function GetModuleNameSet {
    [CmdletBinding(PositionalBinding = $true)]
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Name = 'Name',

        [Parameter(Mandatory = $false)]
        [int]$Position,

        [Parameter(Mandatory = $false)]
        [string]$ParameterSetName,

        [switch]$Mandatory
    )

    [string[]]$ModuleNames = Get-Module -All | `
        Where-Object {$_.Guid -ne '00000000-0000-0000-0000-000000000000'} | `
        Select-Object -ExpandProperty Name

    # TODO: not sure why PSBoundParameters doesn't "see" $Name; forcing this parameter to be in
    # PSBoundParameters
    $PSBoundParameters.Add('Name', $Name)
    $PSBoundParameters.Add('ValidateSet', $ModuleNames)

    $DynamicParam = New-DynamicParam @PSBoundParameters
    $DynamicParam
}