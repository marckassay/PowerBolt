function WriteWarningWrapper($FullName) {
    Write-Warning -Message @"
The following file already exists:`r`n
$FullName`r`n

If you wish to overwrite this file with the default 'MK.PowerShell-config.json' file, call this function with the -Force switch. 
"@
}

function New-MKPowerShellConfigFile {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false)]
        [string]$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData),

        [switch]
        $PassThru,

        [switch]
        $Force,

        [switch]
        $Confirm
    )

    $FullName = Join-Path -Path $Path -ChildPath '\MK.PowerShell\MK.PowerShell-config.json'
    
    if (((Test-Path -Path $FullName) -eq $false) -or ($Force.IsPresent -eq $true)) {
        $LeafBase = Join-Path -Path $Path -ChildPath '\MK.PowerShell\'
        if ((Test-Path -Path $LeafBase) -eq $false) {
            New-Item -Path $LeafBase -ItemType Directory -OutVariable ModuleConfigFolder
        }

        Get-Module MK.PowerShell.Flow | `
            Select-Object -ExpandProperty FileList | `
            ForEach-Object {if ($_ -like '*MK.PowerShell-config.json') {$_}} -OutVariable ModuleConfigFile

        Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -PassThru:$PassThru.IsPresent -Force:$Force.IsPresent  -Confirm:$Confirm.IsPresent
    }
    else {
        WriteWarningWrapper -FullName $FullName
    }
}