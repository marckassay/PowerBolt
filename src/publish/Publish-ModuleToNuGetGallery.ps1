function Publish-ModuleToNuGetGallery {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false)]
        [string]$NuGetApiKey = (Get-PowerBoltSetting -Name 'NuGetApiKey'),
        
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = ('.git', '.vscode', '.gitignore'),
        
        [switch]$DoNotConfirm,

        [switch]$WhatIf
    )

    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }
    
    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        if (-not $Name) {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }
        else {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }

        $Confirm = ($DoNotConfirm.IsPresent -eq $false)

        $DestinationDirectory = Join-Path -Path ($Env:PSModulePath.Split(';')[0]) -ChildPath $ModInfo.ModuleFolderName

        # if it exists in $Env:PSModulePath[0], remove it
        if ((Test-Path -Path $DestinationDirectory -PathType Container) -eq $true) {
            Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
        }
    
        # copy items to deploy directory
        Copy-Item -Path $ModInfo.Path -Exclude $Exclude -Destination $DestinationDirectory -Recurse -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
        
        # TODO: not sure why Exclude isnt working other than similar Get-ChildItems issue PowerShell has
        $Exclude | ForEach-Object {
            Join-Path -Path $DestinationDirectory -ChildPath $_
        } | Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue 
    
        # Mask all but the last 8 chracters for Write-Information
        $RedactedNuGetApiKey = $NuGetApiKey.Remove(0, 23).Insert(0, 'XXXXXXXX-XXXX-XXXX-XXXX')

        if ($Confirm -eq $false) {
            Write-Host @"
PowerBolt will now attempt to publish '$($ModInfo.Name)' module
    Using the following value for NuGet API Key: $RedactedNuGetApiKey
"@ -ForegroundColor Green
            $ToProceed = $true
        }
        else {
            Write-Host @"
PowerBolt needs your confirmation to publish '$($ModInfo.Name)' module that is temporary in:
    $DestinationDirectory

Will be using the following value for NuGet API Key: $RedactedNuGetApiKey
"@ -ForegroundColor Red
            $ToProceed = Read-Choice '-------------------------------------------' -Choices '&Yes', '&No' -DefaultChoice '&No'

            if ($ToProceed -match 'Yes') {
                $ToProceed = $true
            }
            else {
                $ToProceed = $false
            }
        }

        if ($ToProceed -eq $true) {

            Write-Host "PowerBolt is now publishing '$($ModInfo.Name)' module" -ForegroundColor Green

            $ArgList = @{ 
                DestinationDirectory = $DestinationDirectory
                NuGetApiKey          = $NuGetApiKey
                WhatIf               = $WhatIf.IsPresent
                Verbose              = $($Verbose.IsPresent -or $WhatIf.IsPresent) 
            }

            Start-Job -Name "JobPowerShellGet" -ScriptBlock {
                param($AL) 
                Publish-Module -Path $AL.DestinationDirectory -NuGetApiKey $AL.NuGetApiKey -WhatIf:$($AL.WhatIf) -Verbose:$($AL.Verbose)
            } -ArgumentList $ArgList | Wait-Job -Force | ForEach-Object {Receive-Job -Name JobPowerShellGet} 
        }
 
        # teardown
        Write-Host "PowerBolt is now removing temporary directory" -ForegroundColor Green
        Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
    }
}

# source: https://stackoverflow.com/a/43354245/648789
#NoExport: Read-Choice
function Read-Choice(
    [Parameter(Mandatory)][string]$Message,
    [Parameter(Mandatory)][string[]]$Choices,
    [Parameter(Mandatory)][string]$DefaultChoice,
    [Parameter()][string]$Question = 'Are you sure you want to proceed?'
) {
    $defaultIndex = $Choices.IndexOf($DefaultChoice)
    if ($defaultIndex -lt 0) {
        throw "$DefaultChoice not found in choices"
    }

    $choiceObj = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]

    foreach ($c in $Choices) {
        $choiceObj.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList $c))
    }

    $decision = $Host.UI.PromptForChoice($Message, $Question, $choiceObj, $defaultIndex)
    return $Choices[$decision]
}