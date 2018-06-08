
using module .\New-DynamicParam.ps1

function GetModuleNameSet {

    $ModuleNames = Get-Module | Select-Object -ExpandProperty Name

    New-DynamicParam -Name 'Name' -Mandatory -Position 0 -ValidateSet $ModuleNames
}