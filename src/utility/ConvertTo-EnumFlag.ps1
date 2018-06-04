# TODO: look into EnumConverter to see if it can be used here
# https://docs.microsoft.com/en-us/dotnet/api/system.componentmodel.enumconverter?view=netframework-4.7.1

# Must be called as the following (note the parentheses)
# ConvertTo-EnumFlag ([BackupPredicateEnum]::IsConfigFileValid)
function ConvertTo-EnumFlag {
    [CmdletBinding()]
    [OutputType([int])]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [psobject]$InputObject,

        [Parameter(Mandatory = $true, Position = 0)]
        [enum]$Value
    )
    if ($InputObject -eq $true) {
        Write-Output $Value
    }
    else {
        Write-Output 0
    }
}