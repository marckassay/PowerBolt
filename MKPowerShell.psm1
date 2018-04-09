$RegistryKey = 'HKCU:\SOFTWARE\MKPowerShell'
$MKPowerShellAppData = "$Env:LOCALAPPDATA\MKPowerShell"
$SessionHistoriesCount
$Script:Restart

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

    Get-History | Sort-Object -Descending Id | `
        Format-Table @{Label = "ExecutionTime"; Expression = {($_.EndExecutionTime.DateTime)}; Alignment = 'Left'}, `
    @{Label = "CommandLine"; Expression = {($_.CommandLine)}; Alignment = 'Right'}, `
    @{Label = "Id"; Expression = {($_.Id)}; Alignment = 'Left'} -AutoSize
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

    Set-ItemProperty -Path $RegistryKey -Name BackupProfileLocation -Value $Value
}

# backup this profile to Google Drive in case if working on new computer or this 
# computer gets reformatted which might be forgotten. 
function Backup-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Destination
    )

    if (-not $Destination) {
        try {
            if ( $(Test-Path $RegistryKey -ErrorAction SilentlyContinue) -eq $True ) {

                $Destination = Get-ItemPropertyValue -Path $RegistryKey -Name BackupProfileLocation

                if ((Test-Path $Destination -PathType Container) -eq $False) {
                    New-Item $Destination -ItemType Directory
                }
                Copy-Item -Path $PROFILE -Destination $Destination -Force

                #Write-Host "BackupProfileLocation has been updated"
            }
        }
        catch {
            #Write-Host "No BackupProfileLocation value has been set."
        }
    }
}

function Update-PowerShellProfile {
    [CmdletBinding(PositionalBinding = $False)]
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Path = "$args\Microsoft.VSCode_profile.ps1",

        [Parameter(Mandatory = $False)]
        [string[]]$Include
    )

    # overwrite $Path with the following...
    $VSCode_Profile_Mesg = '# THIS FILE IS AUTOGENERATED THAT IS OVERWRITTEN BY Microsoft.PowerShell_profile.ps1 FILE'
    Set-Content $Path -Value $VSCode_Profile_Mesg  -Force | Out-Null

    # include only...
    Get-Content $PROFILE | `
        ForEach-Object {
        if ($_.StartsWith('Import-Module')) {
            $_
        }
    } | Add-Content $Path -Force

    # append the following...
    Add-Content $Path -Value @"

# overwrite alias 'sl' with MKPowerShell module's Set-LocationAndStore
Set-Alias sl Set-LocationAndStore -Force
"@ -Force

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
Write-Host "'pwsh' alias is now mapped to 'Restart-PWSH'."


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
Write-Host "'pwsha' alias is now mapped to 'Restart-PWSHAdmin'."

<#
.SYNOPSIS Streamline publishing module to PowerShellGet.

.DESCRIPTION Prior to calling you can store API key using Set-NuGetApiKey.  If not, you must assign it to the NuGetApiKey parameter.  When called this function will take the directory (or file's directory) and will copy it to the PowerShell module directory (eg: C:\Users\Marc\Documents\PowerShell\Modules) where PowerShell can publish it to an online gallery.

.INPUTS None

.OUTPUTS None

.EXAMPLE
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-PowerShellGetModule

.LINK Set-NuGetApiKey
#>
function Publish-PowerShellGetModule {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False, Position = 2)]
        [string]$NuGetApiKey = (Get-ItemPropertyValue -Path $RegistryKey -Name NuGetApiKey),

        [Parameter(Mandatory = $False)]
        [string[]]$Exclude = ('.git', '.vscode', '.gitignore'),

        [switch]$WhatIf
    )
    
    if ((Test-Path -Path $Path -PathType Container) -eq $False) {
        $Path = Split-Path -Path $Path -Parent -Resolve
    }

    $DestinationDirectory = Join-Path -Path ($Env:PSModulePath.Split(';')[0]) -ChildPath (Split-Path -Path $Path -Leaf)
    
    Remove-Item $DestinationDirectory -Recurse -Force -ErrorAction SilentlyContinue
    New-Item $DestinationDirectory -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

    Get-ChildItem -Path $Path -Exclude $Exclude -Recurse | Copy-Item -Destination $DestinationDirectory -WhatIf:$WhatIf.IsPresent

    Publish-Module -Name $Path -NuGetApiKey $NuGetApiKey -Verbose -Confirm -WhatIf:$WhatIf.IsPresent
}

<#
.SYNOPSIS
Stores NuGet API key to be used with Publish-PowerShellGetModule 

.DESCRIPTION
Stores NuGet API key in the registry so that when Publish-PowerShellGetModule is called it will retrieve the key without promting you for it.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-PowerShellGetModule

.LINK
Publish-PowerShellGetModule
#>
function Set-NuGetApiKey {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )

    Set-ItemProperty -Path $RegistryKey -Name NuGetApiKey -Value $Value
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
        Set-Location -Path $Path
    }
    else {
        Set-Location -LiteralPath $LiteralPath
    }

    Set-ItemProperty -Path $RegistryKey -Name LastLocation -Value (Get-Location) -PassThru:$PassThru.IsPresent
}
Set-Alias sl Set-LocationAndStore -Scope Global -Force
Write-Host "'sl' alias is now mapped to 'Set-LocationAndStore'."

function Restore-RegistrySettings {
    [CmdletBinding(PositionalBinding = $False)]
    Param()

    if ( $(Test-Path $RegistryKey -ErrorAction SilentlyContinue) -eq $True ) {

        $LastLocation = Get-ItemPropertyValue -Path $RegistryKey -Name LastLocation

        if ( $(Test-Path $LastLocation -ErrorAction SilentlyContinue) -eq $True ) {
            Set-Location $LastLocation

            Write-Host "Restored LastLocation"
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
   
    $job = Start-Job { Start-Sleep -Seconds 60 }
    
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