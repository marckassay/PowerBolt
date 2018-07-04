# NoExport: Get-GitBranchName
function Get-GitBranchName {
    [CmdletBinding(PositionalBinding = $true, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $false, 
            ParameterSetName = "ByPath")]
        [string]$Path = '.'
    )
    
    DynamicParam {
        return GetModuleNameSet -Position 0 -Mandatory 
    }

    begin {
        $Name = $PSBoundParameters['Name']
    }

    end {
        if ($PSBoundParameters.Name) {
            $ModInfo = Get-MKModuleInfo -Name $Name
        }
        else {
            $ModInfo = Get-MKModuleInfo -Path $Path
        }

        Join-Path -Path $ModInfo.Path -ChildPath '.git/HEAD' -OutVariable GitHEADPath | Out-Null
        if (Test-Path $GitHEADPath) {
            $GitRaw = Get-Content -Path $GitHEADPath -Raw
            try {
                $BranchName = [regex]::Match($GitRaw, "(?<=[\\|\/])[\w\.]*", [System.Text.RegularExpressions.RegexOptions]::RightToLeft).Value
            }
            catch {
                $BranchName = $null
            }
            finally {
                $BranchName
            }
        }
    }
}
