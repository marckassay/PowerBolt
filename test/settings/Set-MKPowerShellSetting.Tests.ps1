using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Set-MKPowerShellSetting" {
    BeforeAll {
        $__ = [TestFunctions]::DescribeSetup($MODULE_FOLDER, '')
    }
    
    AfterAll {
        [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
    }
    
    Context "Setting TurnOnRememberLastLocation" {

        Mock Restore-RememberLastLocation {} -ModuleName MK.PowerShell.4PS

        It "Should set TurnOnRememberLastLocation to '<Value>' in config file" -TestCases @(
            @{ Value = $false}
            @{ Value = $true}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnRememberLastLocation' -Value $Value
            
            $MKPowerShellConfig = Get-Content -Path $__.ConfigFilePath | ConvertFrom-Json -AsHashtable
            $MKPowerShellConfig["TurnOnRememberLastLocation"]| Should -Be $true

            Assert-MockCalled Restore-RememberLastLocation -ModuleName MK.PowerShell.4PS -Times 1
        }
    } 
    
    Context "Setting TurnOnQuickRestart" {

        It "Should set TurnOnQuickRestart to '<Value>' in config file and change alias accordingly" -TestCases @(
            @{ Value = $false}
            @{ Value = $true}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnQuickRestart' -Value $Value

            $MKPowerShellConfig = Get-Content -Path $__.ConfigFilePath | ConvertFrom-Json -AsHashtable
            $MKPowerShellConfig["TurnOnQuickRestart"] | Should -Be $true

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
        }
    }

    Context "Setting Backupdata" {

        It "Should set TurnOnQuickRestart to '<Value>' in config file and change alias accordingly" -TestCases @(
            @{ Value = $false}
            @{ Value = $true}
        ) {
            Param($Value)

            Set-MKPowerShellSetting -Name 'TurnOnQuickRestart' -Value $Value

            $MKPowerShellConfig = Get-Content -Path $__.ConfigFilePath | ConvertFrom-Json -AsHashtable
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
        }
    }
}