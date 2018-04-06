# MKPowerShell

This module contains the following custom tasks that I use frequently:

* Stores last value of Set-Location and restores that location when PowerShell restarts.
* You can restart PowerShell from command-line via 'pwsh'.  'pwsha' will restart with administrator privledges
* Publish modules by retrieving NugetAPIKey and deploying my development directory to a PowerShell module directory
* When a session starts PowerShell profile will be backed-up to my Google Drive directory and will overwrite Visual Studio code profile.
* A function to output a given module's synopsis for its exported functions.
* Cumlitave PowerShell history of sessions.

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/marckassay/MKPowerShell/blob/master/LICENSE) [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/MKPowerShell/)

## Caveat

* This module hasn't been tested to my standard as it is simpily a utility module that I created.  So some constraints and limitations exist still, but welcome pull-requests.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module MKPowerShell
```

## Usage

### ```sl``` (```Set-LocationAndStore [-Path] <String> [[-LiteralPath] <String>] [-PassThru]```)

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

.SYNOPSIS
Stores NuGet API key to be used with MKPowerShell.Publish-Module

.DESCRIPTION
Stores NuGet API key in the registry so that when MKPowerShell.Publish-Module is called it will retrieve the key without promting you for it.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-Module
```

.LINK
Publish-Module

### ```Publish-Module```

.SYNOPSIS

Streamline publishing module to using PowerShellGet.Publish-Module

.DESCRIPTION

Prior to calling you can store API key using Set-NuGetApiKey.  If not, you must assign it to the NuGetApiKey parameter.  When called this function will take the directory (or file's directory) and will copy it to the PowerShell module directory (eg: C:\Users\Marc\Documents\PowerShell\Modules) where PowerShell can then publish it to an online gallery.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\projects\MKPowerShell> Set-NuGetApiKey 'a1b2c3d4-e5f6-g7h8-i9j1-0k11l12m13n1'
E:\projects\MKPowerShell> Publish-Module
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

### ```Get-History```

.SYNOPSIS

Concatnates PowerShell histories, so that you can reference previous commands from previous sessions.

.DESCRIPTION

When PowerShell starts, it will load the previous CSV file (via Import-Csv) and concatnate (via Add-History)it to current session.  Doing this allows you to reference previous command from any previous session.

.INPUTS
None

.OUTPUTS
None

.EXAMPLE

```powershell
E:\> Get-History
E:\> Invoke-History
```