
# Can't test against this function much: https://stackoverflow.com/a/45937503/648789
# But this is a low-level internal function.
Describe "Test Import-Script" {
    $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

    BeforeEach {
        Push-Location
        Set-Location -Path $SUT_MODULE_HOME
        Import-Module -Name .\MK.PowerShell.4PS.psd1 -Verbose -Force
    }

    AfterEach {
        Remove-Module -Name MK.PowerShell.4PS -Verbose -Force 
        Pop-Location
    }

    It "Should be imported." -Test {
        Get-Module -Name 'MK.PowerShell.4PS'
        (Get-Command Import-Script).Parameters['Path'].Attributes.Mandatory | Should Be $True
    }
}