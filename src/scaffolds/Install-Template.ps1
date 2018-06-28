using module .\..\dynamicparams\GetPlasterTemplateVarSet.ps1
using module .\..\module\Get-MKModuleInfo.ps1

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
        [ValidateSet("NewScript", "NewModuleProject")]
        [string]$TemplateName
    )

    DynamicParam {
        # when platyPS calls Install-Template need to manually give it a value. This value cannot be  
        # assigned to the param within Param parentheses since it has an undetermined count of 
        # parameters.
        if ((-not $TemplatePath) -and (-not $TemplateName)) {
            $script:TemplatePath = 'resources\templates\NewScript\plasterManifest_en-US.xml'
        }
        elseif ($PSCmdlet.ParameterSetName -eq "ByTemplateName") {
            $script:TemplatePath = Join-Path -Path $FLOWPATH -ChildPath "resources\templates\$TemplateName\plasterManifest_en-US.xml"
        }
        elseif ($PSCmdlet.ParameterSetName -eq "ByTemplatePath") {
            $script:TemplatePath = $TemplatePath
        }
        
        $TemplateVarDictionary = GetPlasterTemplateVarSet -Path $script:TemplatePath -ParameterSetName $PSCmdlet.ParameterSetName
        return $TemplateVarDictionary
    }

    end {

        if ($TemplateName -eq 'NewScript') {
            try {
                $CanidateModulePath = Resolve-Path . | Select-Object -ExpandProperty Path
                $Results = Get-MKModuleInfo $CanidateModulePath
                $IsModulePath = $Results.IsValid
            }
            catch {
                $IsModulePath = $false
            }
        }
        else {
            $IsModulePath = $true
        }

        if ($IsModulePath) {
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

            # TODO: to have this conditional avail when TemplatePath is used too
            if ($TemplateName -eq 'NewScript') {
                Update-ModuleExports 
            }
            elseif ($TemplateName -eq 'NewModuleProject') {
                Add-ModuleToProfile -Path (Join-Path -Path $PSBoundParameters.DestinationPath -ChildPath $PSBoundParameters.ModuleName)
            }

            $TemplateVarDictionary.GetEnumerator() | ForEach-Object {
                $Name = "PLASTER_PARAM_" + ($_.Key)
                Remove-Variable -Name $Name -Scope Global
            }
        }
        else {
            Write-Error "Unable to find root module" -Category InvalidArgument -RecommendedAction "Set location inside a root module folder and try again."
        }
    }
}