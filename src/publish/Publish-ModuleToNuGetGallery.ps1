function Publish-ModuleToNuGetGallery {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $False)]
        [string]$NuGetApiKey = (Get-MKPowerShellSetting -Name 'NuGetApiKey'),
        
        [Parameter(Mandatory = $False)]
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

        $Confirm = ($DoNotConfirm.IsPresent -eq $False)

        $DestinationDirectory = Join-Path -Path ($Env:PSModulePath.Split(';')[0]) -ChildPath $ModInfo.ModuleFolderName

        # if it exists in $Env:PSModulePath[0], remove it
        if ((Test-Path -Path $DestinationDirectory -PathType Container) -eq $True) {
            Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
        }
    
        # copy items to deploy directory
        Copy-Item -Path $ModInfo.Path -Exclude $Exclude -Destination $DestinationDirectory -Recurse -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
        
        # TODO: not sure why Exclude isnt working other than similar Get-ChildItems issue PowerShell has
        $Exclude | ForEach-Object {
            Join-Path -Path $DestinationDirectory -ChildPath $_
        } | Remove-Item -Force -Confirm:$False -Recurse -ErrorAction SilentlyContinue 
    
        # Mask all but the last 8 chracters for Write-Information
        $RedactedNuGetApiKey = $NuGetApiKey.Remove(0, 23).Insert(0, 'XXXXXXXX-XXXX-XXXX-XXXX')
        Write-Information "Will be using the following value for NuGet API Key: $RedactedNuGetApiKey" -InformationAction Continue

        if ($Confirm -eq $False) {
            Write-Host "Flow is will now attempt to publish module in: $DestinationDirectory" -ForegroundColor Green
        }
        else {
            Write-Host "Flow is needs confirmation to publish module in: $DestinationDirectory" -ForegroundColor Red
        }

        Publish-Module -Path $DestinationDirectory -NuGetApiKey $NuGetApiKey -Confirm:$Confirm -WhatIf:$WhatIf.IsPresent -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
    
        # teardown
        Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
    }
}