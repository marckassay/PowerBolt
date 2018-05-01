Describe "Test New-ExternalHelpFromPlatyPSMarkdown" {
    BeforeAll {
        $SUT_MODULE_HOME = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

        Set-Location -Path $SUT_MODULE_HOME

        $ConfigFilePath = "$TestDrive\MK.PowerShell\MK.PowerShell-config.ps1"
        
        Import-Module -Name '.\MK.PowerShell.4PS.psd1' -ArgumentList $ConfigFilePath -Verbose -Force
    }
    AfterAll {
        Remove-Module MK.PowerShell.4PS -Force
        Set-Alias sl Set-Location -Scope Global
    }

    Context "Lorem Ipsum" {
        
        It "Should skip" {

        } -Skip

        It "Should skip" -TestCases @(
            @{ Path = "C:\"}
        ) {
            Param($Path)

        } -Skip
    }
}