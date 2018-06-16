using module .\..\dynamicparams\GetPlasterTemplateVarSet.ps1
function New-Script {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByTemplate")]
    Param
    (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByTemplate")]
        [string]$PlasterTemplatePath = 'resources\templates\NewScript\plasterManifest_en-US.xml'
    )
    
    DynamicParam {
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