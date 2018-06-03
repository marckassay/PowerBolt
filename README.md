# MK.PowerShell.4PS

When monotonous PowerShell tasks mentally piled up and knowing the power of automation and modules, MK.PowerShell.4PS was created.

Prior to this project, when a PowerShell idea would just be a figment of my imagination, I would be ecstatic initially but that typically would be followed by a mundune heuristic that wouldve be completed for public use. That heuristic can be illustraed below:

* Create a new file. A .ps1 or .psm1? Well, perhaps a script file will do...should I create it with PowerShell or via right-click...
* Well it should be attempted to be test proven, I will need to make a file for Pester too.
* Also I will need to look into my PlatyPS notes again to see how to call its functions for documentation.
* A README will be needed too.
* Also where is my NuGetApi key?  I will need that of course to publish it...
* And I will need to move my repo project into a powershell module directory since its currently resides with my other git reposiotries.
* Remember to remove file that are not needed before publishing
* Perhaps I should ...

This module's objective is to reduce much mundune tasks 

## Formats

If `TurnOnExtendedFormats` key in `MK.PowerShell.4PS` is set to `true` the following will be enabled:

### Microsoft.PowerShell.Commands.HistoryInfo

When `Get-History` is called:

### System.Management.Automation.PSModuleInfo

When `Get-Module` is called:

## Types

If `TurnOnExtendedTypes` key in `MK.PowerShell.4PS` is set to `true` the following will be available:

### System.Byte[]

* `ToBinaryNotation()`
* `ToUnicode()`

### System.String

* `ToBase64()`
* `FromBase64()`
* `MatchCount()`

## API

#### [`Add-ModuleToProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Add-ModuleToProfile.md)

Appends content of PowerShell session's profile with an `Import-Module` statement. 

#### [`Backup-Sources`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Backup-Sources.md)

The `Backups` object defined in `MK.PowerShell-config.json` will copy items to their destination location. 

#### [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-Documentation.md)

Creates or updates help documentation files and module's README file.  Also creates a XML based help documentation file for PowerShell. 

#### [`Build-PlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Build-PlatyPSMarkdown.md)

With required [`PlatyPS`](https://github.com/PowerShell/platyPS) module, calls [`New-MarkdownHelp`](https://github.com/PowerShell/platyPS/blob/master/docs/New-MarkdownHelp.md) or [`Update-MarkdownHelpModule`](https://github.com/PowerShell/platyPS/blob/master/docs/Update-MarkdownHelpModule.md). 

#### [`ConvertTo-EnumFlag`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/ConvertTo-EnumFlag.md)

With `InputObject` tested for equality via `-eq`, will `Write-Output` `Value` only when equality operator returns `true`. 

#### [`Export-History`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Export-History.md)

Exports HistoryInfo entries from `Get-History` to a CSV file which is intended to be imported so that a continuous history can be output to CLI. 

#### [`Get-LatestError`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Get-LatestError.md)

Throwaway function that may be reincarnated in a from of Format. 

#### [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Get-MKPowerShellSetting.md)

Retrieves JSON data from `MK.PowerShell-config.json` or outputs file via `ShowAll` switch. 

#### [`Import-History`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Import-History.md)

Imports HistoryInfo entries from `Export-History` so that a continuous history can be output to CLI. 

#### [`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/New-ExternalHelpFromPlatyPSMarkdown.md)

Calls `New-ExternalHelp` from `PlatyPS` module.  This functions will read the files in the folder from `Build-PlatyPSMarkdown`. 

#### [`New-MKPowerShellConfigFile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/New-MKPowerShellConfigFile.md)

Creates a new `MK.PowerShell-config.json` to be used for settings for `MK.PowerShell.4PS`. 

#### [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Publish-ModuleToNuGetGallery.md)

Streamlines publishing a module using `Publish-Module`. 

#### [`Restart-PWSH`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Restart-PWSH.md)

Launches a new PowerShell window by immediately terminating that called this function.  Default alias is `pwsh`. 

#### [`Restart-PWSHAdmin`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Restart-PWSHAdmin.md)

Launches a new PowerShell window with Admin privileges by immediately terminating that called this function. Default alias is `pwsha`. 

#### [`Search-Items`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Search-Items.md)

Recurses thru folders to find files that its content matches `Pattern`.  Outputs object(s) to console. 

#### [`Set-LocationAndStore`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Set-LocationAndStore.md)

Records every time `sl` is called so that when new session launches, location will be the one last record.  Default alias value for this function is `sl`. 

#### [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Set-MKPowerShellSetting.md)

Sets value to JSON data in `MK.PowerShell-config.json`. 

#### [`Update-ManifestFunctionsToExportField`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-ManifestFunctionsToExportField.md)

Ideally having `Update-RootModuleUsingStatements` piped into this function, it will popluate a string array of function names and set it to the `FunctionsToExport`. 

#### [`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-ReadmeFromPlatyPSMarkdown.md)

Adds or updates function's 'snippet' in README file from `PlatyPS` generated files. 

#### [`Update-RootModuleUsingStatements`](https://github.com/marckassay/MK.PowerShell.4PS/blob/master/docs/Update-RootModuleUsingStatements.md)

Prepends module found in `Path` with `using module ...` statements. Those statements are unique PS1 file paths that contain functions.
