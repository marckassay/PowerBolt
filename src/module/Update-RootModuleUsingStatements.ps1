using module .\.\MKModuleInfo.psm1
using module .\manifest\AutoUpdateSemVerDelegate.ps1

function Update-RootModuleUsingStatements {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.',

        [Parameter(Mandatory = $false,
            Position = 1,
            ValueFromPipeline = $true, 
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
        # 'using module' statements. a break with additional statements means that developer 
        # manually added that line; so keep it.
        $RootModuleContent = Get-Content $ModInfo.RootModuleFilePath
        [string[]]$ModuleContentsCleaned = $RootModuleContent | `
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

        [string[]]$UniqueSourceFiles = $TargetFunctionsToExport.FilePath.FullName | `
            Sort-Object -Unique | `
            Group-Object -Property {$_.Split("$SourceFolderPath\")[1]} | `
            Select-Object -ExpandProperty Group | `
            ForEach-Object {
            if ($_ -ne $ModInfo.RootModuleFilePath) {
                $("using module .$($_.Split($ModInfo.Path)[1])".Trim() + "`n")
            }
        }
    
        if ($ModuleContentsCleaned -eq $null) {
            $UpdatedModuleContentRaw = @"
$UniqueSourceFiles
"@
        }
        elseif ($ModuleContentsCleaned -ne $null) {
            $UpdatedModuleContentRaw = @"
$UniqueSourceFiles
$ModuleContentsCleaned
"@
        }
    
        @{
            ManifestPath            = $ModInfo.ManifestFilePath
            TargetFunctionsToExport = $TargetFunctionsToExport
        }

        if ($UpdatedModuleContentRaw) {
            $UpdatedModuleContent = $($UpdatedModuleContentRaw -split "`n").TrimEnd("`r")
        }
        else {
            $UpdatedModuleContent = @()
        }

        if (-not $RootModuleContent) {
            $RootModuleContent = @()
        }

        $Differences = Compare-Object -ReferenceObject $UpdatedModuleContent -DifferenceObject $RootModuleContent -PassThru
        
        # touch the file only when there is a difference
        if ($Differences) {
            Set-Content -Path $ModInfo.RootModuleFilePath -Value $UpdatedModuleContentRaw -PassThru:$PassThru.IsPresent -Encoding UTF8 -NoNewline
        }

        $OFS = ' '
    }
}