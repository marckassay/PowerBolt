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

This module hasn't been tested to my standard as it is simply a utility module that I created.  So some constraints and limitations exist still, but welcome pull-requests.

## Instructions

To install, run the following command in PowerShell.

```powershell
$ Install-Module MKPowerShell
```

## Functions

### [```Backup-PowerShellProfile```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Backup-PowerShellProfile.md)

    Internal function called by MKPowerShell that will copy the session's profile script ($PROFILE) to the value set with MKPowerShell\Set-BackupProfileLocation.
 
### [```Export-History```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Export-History.md)

    Internal async function for MKPowerShell, to update CSV file of histories
 
### [```Get-ModuleSynopsis```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Get-ModuleSynopsis.md)

    Lists all available functions for a module, with the synopsis of the functions.
 
### [```Publish-ModuleToNuGetGallery```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Publish-ModuleToNuGetGallery.md)

    Streamlines publishing a module to PowerShellGet.
 
### [```Restart-PWSH```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Restart-PWSH.md)

    Restarts PowerShell
 
### [```Restart-PWSHAdmin```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Restart-PWSHAdmin.md)

    Restarts PowerShell with Administrator privileges
 
### [```Set-BackupProfileLocation```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Set-BackupProfileLocation.md)

    To be used to set the value of a folder so MKPowerShell backs-up the sessions profile script ($PROFILE)
 
### [```Set-LocationAndStore```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Set-LocationAndStore.md)

    Stores last location and restores that location when PowerShell restarts
 
### [```Set-NuGetApiKey```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Set-NuGetApiKey.md)

    Stores NuGet API key to be used with Publish-ModuleToNuGetGallery
 
### [```Show-History```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Show-History.md)

    Concatnates PowerShell session histories so that you can reference previous commands from previous sessions.
 
### [```Update-PowerShellProfile```](https://github.com/marckassay/MKPowerShell/blob/master/docs/Update-PowerShellProfile.md)

    Internal function that updates other PowerShell profiles with the session's profile script ($PROFILE)

## Roadmap