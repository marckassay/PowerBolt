using module ..\.\TestRunnerSupportModule.psm1

Describe "Test Set-MKPowerShellSetting" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new()
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Setting TurnOnAutoUpdateSemVer" {

        # Mock Restore-RememberLastLocation {} -ModuleName PowerBolt

        It "Should set TurnOnAutoUpdateSemVer to '<Value>' in config file" -TestCases @(
            @{ Value = $false}
            @{ Value = $true}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnAutoUpdateSemVer' -Value $Value
            
            $MKPowerShellConfig = Get-Content -Path $TestSupportModule.FixtureConfigFilePath | ConvertFrom-Json -AsHashtable
            $MKPowerShellConfig["TurnOnAutoUpdateSemVer"] -eq $true | Should -Be $Value

            # Assert-MockCalled Restore-RememberLastLocation -ModuleName PowerBolt -Times 1
        }
    } 
    
    Context "Setting TurnOnQuickRestart" {

        It "Should set TurnOnQuickRestart to '<Value>' in config file and change alias accordingly" -TestCases @(
            @{ Value = $false}
            @{ Value = $true}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnQuickRestart' -Value $Value

            $MKPowerShellConfig = Get-Content -Path $TestSupportModule.FixtureConfigFilePath | ConvertFrom-Json -AsHashtable
            $MKPowerShellConfig["TurnOnQuickRestart"] -eq $true | Should -Be $Value

            $PWSHSet = Get-Alias pwsh -Scope Global -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
            $PWSHASet = Get-Alias pwsha -Scope Global -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition

            if ($Value) {
                $PWSHSet | Should -Be 'Restart-PWSH'
                $PWSHASet | Should -Be 'Restart-PWSHAdmin'
            }
            else {
                $PWSHSet | Should -BeNullOrEmpty
                $PWSHASet | Should -BeNullOrEmpty
            } 
        } -Skip
    }

    Context "Setting Backups" {
        $Value1 = @{
            Path         = "'$PROFILE'"
            Destination  = 'C:\Google Drive\Documents\PowerShell\'
            UpdatePolicy = 'Overwrite'
        }

        It "Should set Backups to valid hashtables in config file." -TestCases @(
            @{ Value = $Value1 }
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'Backups' -Value $Value

            $MKPowerShellConfig = Get-Content -Path $TestSupportModule.FixtureConfigFilePath | ConvertFrom-Json -AsHashtable
            $MKPowerShellConfig.Backups.Path | Should -BeLike "'$PROFILE'"
            $MKPowerShellConfig.Backups.Destination | Should -Be $Value.Destination 
        } -Skip

        It "Should remove strings that have single quotes from config file." {
            $MKPowerShellConfig = Get-Content -Path $TestSupportModule.FixtureConfigFilePath | ConvertFrom-Json -AsHashtable
            $SingleQuotedPath = $MKPowerShellConfig.Backups.Path
            Test-Path $SingleQuotedPath | Should -Be $false
            $NoQuotedPath = $SingleQuotedPath -replace "\'", ""
            Test-Path $NoQuotedPath | Should -Be $true
        } -Skip
    }
}