function New-MKPowerShellConfigFile {
    [CmdletBinding(SupportsPaging = $true)]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData),

        [switch]
        $PassThru
    )

    $FullName = Join-Path -Path $Path -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'MK.PowerShell-config.ps1'
    
    if ((Test-Path -Path $FullName) -eq $false) {
        Join-Path -Path $Path -ChildPath '\MK.PowerShell'
        New-Item -Path (Join-Path -Path $Path -ChildPath '\MK.PowerShell') -ItemType Directory -OutVariable ModuleConfigFolder

        Get-Module MK.PowerShell.4PS | `
            Select-Object -ExpandProperty FileList -OutVariable ModuleConfigFile

        Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName -PassThru:$PassThru.IsPresent -Verbose
    }
    else {

    }
}