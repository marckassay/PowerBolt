using module .\..\dynamicparams\GetPlasterTemplateVarSet.ps1

# TODO: add Path and Name parameters so that the scaffold files can be added to rootmodule
function Install-Template {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByTemplatePath")]
    Param
    (
        [Parameter(Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByTemplatePath")]
        [string]$TemplatePath,

        [Parameter(Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByTemplateName")]
        [ValidateSet("NewScript", "NewModule")]
        [string]$TemplateName
    )

    DynamicParam {
        # when platyPS calls Install-Template need to manually give it a value. This value cannot be  
        # assigned to the param within Param parentheses since it has an undetermined count of 
        # parameters.
        if ((-not $TemplatePath) -and (-not $TemplateName)) {
            $script:TemplatePath = 'resources\templates\NewScript\plasterManifest_en-US.xml'
        }
        elseif ($TemplateName) {
            $ModuleHome = $MyInvocation.ScriptName | Split-Path -Parent | Split-Path -Parent | Split-Path -Parent
            $script:TemplatePath = Join-Path -Path $ModuleHome -ChildPath "resources\templates\$TemplateName\plasterManifest_en-US.xml"
        }
        elseif ($TemplatePath) {
            $script:TemplatePath = $TemplatePath
        }
        
        $TemplateVarDictionary = GetPlasterTemplateVarSet -Path $script:TemplatePath -ParameterSetName $PSCmdlet.ParameterSetName
        return $TemplateVarDictionary
    }

    end {
        $TemplateVarDictionary.GetEnumerator() | ForEach-Object {
            $Name = "PLASTER_PARAM_" + ($_.Key)
            $Value = $(($_.Value).Value)
            Set-Variable -Name $Name -Value $Value -Scope Global
        }

        $PlasterTemplateFolderPath = Split-Path -Path $script:TemplatePath -Parent

        if (-not $DestinationPath) {
            Invoke-Plaster -TemplatePath $PlasterTemplateFolderPath -DestinationPath '.'
        }
        else {
            Invoke-Plaster -TemplatePath $PlasterTemplateFolderPath -DestinationPath $DestinationPath
        }

        $TemplateVarDictionary.GetEnumerator() | ForEach-Object {
            $Name = "PLASTER_PARAM_" + ($_.Key)
            Remove-Variable -Name $Name -Scope Global
        }
    }
}