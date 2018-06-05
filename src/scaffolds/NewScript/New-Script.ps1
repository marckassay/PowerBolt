function New-Script {
    Param (
        [Parameter(Mandatory = $true,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SrcChildPath,

        [Parameter(Mandatory = $false,
            Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path = (Resolve-Path -Path $(Get-Location))
    )
    $TemplatePath = Join-Path -Path $(GetTemplatePath) -ChildPath 'src\scaffolds\NewScript'

    $Path = Resolve-Path -Path $Path

    $NewScriptFolderPath = Join-Path -Path $Path -ChildPath $SrcChildPath
    if ((Test-Path $NewScriptFolderPath) -eq $false) {
        New-Item $NewScriptFolderPath -ItemType Directory | Out-Null
    }

    $CongruentPath = $SrcChildPath.Split('src')[1].TrimStart('\/')

    $NewScriptTestFolderPath = Join-Path -Path $Path -ChildPath 'test' -AdditionalChildPath $CongruentPath
    if ((Test-Path $NewScriptTestFolderPath) -eq $false) {
        New-Item $NewScriptTestFolderPath -ItemType Directory | Out-Null
    }

    Set-Variable -Name 'PLASTER_PARAM_ScriptName' -Value $Name -Scope Global
    Set-Variable -Name 'PLASTER_PARAM_ScriptCongruentPath' -Value $CongruentPath -Scope Global
    
    Invoke-Plaster -TemplatePath $TemplatePath -DestinationPath $Path
}

# this function is needed so that $MyInvocation has a value
function GetTemplatePath {
    $ModuleHome = $MyInvocation.ScriptName | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
    return $ModuleHome
}