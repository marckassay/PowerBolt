using module .\.\MKModuleInfo.psm1
using module .\manifest\AutoUpdateSemVerDelegate.ps1

function Update-RootModuleUsingStatements {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $True, 
            ParameterSetName = "ByPipe")]
        [MKModuleInfo]$ModInfo,

        [Parameter(Mandatory = $false)]
        [string]$SourceFolderPath = 'src',

        [Parameter(Mandatory = $false)]
        [string[]]$Include = @('*.ps1', '*.psm1'),

        [Parameter(Mandatory = $false)]
        [string[]]$Exclude = '*.Tests.ps1',

        [switch]
        $PassThru
    )
    
    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }

    begin {
        $Name = $PSBoundParameters['Name']

        # Prevents single space for each item in an iteration:
        # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-6#ofs
        $OFS = ''
    }

    end {

        if ((-not $ModInfo) -and (-not $Name)) {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }
        elseif (-not $ModInfo) {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }
        
        AutoUpdateSemVerDelegate($ModInfo.Path)

        $TargetDirectory = Join-Path -Path $ModInfo.Path -ChildPath $SourceFolderPath -Resolve

        # $StopMatchingImportStatements: stop matching when there is a break of consecutive 
        # 'using module' statements.  a break with additional statements means that developer 
        # manually added that line; so keep it.
        [string[]]$ModuleContentsCleaned = Get-Content $ModInfo.RootModuleFilePath | `
            ForEach-Object -Begin {$StopMatchingImportStatements = $false} -Process {
            if ($StopMatchingImportStatements) {
                $($_ + "`n")
            }
            elseif (-not ($_ -match '(?<=(using module \.\\)).*(?=(\.ps1))')) {
                if ($_ -match '\S+') {
                    $($_ + "`n")
                }
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
            Group-Object -Property {$_.Split("$SourceFolderPath\")[1]} | `
            Select-Object -ExpandProperty Group | `
            ForEach-Object {
            if ($_ -ne $ModInfo.RootModuleFilePath) {
                Write-Output "using module .$($_.Split($ModInfo.Path)[1])`n"
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
            ManifestPath            = $ModInfo.ManifestFilePath
            TargetFunctionsToExport = $TargetFunctionsToExport
        }

        Set-Content -Path $ModInfo.RootModuleFilePath -Value $UpdatedModuleContent -PassThru:$PassThru.IsPresent -Encoding UTF8 -NoNewline

        $OFS = ' '
    }
}