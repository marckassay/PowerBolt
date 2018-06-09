
using module .\New-DynamicParam.ps1

function GetModuleNameSet {

    $ModuleNames = Get-Module | Select-Object -ExpandProperty Name

    New-DynamicParam -Name 'Name' -ValidateSet $ModuleNames
}