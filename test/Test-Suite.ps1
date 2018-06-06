function Test-Suite {
    [CmdletBinding()]
    Param(
        $MKPowerShellModulePath
    )

    begin {
        Push-Location -StackName 'TestSuite'
        Set-Location $MKPowerShellModulePath
        Get-Item -Path "$MKPowerShellModulePath\*" -Include '*.psd1' -OutVariable ManifestItem | Test-ModuleManifest | Remove-Module
    }

    process {
        Invoke-Pester -Script "$MKPowerShellModulePath\test"
    }

    end {
        Import-Module -Name $ManifestItem.Directory.FullName
        Pop-Location -StackName 'TestSuite'
    }
}

function GetThisScriptPath {
    return $MyInvocation.ScriptName 
}
function StartTestSuite {
    Test-Suite -MKPowerShellModulePath (GetThisScriptPath | Split-Path -Parent | Split-Path -Parent)
}
StartTestSuite