function Update-RootModuleUsingStatements {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [string]$SourceDirectory,

        [Parameter(Mandatory = $false)]
        [string[]]$Include = @('*.ps1', '*.psm1'),
 
        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = '*.Tests.ps1',

        [switch]
        $PassThru
    )

    begin {
        # Prevents single space for each item in an iteration:
        # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-6#ofs
        $OFS = ''
    }

    end {
        $MI = Get-ModuleInfo -Path $Path

        $ManifestPath = $MI.Info.Path
        $ModulePath = $MI.ModuleBase
        $RootModulePath = Join-Path -Path $ModulePath -ChildPath ($MI.RootModule)

        $TargetDirectory = Join-Path -Path $ModulePath -ChildPath $SourceDirectory -Resolve

        # $StopMatchingImportStatements: stop matching when there is a break of consecutive 
        # 'using module' statements.  a break with additional statements means that developer 
        # manually added that line; so keep it.    
        [string[]]$ModuleContentsCleaned = Get-Content .\MK.PowerShell.4PS.psm1 | `
            ForEach-Object -Begin {$StopMatchingImportStatements = $false} -Process {
            if ($StopMatchingImportStatements) {
                $($_ + "`n")
            }
            elseif (-not ($_ -match '(?<=(using module \.\\)).*(?=(\.ps1))')) {
                $StopMatchingImportStatements = $true
            }
        }

        $TargetFunctionsToExport = Get-ChildItem -Path $TargetDirectory -Include $Include -Exclude $Exclude -Recurse | `
            Get-Item -Include $Include -PipelineVariable File | `
            Get-Content -Raw | `
            ForEach-Object {
            $NoExportMatches = [regex]::Matches($_, '(?<=NoExport)(?:[:\s]*?)(?<sanitized>\w*-\w*)')
            $FunctionMatches = [regex]::Matches($_, '(?<=function )[\w]*[-][\w]*')
            for ($i = 0; $i -lt $FunctionMatches.Count; $i++) {
                $FunctionName = $FunctionMatches[$i].Value
                if (($NoExportMatches | ForEach-Object {$_.Groups['sanitized'].Value}) -notcontains $FunctionName) {
                    @{
                        FilePath     = $File
                        FunctionName = $FunctionName
                    }
                }
            }
        }

        $UniqueSourceFiles = $TargetFunctionsToExport.FilePath.FullName | `
            Sort-Object -Unique | `
            Group-Object -Property {$_.Split("$SourceDirectory\")[1]} | `
            Select-Object -ExpandProperty Group | `
            ForEach-Object {
            if ($_ -ne $RootModulePath) {
                Write-Output "using module .$($_.Split($ModulePath)[1])`n"
            }
        }
    
        if ($ModuleContentsCleaned -eq $null) {
            $UpdatedModuleContent = @"
$UniqueSourceFiles
"@
        }
        elseif ($ModuleContentsCleaned -ne $null) {
            $UpdatedModuleContent = @"
$UniqueSourceFiles
$ModuleContentsCleaned
"@
        }

        @{
            ManifestPath            = $ManifestPath
            TargetFunctionsToExport = $TargetFunctionsToExport
        }
    
        Set-Content -Path $RootModulePath -Value $UpdatedModuleContent -PassThru:$PassThru.IsPresent -Encoding UTF8 -NoNewline
        
        $OFS = ' '
    }
}