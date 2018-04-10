$RegistryKey = 'HKCU:\SOFTWARE\MKPowerShell'
$MKPowerShellAppData = "$Env:LOCALAPPDATA\MKPowerShell"

<#
.SYNOPSIS
Concatnates PowerShell histories, so that you can reference previous commands from previous sessions.

.DESCRIPTION
When PowerShell starts, it will load the previous CSV file (via Import-Csv) and concatnate (via Add-History) it to current session.  Doing this allows you to reference previous command from any previous session.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\> Get-History
E:\> Invoke-History
#>
function Export-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param()

    if ((Test-Path $MKPowerShellAppData -ErrorAction SilentlyContinue) -eq $False ) {
        New-Item -Path $MKPowerShellAppData -ItemType Directory
        New-Item -Path "$MKPowerShellAppData\SessionHistories.csv" -ItemType File
        
        $Script:SessionHistoriesCount = 0
    }
    # TODO: check $MaximumHistoryCount
    $SessionHistory = Get-History
    $EntriesToExport = [math]::Abs($Script:SessionHistories.Count - $SessionHistory.Count)
    
    Get-History -Count $EntriesToExport | Export-Csv -Path "$MKPowerShellAppData\SessionHistories.csv" 
}

function Import-History {
    [CmdletBinding(PositionalBinding = $True)]
    Param()

    if ((Test-Path $MKPowerShellAppData -ErrorAction SilentlyContinue) -eq $False ) {
        New-Item -Path $MKPowerShellAppData -ItemType Directory
        New-Item -Path "$MKPowerShellAppData\SessionHistories.csv" -ItemType File

        $Script:SessionHistoriesCount = 0
    }
    else {
        $SessionHistories = Import-Csv -Path "$MKPowerShellAppData\SessionHistories.csv"
        $Script:SessionHistoriesCount = $SessionHistories.Count;

        $SessionHistories | Add-History
    }
}

<#
.SYNOPSIS
Concatnates PowerShell histories, so that you can reference previous commands from previous sessions.

.DESCRIPTION
Displays history in descending order

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\> Show-History

ExecutionTime                                                              CommandLine Id
-------------                                                              ----------- --
Saturday, April 7, 2018 3:52:21 PM                                                exit 62
Saturday, April 7, 2018 3:52:05 PM                                        Show-History 61
Saturday, April 7, 2018 3:42:59 PM                                                sl.. 60
Saturday, April 7, 2018 3:42:29 PM                              Get-Content config.xml 59
...
#>
function Show-History {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    $GroupObject = @{
        Name       = ':'
        Expression = {$_.EndExecutionTime.DayOfWeek}
    }

    Get-History | Sort-Object -Property Id | `
        Format-Table -AutoSize -Wrap -GroupBy $GroupObject -Property `
    @{Label = "Id"; Expression = {($_.Id)}; Alignment = 'Left'}, `
    @{Label = "ExecutionTime"; Expression = { ($_.EndExecutionTime.toString('t')) }; Alignment = 'Left'}, `
    @{Label = "CommandLine"; Expression = {($_.CommandLine)}; Alignment = 'Left'}
}

<#
.SYNOPSIS
Lists all available functions for a module, with the synopsis of the functions.

.DESCRIPTION
Lists all available functions of a module using Get-Command and Get-Help.

.INPUTS
None

.OUTPUTS
PSCustomObject

.EXAMPLE
E:\> Get-ModuleSynopsis Microsoft.PowerShell.Utility

Name                      Synopsis
----                      --------
ConvertFrom-SddlString
Format-Hex                Displays a file or other input as hexadecimal.
Get-FileHash              Computes the hash value for a file by using a specified hash algorithm.
Import-PowerShellDataFile
New-Guid                  Creates a GUID.
New-TemporaryFile         Creates a temporary file.
Add-Member                Adds custom properties and methods to an instance of a Windows PowerShell object.
Add-Type                  Adds a.NET Framework type (a class) to a Windows PowerShell session.
#>
function Get-ModuleSynopsis {
    [CmdletBinding(PositionalBinding = $False)]
    Param(
        # Any other parameters can go here
    )
 
    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'Name'
            
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $True
        $ParameterAttribute.Position = 0

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSets 
        $NonInstalledSet = Get-Module | Select-Object -ExpandProperty Name
        $InstalledSet = Get-InstalledModule | Select-Object -ExpandProperty Name
            
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($NonInstalledSet + $InstalledSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }

    begin {
        # Bind the parameter to a friendly variable
        $Name = $PsBoundParameters[$ParameterName]
    }

    process {
        Get-Command -Module $Name | Foreach-Object {
            $Syno = Get-Help -Name $_.Name | Select-Object -ExpandProperty Synopsis

            [PSCustomObject]@{
                Name     = $_.Name
                Synopsis = $Syno 
            }
        }
    }
}

<#
.SYNOPSIS
Will backup profile to desired location when PowerShell starts

.DESCRIPTION
Upon PowerShell startup, profile will be copied to the value given to this function

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\projects> Set-BackupProfileLocation 'D:\Google Drive\Documents\PowerShell'

#>
function Set-BackupProfileLocation {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )

    Set-ItemProperty -Path $RegistryKey -Name BackupProfileLocation -Value $Value -Verbose:$Verbose.IsPresent
}

# backup this profile to Google Drive in case if working on new computer or this 
# computer gets reformatted which might be forgotten. 
function Backup-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Destination = (Get-ItemPropertyValue -Path $RegistryKey -Name BackupProfileLocation)
    )

    if ((Test-Path $Destination -PathType Container) -eq $False) {
        New-Item $Destination -ItemType Directory
    }
    Copy-Item -Path $PROFILE -Destination $Destination -Force
}


<#
.SYNOPSIS
Updates other PowerShell profiles with Microsoft.PowerShell_profile.ps1

.DESCRIPTION
Currently this is hard-coded to only update VSCode profile.  Obviously this will need to be changed
to live up to its name.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

.NOTES
$args is being used here for for Register-ObjectEvent scope
#>
function Update-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Path = "$args\Microsoft.VSCode_profile.ps1",

        [Parameter(Mandatory = $False)]
        [string[]]$Include
    )
    $ContentBuilder = New-Object -TypeName "System.Text.StringBuilder";

    # overwrite $Path with the following...
    $ContentBuilder.AppendLine('# THIS FILE IS AUTOGENERATED THAT IS OVERWRITTEN BY Microsoft.PowerShell_profile.ps1 FILE')

    # include only...
    Get-Content $PROFILE | `
        ForEach-Object {
        if ($_.StartsWith('Import-Module')) {
            $ContentBuilder.AppendLine($_)
        }
    }

    # append the following...
    $ContentBuilder.AppendLine(@"

# overwrite alias 'sl' with MKPowerShell module's Set-LocationAndStore
Set-Alias sl Set-LocationAndStore -Scope Global -Force
Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'."
"@
    )
 
    Out-File -FilePath $Path -InputObject $ContentBuilder.ToString() -Encoding utf8
}

<#
.SYNOPSIS
Restarts PowerShell

.DESCRIPTION
Restarts PowerShell

# .ALIAS
pwsh

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\projects> pwsh

.LINK
Restart-PWSHAdmin
#>
function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    Unregister-Event -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Export-History
        Start-Process -FilePath "pwsh.exe" -Verb open
    } | Out-Null
    exit
}
Set-Alias pwsh Restart-PWSH -Scope Global
Write-Host "'pwsh' alias is now mapped to 'Restart-PWSH'." -ForegroundColor Green


<#
.SYNOPSIS
Restarts PowerShell with Administrator privileges

.DESCRIPTION
Restarts PowerShell with Administrator privileges

# .ALIAS
pwsha

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\projects> pwsha

.LINK
Restart-PWSH
#>
function Restart-PWSHAdmin {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    Unregister-Event -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Export-History
        Start-Process -FilePath "pwsh.exe" -Verb runAs
    } | Out-Null
    exit
}
Set-Alias pwsha Restart-PWSHAdmin -Scope Global
Write-Host "'pwsha' alias is now mapped to 'Restart-PWSHAdmin'." -ForegroundColor Green

<#
.SYNOPSIS Streamline publishing module to PowerShellGet.

.DESCRIPTION Prior to calling you can store API key using Set-NuGetApiKey.  If not, you must assign it to the NuGetApiKey parameter.  When called this function will take the directory (or file's directory) and will copy it to the PowerShell module directory (eg: C:\Users\Marc\Documents\PowerShell\Modules) where PowerShell can publish it to an online gallery.

.INPUTS None

.OUTPUTS None

.EXAMPLE
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-ModuleToNuGetGallery

.LINK Set-NuGetApiKey
#>
function Publish-ModuleToNuGetGallery {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$NuGetApiKey = (Get-ItemPropertyValue -Path $RegistryKey -Name NuGetApiKey),

        [Parameter(Mandatory = $False)]
        [string[]]$Exclude = ('.git', '.vscode', '.gitignore'),

        [switch]$WhatIf
    )
    
    # ignore .psd1, just concerned about module's root directory
    if ((Test-Path -Path $Path -PathType Container) -eq $False) {
        $Path = Split-Path -Path $Path -Parent -Resolve
    }

    # pick the first directory of $Env:PSModulePath and add the module's root directory name to it
    $ModuleDirectoryName = (Split-Path -Path $Path -Leaf)
    $DestinationDirectory = Join-Path -Path ($Env:PSModulePath.Split(';')[0]) -ChildPath $ModuleDirectoryName

    # if it exists in $Env:PSModulePath[0], remove it
    if ((Test-Path -Path $DestinationDirectory -PathType Container) -eq $True) {
        Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
    }
    
    # setup deploy directory
    New-Item $DestinationDirectory -ItemType Directory -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)| `
        Out-Null
    
    # setup deploy directory
    Get-ChildItem -Path $Path -Exclude $Exclude -Recurse | `
        Copy-Item -Destination $DestinationDirectory -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
    
    # Mask all but the last 8 chracters for Write-Information
    $RedactedNuGetApiKey = $NuGetApiKey.Remove(0, 23).Insert(0, 'XXXXXXXX-XXXX-XXXX-XXXX')
    Write-Information "Will be using the following value for NuGet API Key: $RedactedNuGetApiKey" -InformationAction Continue

    PowerShellGet\Publish-ModuleToNuGetGallery -Name $DestinationDirectory -NuGetApiKey $NuGetApiKey -Verbose -Confirm:$(-not $WhatIf.IsPresent) -WhatIf:$WhatIf.IsPresent
    
    # teardown
    Remove-Item $DestinationDirectory -Recurse -Force -Verbose:$($Verbose.IsPresent -or $WhatIf.IsPresent)
}

<#
.SYNOPSIS
Stores NuGet API key to be used with Publish-ModuleToNuGetGallery 

.DESCRIPTION
Stores NuGet API key in the registry so that when Publish-ModuleToNuGetGallery is called it will retrieve the key without promting you for it.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-ModuleToNuGetGallery

.LINK
Publish-ModuleToNuGetGallery
#>
function Set-NuGetApiKey {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )

    Set-ItemProperty -Path $RegistryKey -Name NuGetApiKey -Value $Value -Verbose:$Verbose.IsPresent
}

<#
.SYNOPSIS
Stores last location and restores that location when PowerShell restarts

.DESCRIPTION
Stores last value of and restores that location when PowerShell restarts so that it continues in the directory you last were in previous session. 

# .ALIAS
sl

.INPUTS
None

.OUTPUTS
System.Management.Automation.PathInfo, System.Management.Automation.PathInfoStack

.EXAMPLE
E:\> sl projects
E:\projects> sl..
#>
function Set-LocationAndStore {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$LiteralPath,

        [switch]$PassThru
    )

    if ($Path) {
        Set-Location -Path $Path -Verbose:$Verbose.IsPresent
    }
    else {
        Set-Location -LiteralPath $LiteralPath -Verbose:$Verbose.IsPresent
    }

    Set-ItemProperty -Path $RegistryKey -Name LastLocation -Value (Get-Location) -PassThru:$PassThru.IsPresent
}
Set-Alias sl Set-LocationAndStore -Scope Global -Force
Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'." -ForegroundColor Green

function Restore-RegistrySettings {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    if ( $(Test-Path $RegistryKey -ErrorAction SilentlyContinue) -eq $True ) {

        $LastLocation = Get-ItemPropertyValue -Path $RegistryKey -Name LastLocation

        if ( $(Test-Path $LastLocation -ErrorAction SilentlyContinue) -eq $True ) {
            Set-Location $LastLocation

            Write-Host "MKPowerShell restored LastLocation" -ForegroundColor Green
        }
    }
    else {
        $InitalLocation = Get-Location

        Push-Location

        Set-Location -Path 'HKCU:\SOFTWARE\'
        
        $RegKey = New-Item -Name 'MKPowerShell'
        $RegKey | New-ItemProperty -Name LastLocation -Value $InitalLocation -PropertyType String
        $RegKey | New-ItemProperty -Name NuGetApiKey -Value '' -PropertyType String
        $RegKey | New-ItemProperty -Name BackupProfileLocation -Value '' -PropertyType String

        Pop-Location
        
        Write-Host "New registry key for MKPowerShell has been created."
    }
}

function Start-PowerShellSession {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
    
    Register-Shutdown
    
    Restore-RegistrySettings
    Import-History
    
    Register-PostStartUp
}

function Register-PostStartUp {
    [CmdletBinding(PositionalBinding = $False)]
    Param()
   
    $job = Start-Job { Start-Sleep -Seconds 3 }

    Register-ObjectEvent $job -EventName StateChanged -SourceIdentifier StartUpJobEnd -Action {
        if ($sender.State -eq 'Completed') {
            Backup-PowerShellProfile
            Update-PowerShellProfile

            Unregister-Event StartUpJobEnd
            Remove-Job $job
        } 
    } | Out-Null
}

function Register-Shutdown {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        Export-History
    } | Out-Null
}  

Start-PowerShellSession