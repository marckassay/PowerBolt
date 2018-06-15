class MKModuleInfo {
    [string]$Name
    [string]$Path
    [string]$PathFolderName
    [string]$ManifestFilePath
    [string]$RootModuleFilePath
    [object]$Version
        
    MKModuleInfo(
        [string]$Path,
        [string]$Name
    ) {
        $this.Path = $Path
        $this.Name = $Name
        
        $this.AssignRemainingFields()
    }

    [void]AssignRemainingFields() {
        $PSModuleInfo = $null
        
        try {
            if (-not $this.Name) {
                if (-not $this.Path) {
                    $this.Path = '.'
                }
                else {
                    # if backslash is at the end and this value is used with Import-Module, it will fail to import
                    $this.Path.TrimEnd('\', '/')
                }
                $this.Path = Resolve-Path $this.Path | Select-Object -ExpandProperty Path

                # it may be a .psd1 or .psm1 file
                if ($(Test-Path ($this.Path) -PathType Leaf)) {
                    $Item = Get-Item -Path ($this.Path)

                    if ($Item.Extension -eq '.psd1') {
                        $PSModuleInfo = Test-ModuleManifest $Item
                    }
                    elseif ($Item.Extension -eq '.psm1') {
                        # seek root folder only for .psd1 file
                        $PredicatedManifestPath = $this.PredicatedManifestPath($Item.Directory.FullName)
                    
                        $PSModuleInfo = Test-ModuleManifest $PredicatedManifestPath
                    }
                }
                else {
                    $PredicatedManifestPath = $this.PredicatedManifestPath($this.Path)
                    
                    $PSModuleInfo = Test-ModuleManifest $PredicatedManifestPath
                }
            }
            elseif ($this.Name) {
                $PSModuleInfo = Get-Module -Name $this.Name
            }
        }
        catch {
            $PSModuleInfo = $null
        }

        if ($PSModuleInfo) {
            $this.Name = $PSModuleInfo.Name
            $this.Path = $PSModuleInfo.ModuleBase
            $this.PathFolderName = Split-Path $PSModuleInfo.ModuleBase -Leaf
            $this.ManifestFilePath = $this.PredicatedManifestPath($this.Path)
            $this.RootModuleFilePath = Join-Path -Path ($this.Path) -ChildPath ($PSModuleInfo.RootModule)
            $this.Version = $PSModuleInfo.Version
        }
        else {
            if (-not $this.Name) {
                Write-Host "Unable to acquire information about module with the given Path: "$this.Path
            }
            else {
                Write-Host "Unable to acquire information about module with the given Name: "$this.Name
            }
        }
    }

    [string]PredicatedManifestPath([string]$Path) {
        # seek root folder only for .psd1 file
        return Get-ChildItem -Path $Path -Include '*.psd1' -Depth 0 | `
            Select-Object -ExpandProperty FullName
    }
}