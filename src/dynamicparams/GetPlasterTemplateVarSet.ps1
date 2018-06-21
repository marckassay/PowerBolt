using module .\New-DynamicParam.ps1

function GetPlasterTemplateVarSet {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.RuntimeDefinedParameterDictionary])]
    Param(
        [Parameter(Mandatory = $false)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$ParameterSetName = 'ByTemplate'
    )
    
    $PlasterTemplateRaw = Get-Content -Path $Path -Raw
    $PlasterParams = [regex]::Matches($PlasterTemplateRaw , "(?<={PLASTER_PARAM_).*?(?=})") | Select-Object -ExpandProperty Value -Unique
    
    $Dictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

    # start position at 1; since there New-Script has a param already at that index
    $PlasterParams | ForEach-Object -Begin {$Position = 1} -Process {
        # the PLASTER_PARAM_Name variable is required, but not used here. its in place to bypass 
        # being prompt in the CLI
        if ($_ -ne 'Name') {
            $Position++ 
            New-DynamicParam -DPDictionary $Dictionary -Name $_ -Position $Position -ParameterSetName $ParameterSetName -Mandatory 
        }
    }
    
    $Dictionary
}