function WriteWarningWrapper($FullName) {
    Write-Warning -Message @"
The following file already exists:`r`n
$FullName`r`n

If you wish to overwrite this file with the default 'MK.PowerShell-config.ps1' file, call this function with the -Force switch. 
"@
}

function New-MKPowerShellConfigFile {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData),

        [switch]
        $PassThru,

        [switch]
        $Force,

        [switch]
        $Confirm
    )

    $FullName = Join-Path -Path $Path -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
    
    if (((Test-Path -Path $FullName) -eq $false) -or ($Force.IsPresent -eq $True)) {
        $LeafBase = Join-Path -Path $Path -ChildPath '\MK.PowerShell\'
        if ((Test-Path -Path $LeafBase) -eq $false) {
            New-Item -Path $LeafBase -ItemType Directory -OutVariable ModuleConfigFolder
        }

        Get-Module MK.PowerShell.4PS | `
            Select-Object -ExpandProperty FileList | `
            ForEach-Object {if ($_ -like '*MK.PowerShell-config.ps1') {$_}} -OutVariable ModuleConfigFile

        Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -PassThru:$PassThru.IsPresent -Force:$Force.IsPresent  -Confirm:$Confirm.IsPresent
    }
    else {
        WriteWarningWrapper -FullName $FullName
    }
}