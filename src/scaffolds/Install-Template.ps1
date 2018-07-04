using module .\..\dynamicparams\GetPlasterTemplateVarSet.ps1
using module .\..\module\Get-MKModuleInfo.ps1

# TODO: add Path and Name parameters so that the scaffold files can be added to rootmodule
function Install-Template {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByTemplatePath")]
    Param
    (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByTemplatePath")]
        [string]$TemplatePath,

        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $false, 
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
                $ModInfo = Get-MKModuleInfo $CanidateModulePath
                $IsModulePath = $ModInfo.IsValid
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

            if ($TemplateName -eq 'NewScript') {

                $ModuleHomeDeclarationCode = "`$script:PSCommandPath | Split-Path -Parent"
                $Depth = [regex]::Matches($PLASTER_PARAM_ScriptCongruentPath, "[\w]+").Count
                
                for ($i = 0; $i -le $Depth; $i++) {
                    $ModuleHomeDeclarationCode += " | Split-Path -Parent"
                }

                $PlasterCustomVar = @{PLASTER_ModuleHomeDeclarationCode = $ModuleHomeDeclarationCode; PLASTER_ModuleName = ($ModInfo.Name)}
                $PlasterCustomVar.GetEnumerator() | `
                    ForEach-Object {
                    $Name = $_.Key
                    $Value = $_.Value
                    Set-Variable -Name $Name -Value $Value -Scope Global
                }
            }

            $PlasterTemplateFolderPath = Split-Path -Path $script:TemplatePath -Parent

            if (-not $PSBoundParameters.DestinationPath) {
                Invoke-Plaster -TemplatePath $PlasterTemplateFolderPath -DestinationPath '.'
            }
            else {
                Invoke-Plaster -TemplatePath $PlasterTemplateFolderPath -DestinationPath $PSBoundParameters.DestinationPath
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

            if ($PlasterCustomVar) {
                $PlasterCustomVar.GetEnumerator() | `
                    ForEach-Object {
                    $Name = $_.Key
                    Remove-Variable -Name $Name -Scope Global
                }
            }
        }
        else {
            Write-Error "Unable to find root module" -Category InvalidArgument -RecommendedAction "Set location inside a root module folder and try again."
        }
    }
}