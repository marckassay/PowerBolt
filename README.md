# MKPowerShell

The following operations are:

* Stores last value of Set-Location and restores that location when PowerShell restarts.
* You can restart PowerShell from command-line via 'pwsh'.  'pwsha' will restart with administrator privileges
* Publish modules by retrieving NugetAPIKey and deploying my development directory to a PowerShell module directory
* When a session starts PowerShell profile will be backed-up to my Google Drive directory and will overwrite Visual Studio code profile (see Update-PowerShellProfile).
* A function to output a given module's synopsis for its exported functions.
* Cumulative PowerShell history of sessions.

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/MKPowerShell/blob/master/LICENSE) [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/MKPowerShell/)

## Caveat

* This module hasn't been tested to my standard as it is simply a utility module that I created.  So some constraints and limitations exist still, but welcome pull-requests.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module MKPowerShell
```

## Usage

### ```sl``` (```Set-LocationAndStore```)

```powershell
    Param (
        [Parameter(Mandatory = $False, Position = 1)]
        [string]$Path,

        [Parameter(Mandatory = $False)]
        [string]$LiteralPath,

        [switch]$PassThru
    )
```

.SYNOPSIS

Stores last location and restores that location when PowerShell restarts

.DESCRIPTION

Stores last value of and restores that location when PowerShell restarts so that it continues in the directory you last were in previous session.

.ALIAS sl

.INPUTS None

.OUTPUTS System.Management.Automation.PathInfo, System.Management.Automation.PathInfoStack

.EXAMPLE

```powershell
E:\> sl projects

E:\projects> sl..
```

### ```Set-NuGetApiKey```

```powershell
    Param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )
```

.SYNOPSIS
Stores NuGet API key to be used with Publish-ModuleToNuGetGallery

.DESCRIPTION
Stores NuGet API key in the registry so that when Publish-ModuleToNuGetGallery is called it will retrieve the key without you having to copy-and-paste it into the command line.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-ModuleToNuGetGallery
```

.LINK
Publish-ModuleToNuGetGallery

### ```Publish-ModuleToNuGetGallery```

```powershell
    Param (
        [Parameter(Mandatory = $False)]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$NuGetApiKey = (Get-ItemPropertyValue -Path $RegistryKey -Name NuGetApiKey),

        [Parameter(Mandatory = $False)]
        [string[]]$Exclude = ('.git', '.vscode', '.gitignore'),

        [switch]$WhatIf
    )
```

.SYNOPSIS

Streamline publishing module to PowerShellGet.

.DESCRIPTION

Prior to calling you can store API key using Set-NuGetApiKey.  If not, you must assign it to the NuGetApiKey parameter.  When called this function will take the directory (or file's directory) and will copy it to the PowerShell module directory (eg: C:\Users\Marc\Documents\PowerShell\Modules) where PowerShell can publish it to an online gallery.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-ModuleToNuGetGallery
```

.LINK
Set-NuGetApiKey

### ```pwsh``` (```Restart-PWSH```)

.SYNOPSIS

Restarts PowerShell

.DESCRIPTION

Restarts PowerShell

.ALIAS
pwsh

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects> pwsh
```

.LINK
Restart-PWSH

### ```pwsha``` (```Restart-PWSHAdmin```)

.SYNOPSIS

Restarts PowerShell with Administrator privileges

.DESCRIPTION

Restarts PowerShell with Administrator privileges

.ALIAS
pwsha

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects> pwsha
```

.LINK
Restart-PWSH

### ```Set-BackupProfileLocation```

```powershell
    Param (
        [Parameter(Mandatory = $True, Position = 1)]
        [string]$Value
    )
```

.SYNOPSIS

Will backup profile to desired location when PowerShell starts

.DESCRIPTION

Upon PowerShell startup, profile will be copied to the value given to this function

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects> Set-BackupProfileLocation 'D:\Google Drive\Documents\PowerShell'
```

### ```Get-ModuleSynopsis```

```powershell
    DynamicParam {
        ...
        $NonInstalledSet = Get-Module | Select-Object -ExpandProperty Name
        $InstalledSet = Get-InstalledModule | Select-Object -ExpandProperty Name
        ...
    }
```

.SYNOPSIS

Lists all available functions for a module, with the synopsis of the functions.

.DESCRIPTION

Lists all available functions of a module using Get-Command and Get-Help.

.INPUTS
None

.OUTPUTS
PSCustomObject

.EXAMPLE

```none
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
```

### ```Show-History```

.SYNOPSIS

Concatenate PowerShell histories, so that you can reference previous commands from previous sessions.

.DESCRIPTION

When PowerShell starts, it will load the previous CSV file (via Import-Csv) and concatenate (via Add-History)it to current session.  Doing this allows you to reference previous command from any previous session.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\> Show-History

ExecutionTime                                                              CommandLine Id
-------------                                                              ----------- --
Saturday, April 7, 2018 3:52:21 PM                                                exit 62
Saturday, April 7, 2018 3:52:05 PM                                        Show-History 61
Saturday, April 7, 2018 3:42:59 PM                                                sl.. 60
Saturday, April 7, 2018 3:42:29 PM                              Get-Content config.xml 59
...
```

### ```Update-PowerShellProfile```

```powershell
    Param
    (
        [Parameter(Mandatory = $False)]
        [string]$Path = "$args\Microsoft.VSCode_profile.ps1",

        [Parameter(Mandatory = $False)]
        [string[]]$Include
    )
```

.SYNOPSIS

Updates other PowerShell profiles with Microsoft.PowerShell_profile.ps1

.DESCRIPTION

Currently this is hard-coded to only update VSCode profile.  Obviously this will need to be changed
to live up to its name.

.INPUT None

.OUTPUTS None

.EXAMPLE None

.NOTES $args is being used here for for Register-ObjectEvent scope

## Roadmap

* breakup this module into seperate modules and/or scripts
