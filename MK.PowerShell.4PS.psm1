Get-Content -Path (Resolve-Path -Path .\src\script\Import-Script.ps1) -Raw | Invoke-Expression
. .\src\manifest\Update-FunctionsToExport.ps1
. .\src\module\Update-ModuleDotSourceFunctions.ps1