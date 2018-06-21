# MK.PowerShell.4PS

Created to streamline coding by primarily completing an objective of, having a [PowerShell](https://github.com/PowerShell/PowerShell) idea that is published to the world in minutes without compromising quality of module.

You may have a PowerShell idea and gone thru the process of preparing this idea into a module so that it's available to be shared. And in doing so you might of created tests, documentation and published it to a repository such as [PowerShell Gallery](https://www.powershellgallery.com/). This can be cumbersome especially when completing other objectives. 4PS attempts to remove this hinderance for you. 

Another objective of 4PS is to encourage publishing small, monad (how apropos!) scripts instead of a monolithic module in hopes to have it adapted in other modules. Hence the rationale of 4PS is to have several script files (.ps1) and one root module (.psm1). Where as individual script files can be published and can be exported when publishing the root module.

## 4PS 101

The development flow:

- Create
- Develop and Test
- Document
- Publish

### Create

First step is to scaffold files from a custom [Plaster](https://github.com/PowerShell/Plaster) template. For information on templates (plaster manifests) [Creating a Plaster Manifest](https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md). Using 4PS, the [`New-Script`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-Script.md) command guides you after choosing a template for its first parameter followed with dynamic contraints for its remaining arity.

For an example, the following:

```powershell
PS C:\Users\Alice\Apps> New-Script -PlasterTemplatePath '..\PlasterTemplates\NewMVC\plasterManifest_en-US.xml' -AppName 'CoffeeApp'
```

Although the Plaster manifest file is not shown, you can be assured that a variable of `PLASTER_PARAM_AppName` resides in its contents. And with Plaster you can scaffold files with variables (tokens) inside them that can be replaced with values such as the one given to AppName, for this instance.

### Develop and Test

With scaffolding in place, develop source file and test against that file using [Pester](https://github.com/pester/Pester). In this step I find TDD practices are beneficial especially the way Pester integrates with [VSCode](https://github.com/Microsoft/vscode) and using CLI with PowerShell.

When you believe you are ready to document and publish, call [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Invoke-TestSuiteRunner.md) to ensure that all test cases that are expected to pass, do indeed pass.

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Invoke-TestSuiteRunner
```

Since `Invoke-TestSuiteRunner` has been executed without an argument, therefore, the location of 'CoffeeApp' must be a PowerShell module. Alternatively Invoke-TestSuiteRunner can be called with a path value to a module via `Path` parameter, or name value to a module via `Name`. Those 2 parameters belong to a validateset which most of 4PS commands when applicable has these sets.

If your GitHub repository branch is named with a valid Semantic Version value ([regex pattern](https://regex101.com/library/gG8cK7)), this value will be transposed to the `ModuleVersion` key in the manifest file automatically. At this step or the next ('Document') you may manually change the module version using [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-SemVer.md).

### Document

When development passes testing, generate documentation files powered by [platyPS](https://github.com/PowerShell/platyPS). Using the following command:

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Build-Documentation
```

Used in the most simpliest form, calling [Build-Documentation](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-Documentation.md) with no parameters is intented to be called inside the root directory of a PowerShell module. And when executed, it will call platyPS commands that will generate or update markdown files for all commands listed in the manifest's `FunctionsToExport` key. It will also execute 4PS code that will update a README.md file in the root directory. 

This file will have an API section added or updated, with each exported command's markdown link and synopsis of the command. Such an example can be seen on this every file below, see the API section of this file.

### Publish

```powershell
PS C:\Users\Alice\Apps\CoffeeApp> Publish-ModuleToNuGetGallery
```

I assume most developers organize their projects or repos in some location on their machine and resist having them elsewhere. If so, [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) may help by deploying your module directory in a "PowerShell" module directory and publish it from there. Afterwards it will remove the directory and keep the original untouched.

To explain further on the reason for this command, by giving an example, I currently have individual PowerShell modules listed in my PowerShell profile. These modules that are listed point to my development directory where they reside on my file system. So when I had to publish a module prior to this command, I would have to copy the folder to a PowerShell module directory. A cumbersome process indeed, so this command has been created to speed up that process. In an addition 4PS can store your API key on your file system using [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md) which will be retrieved automatically when [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) is called if its `NuGetApiKey` parameter value is not set.

## 4PS 102

What conformity does 4PS expect in your module?

Although it's early in development, I can only recall the following conditions that may have issues:

+ GitHub:  I'm obviously using this as SCM and some Regular Expressions validate URLs expecting it to be the way GitHub has choosen. 

+ module folder name: Is expected to be the same name as the manifest and root module file.

+ src:  This is where source code is expected to reside inside the module folder

+ test: This is where test code is expected to reside inside the module folder

+ git branch name: Git development braches are expected to be in SemVer format (simple variant only currently). Otherwise it will not update module's version automatically.

## 4PS 103

When 4PS is installed and ran for the first time, it will place a copy of its config file in the ApplicationData folder. Use [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKPowerShellSetting.md) and [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md) accordingly.  All values below are default values.

```json
"TurnOnBackup": "false",
"BackupPolicy": "auto",
"Backups": [{
    "Destination": "",
    "Path": "",
    "UpdatePolicy": ""
  }],
```

Ideal for moving setting files to perhaps a cloud drive such as Google Drive or Microsoft OneDrive.

```json
"TurnOnHistoryRecording": "true",
"HistoryLocation": "",
```

Stores histories and imports them into current session so that you can view histroy spaning perhaps days instead of just the current session.

```json
"TurnOnRememberLastLocation": "true"
"LastLocation": "",
```

When PowerShell is restarted, it will set the location to the last known location.

```json
"NuGetApiKey": "",
```

Store your API key that was issued from [PowerShell Gallery](https://www.powershellgallery.com/). When [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md) is called this value will be retrieved.

```json
"TurnOnAvailableUpdates": "true",
```

Checks for updates when PowerShell starts-up.

```json
"TurnOnAutoUpdateSemVer": "true",
```

Updates manifest's `ModuleVersion` key when using some of 4PS commands.  Read 4PS 101 section for more information.

```json
"TurnOnExtendedFormats": "true",
```

Enables the following formats:
+ Microsoft.PowerShell.Commands.HistoryInfo
Formats output from `Get-History`

+ System.Management.Automation.PSModuleInfo
Formats output from `Get-Module`

```json
"TurnOnExtendedTypes": "true",
```

Enables the following commands for types:
+ System.Byte[] 
`ToBinaryNotation()`
`ToUnicode()`

+ System.String
`ToBase64()`
`FromBase64()`
`MatchCount()`

```json
"TurnOnQuickRestart": "true"
```

Using the alias `pwsh` and `pwsha` will restart PowerShell.  The former restarts PowerShell in Administrative mode.

## Commands

#### [`Add-ModuleToProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Add-ModuleToProfile.md)

Appends content of the PowerShell session's profile with an `Import-Module` statement. 

#### [`Build-Documentation`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Build-Documentation.md)

Creates or updates help documentation files and module's README file. Also creates a XML based help documentation file for PowerShell. 

#### [`Get-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Get-MKPowerShellSetting.md)

Retrieves JSON data from `MK.PowerShell-config.json` or outputs file via `ShowAll` switch. 

#### [`Invoke-TestSuiteRunner`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Invoke-TestSuiteRunner.md)

Creates a PowerShell background job that calls [`Invoke-Pester`](https://github.com/pester/Pester/wiki/Invoke-Pester) 

#### [`New-MKPowerShellConfigFile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-MKPowerShellConfigFile.md)

Creates a new `MK.PowerShell-config.json` to be used for settings for `MK.PowerShell.4PS`. 

#### [`New-Script`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/New-Script.md)

Scaffolds files based on the required [Plaster](https://github.com/PowerShell/Plaster) template. 

#### [`Publish-ModuleToNuGetGallery`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Publish-ModuleToNuGetGallery.md)

Streamlines publishing a module using `Publish-Module`. 

#### [`Reset-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Reset-ModuleInProfile.md)

Re-enables an `Import-Module` statement in `$PROFILE` to be executed. 

#### [`Restart-PWSH`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Restart-PWSH.md)

Launches a new PowerShell window by immediately terminating that called this function. Default alias is `pwsh`. 

#### [`Restart-PWSHAdmin`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Restart-PWSHAdmin.md)

Launches a new PowerShell window with Admin privileges by immediately terminating that called this function. Default alias is `pwsha`. 

#### [`Set-LocationAndStore`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-LocationAndStore.md)

Records every time `sl` is called so that when new session launches, location will be the one last record. Default alias value for this function is `sl`. 

#### [`Set-MKPowerShellSetting`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Set-MKPowerShellSetting.md)

Sets value to JSON data in `MK.PowerShell-config.json`. 

#### [`Skip-ModuleInProfile`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Skip-ModuleInProfile.md)

Prevents an `Import-Module` statement in `$PROFILE` from executing. 

#### [`Update-ModuleExports`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-ModuleExports.md)

Updates root-module and manifest file with commands to be exported. 

#### [`Update-SemVer`](https://github.com/marckassay/MK.PowerShell.4PS/blob/0.0.1/docs/Update-SemVer.md)

Updates manifest's `ModuleVersion` key to one that is formatted to SemVer.
