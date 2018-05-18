# TODO: look into EnumConverter to see if it can be used here
# https://docs.microsoft.com/en-us/dotnet/api/system.componentmodel.enumconverter?view=netframework-4.7.1
function ConvertTo-EnumFlag {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [psobject]$InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [System.ComponentModel.EnumConverter]$Value
    )
    if ($InputObject) {
        Write-Output $Value
    }
    else {
        Write-Output 0
    }
}