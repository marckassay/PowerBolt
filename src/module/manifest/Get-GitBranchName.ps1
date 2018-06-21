# NoExport: Get-GitBranchName
function Get-GitBranchName {
    [CmdletBinding(PositionalBinding = $True, 
        DefaultParameterSetName = "ByPath")]
    Param
    (
        [Parameter(Mandatory = $False,
            Position = 0,
            ValueFromPipeline = $False, 
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
        $GitRaw = Get-Content -Path $GitHEADPath -Raw
        
        [regex]::Match($GitRaw, '(?<=[\\|\/])[\w\.]*$').Value
    }
}
