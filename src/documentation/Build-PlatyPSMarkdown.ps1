using module .\.\MKPowerShellDocObject.psm1

function Build-PlatyPSMarkdown {
    [CmdletBinding(PositionalBinding = $True)]
    Param
    (
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
        [MKPowerShellDocObject]$Data,

        [Parameter(Mandatory = $False, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $False)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Path = (Get-Location | Select-Object -ExpandProperty Path),

        [Parameter(Mandatory = $False)]
        [string]$MarkdownFolder = 'docs',

        [Parameter(Mandatory = $False)]
        [string]$Locale = 'en-US',
        
        [Parameter(Mandatory = $False)]
        [string]$OnlineVersionUrlTemplate,

        [Parameter(Mandatory = $False)]
        [ValidateSet("Auto", "Omit")]
        [string]$OnlineVersionUrlPolicy = 'Auto',

        [Parameter(Mandatory = $False)]
        [string]$MarkdownSnippetCollection,
        
        [switch]
        $NoReImportModule
    ) 
    
    begin {
        if (-not $Data) {
            $Data = [MKPowerShellDocObject]::new(
                $Name,
                $Path,
                $MarkdownFolder,
                $Locale,
                $OnlineVersionUrlTemplate,
                $OnlineVersionUrlPolicy,
                $MarkdownSnippetCollection,
                $NoReImportModule.IsPresent
            )
        }
    }

    end {
        $Data.ModuleMarkdownFolder = Join-Path -Path $Data.ModuleFolder -ChildPath $Data.MarkdownFolder
        $MarkdownFolderItems = Get-ChildItem -Path $Data.ModuleMarkdownFolder -Include '*.md' -Recurse -ErrorAction SilentlyContinue
        if ($MarkdownFolderItems.Count -eq 0) {
            New-Item -Path $Data.ModuleMarkdownFolder -ItemType Container -Force | Out-Null

            if ($Data.NoReImportModule -eq $False) {
                Remove-Module -Name $Data.ModuleName
                Import-Module -Name $Data.RootManifest -Force -Scope Global
            }
            
            Write-Host -Object ($Data.OnlineVersionUrl) -ForegroundColor Blue -BackgroundColor Red

            New-MarkdownHelp -Module $Data.ModuleName -OutputFolder $Data.ModuleMarkdownFolder | Out-Null

            # Since New-MarkdownHelp OnlineVersionUrl parameter is only available when free of param 
            # constraint, below is to assign 'onlineverion' field.
            Get-ChildItem -Path $Data.ModuleMarkdownFolder -Include '*.md' -Recurse | `
                ForEach-Object {
                $FileUrl = $Data.OnlineVersionUrl -f $_.BaseName
                $FileContent = Get-Content $_.FullName -Raw
                $FileContent = $FileContent.Replace('online version:', "online version: $FileUrl")
                Set-Content -Path $_.FullName -Value $FileContent
            }
        }
        else {
            if ($Data.NoReImportModule -eq $False) {
                Remove-Module -Name $Data.ModuleName
                Import-Module -Name $Data.RootManifest -Force -Scope Global
            }

            $ExportedFunctions = Get-Module -Name $Data.ModuleName | `
                Select-Object -ExpandProperty ExportedFunctions | `
                Select-Object -ExpandProperty Values | `
                Select-Object -ExpandProperty Name

            # remove obsolete .md files
            $MarkdownFolderItems | `
                Select-Object -ExpandProperty BaseName | `
                ForEach-Object {
                if ($ExportedFunctions -notcontains $_) {
                    Remove-Item -Path ($Data.ModuleMarkdownFolder + "\$_.md") -Confirm
                }
            }

            Update-MarkdownHelpModule -Path $Data.ModuleMarkdownFolder | Out-Null
        }
        

        Write-Output $Data
    }
}