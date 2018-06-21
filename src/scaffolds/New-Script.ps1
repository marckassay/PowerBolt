using module .\..\dynamicparams\GetPlasterTemplateVarSet.ps1

# TODO: add Path and Name parameters so that the scaffold files can be added to rootmodule
function New-Script {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByTemplate")]
    Param
    (
        [Parameter(Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByTemplate")]
        [string]$PlasterTemplatePath
    )
    
    DynamicParam {
        # when platyPS calls New-Script need to manually give it a value.  This value cannot be  
        # assigned to the param within Parma parentheses since it has an undetermined count of 
        # parameters.
        if (-not $PlasterTemplatePath) {
            $PlasterTemplatePath = 'resources\templates\NewScript\plasterManifest_en-US.xml'
        }

        $TemplateVarDictionary = GetPlasterTemplateVarSet -Path $PlasterTemplatePath
        return $TemplateVarDictionary
    }

    end {
        $TemplateVarDictionary.GetEnumerator() | ForEach-Object {
            $Name = "PLASTER_PARAM_" + ($_.Key)
            $Value = $(($_.Value).Value)
            Set-Variable -Name $Name -Value $Value -Scope Global
            if ($Name.EndsWith('Path') -eq $true) {
                New-Item $_ -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
            }
        }
        
        $PlasterTemplateFolderPath = Split-Path -Path $PlasterTemplatePath -Parent
        Invoke-Plaster -TemplatePath $PlasterTemplateFolderPath -DestinationPath '.'

        $TemplateVarDictionary.GetEnumerator() | ForEach-Object {
            $Name = "PLASTER_PARAM_" + ($_.Key)
            Remove-Variable -Name $Name -Scope Global
        }
    }
}