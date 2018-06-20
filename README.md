# MK.PowerShell.4PS

Created to streamline coding by primarily completing an objective of, having a [PowerShell](https://github.com/PowerShell/PowerShell) idea that is published to the world in minutes without compromising quality of module

You have a PowerShell idea, you may have gone thru the process of preparing this idea into a module and to be available to the public.  And in doing so you might of created tests, documentation and published it to a repository such as [PowerShell Gallery](https://www.powershellgallery.com/).  Doing so can be cumbersome especially when completing other objectives. 4PS attempts to remove this hinderance for you. 

Another objective of 4PS is to encourage publishing small, monad (how apropos!) scripts instead of a monolithic module in hopes to have it adapted in other modules. Hence the rationale of 4PS is to have several script files (.ps1) and one root module (.psm1).  Where as individual script files can be published and can be exported when publishing the root module.

## 4PS 101

The heuristic:

- Create
- Develop and Test
- Document
- Publish

### Create

First step is to scaffold files from a custom [Plaster](https://github.com/PowerShell/Plaster) template. For information on templates (plaster manifests) [Creating a Plaster Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md).  Using 4PS, the [`New-Script`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-Script.md) command guides you after choosing a template for its first parameter followed with dynamic contraints for its remaining arity.

For an example, the following:

```powershell
PS C:\Users\Alice\Apps> New-Script -PlasterTemplatePath '..\PlasterTemplates\NewMVC\plasterManifest_en-US.xml' -AppName 'CoffeeApp'
```

Although the Plaster manifest file is not shown, you can be assured that a variable of `PLASTER_PARAM_AppName` resides in its contents. And with Plaster you can scaffold files with variables (tokens) inside them that can be replaced with values such as the one given to AppName, for this instance.

If your GitHub repository branch is named with a valid Semantic Version value ([regex pattern](https://regex101.com/library/gG8cK7)), this value will be transposed to the `ModuleVersion` field in the manifest file automatically.  At this step or the next ('Develop and Test') you may manually change the module version using [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-SemVer.md).

### Develop and Test

With scaffolding in place, develop source file and test against that file using [Pester](https://github.com/pester/Pester). In this step I find TDD practices are beneficial especially the way Pester integrates with [VSCode](https://github.com/Microsoft/vscode) and using CLI with PowerShell.

When you believe you are ready to document and publish, call [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Invoke-TestSuiteRunner.md) to ensure that all test cases that are expected to pass, do indeed pass.

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Invoke-TestSuiteRunner
```

Since `Invoke-TestSuiteRunner` has been executed without an argument, therefore, the location of 'CoffeeApp' must be a PowerShell module.  Alternatively Invoke-TestSuiteRunner can be called with a path value to a module via `Path` parameter, or name value to a module via `Name`.  Those 2 parameters belong to a validateset which most of 4PS commands when applicable has these sets.

### Document

When development passes testing, generate documentation files powered by [platyPS](https://github.com/PowerShell/platyPS).  Using the following command:

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Build-Documentation
```

Used in its most simpliest form, calling [Build-Documentation](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-Documentation.md) with no parameters is intented to be called inside the root directory of a PowerShell module.  And when executed, it will call platyPS commands that will generate or update markdown files for all commands listed in the module's manifest exported function array.  It will also execute 4PS code that will update a README.md file in the root directory. 

This file will have an API section added or updated, with each exported command's markdown link and synopsis of the command.  Such an example can be seen on this every file below, see the API section of this file.

### Publish

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Publish-ModuleToNuGetGallery
```

I assume most developers organize their projects or repos in some location on their machine and resist conforming to have these assets elsewhere.  If so, [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) may help by deploying your module directory in a PowerShell module directory and publish from there.  Afterwards it will remove the directory and keep the original untouched.

To explain further on the reason for this command by giving an example, I currently have individual PowerShell modules listed in my PowerShell profile.  These modules that are listed point to my development directory where they reside on my file system.  So when I had to publish a module prior to this command, I would have to copy the folder to a PowerShell module directory.  A cumbersome process indeed, so this command to speed up that process.  In an addition 4PS can store your API key on your file system using [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md) which will be retrieved automatically when [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) is called if its `NuGetApiKey` parameter value is not set.

## 4PS 102

What conformity does 4PS expect in your module?

Although it's early in development, I've only recalled testing this module uder the following conditions that may have issues:

+ GitHub:  I'm obviously using this as SCM and in code some Regular Expressions validate URLs expecting it to be the way GitHub has choosen. 

+ module folder name: Is expected to be the same name as the manifest and root module file.

+ src:  This is where source code resides inside the module folder

+ test: This is where test code resides inside the module folder

+ git branch name: Git development braches are expected to be in SemVer format.  Otherwise it should simply not update module's version automatically.

## Formats

If `TurnOnExtendedFormats` key in `MK.PowerShell.4PS` is set to `true` the following will be enabled:

### Microsoft.PowerShell.Commands.HistoryInfo

When `Get-History` is called:

### System.Management.Automation.PSModuleInfo

When `Get-Module` is called:

## Types

If `TurnOnExtendedTypes` key in `MK.PowerShell.4PS` is set to `true` the following will be available:

### System.Byte[]

- `ToBinaryNotation()`
- `ToUnicode()`

### System.String

- `ToBase64()`
- `FromBase64()`
- `MatchCount()`

## Commands

#### [`Add-ModuleToProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Add-ModuleToProfile.md)

Appends content of the PowerShell session's profile with an `Import-Module` statement. 

#### [`Backup-Sources`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Backup-Sources.md)

The `Backups` object defined in `MK.PowerShell-config.json` will copy items to their destination location. 

#### [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-Documentation.md)

Creates or updates help documentation files and module's README file.  Also creates a XML based help documentation file for PowerShell. 

#### [`Build-PlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-PlatyPSMarkdown.md)

With required [`PlatyPS`](https://github.com/PowerShell/platyPS) module, calls [`New-MarkdownHelp`](https://github.com/PowerShell/platyPS/blob/master/docs/New-MarkdownHelp.md) or [`Update-MarkdownHelpModule`](https://github.com/PowerShell/platyPS/blob/master/docs/Update-MarkdownHelpModule.md). 

#### [`ConvertTo-EnumFlag`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/ConvertTo-EnumFlag.md)

With `InputObject` tested for equality via `-eq`, will `Write-Output` `Value` only when equality operator returns `true`. 

#### [`Export-History`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Export-History.md)

Exports HistoryInfo entries from `Get-History` to a CSV file which is intended to be imported so that a continuous history can be output to CLI. 

#### [`Get-LatestError`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-LatestError.md)

Throwaway function that may be reincarnated in a from of Format. 

#### [`Get-MergedPath`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MergedPath.md)

Returns a valid path from a parent of one of its children which overlaps that parent's path. 

#### [`Get-MKModuleInfo`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKModuleInfo.md)

Outputs information about a module with given name or path. 

#### [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKPowerShellSetting.md)

Retrieves JSON data from `MK.PowerShell-config.json` or outputs file via `ShowAll` switch. 

#### [`Import-History`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Import-History.md)

Imports HistoryInfo entries from `Export-History` so that a continuous history can be output to CLI. 

#### [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Invoke-TestSuiteRunner.md)

Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester) 

#### [`New-ExternalHelpFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-ExternalHelpFromPlatyPSMarkdown.md)

Calls `New-ExternalHelp` from `PlatyPS` module.  This functions will read the files in the folder from `Build-PlatyPSMarkdown`. 

#### [`New-MKPowerShellConfigFile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-MKPowerShellConfigFile.md)

Creates a new `MK.PowerShell-config.json` to be used for settings for `MK.PowerShell.4PS`. 

#### [`New-Script`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-Script.md)

Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template. 

#### [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md)

Streamlines publishing a module using `Publish-Module`. 

#### [`Reset-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Reset-ModuleInProfile.md)

Re-enables an `Import-Module` statement in `$PROFILE` to be executed.  

#### [`Restart-PWSH`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Restart-PWSH.md)

Launches a new PowerShell window by immediately terminating that called this function.  Default alias is `pwsh`. 

#### [`Restart-PWSHAdmin`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Restart-PWSHAdmin.md)

Launches a new PowerShell window with Admin privileges by immediately terminating that called this function. Default alias is `pwsha`. 

#### [`Search-Items`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Search-Items.md)

Recurses thru folders to find files that its content matches `Pattern`.  Outputs object(s) to console. 

#### [`Set-LocationAndStore`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-LocationAndStore.md)

Records every time `sl` is called so that when new session launches, location will be the one last record.  Default alias value for this function is `sl`. 

#### [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md)

Sets value to JSON data in `MK.PowerShell-config.json`. 

#### [`Skip-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Skip-ModuleInProfile.md)

Prevents an `Import-Module` statement in `$PROFILE` from executing. 

#### [`Update-ManifestFunctionsToExportField`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ManifestFunctionsToExportField.md)

Ideally having `Update-RootModuleUsingStatements` piped into this function, it will popluate a string array of function names and set it to the `FunctionsToExport`. 

#### [`Update-ModuleExports`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ModuleExports.md)

Updates root-module and manifest file with commands to be exported. 

#### [`Update-ReadmeFromPlatyPSMarkdown`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ReadmeFromPlatyPSMarkdown.md)

Adds or updates function's 'snippet' in README file from `PlatyPS` generated files. 

#### [`Update-RootModuleUsingStatements`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-RootModuleUsingStatements.md)

Prepends module found in `Path` with `using module ...` statements. Those statements are unique PS1 file paths that contain functions. 

#### [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-SemVer.md)

Updates the module's semantic version value in the manifest file.
