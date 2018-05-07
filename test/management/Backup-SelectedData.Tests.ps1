using module ..\.\TestFunctions.psm1
$MODULE_FOLDER = 'E:\marckassay\MK.PowerShell\MK.PowerShell.4PS'

Describe "Test Backup-SelectedData" {
    BeforeAll {
        $ConfigFilePath = "TestDrive:\User\Bob\AppData\Local\MK.PowerShell.4PS\MK.PowerShell-config.ps1"
        Copy-Item -Path "$MODULE_FOLDER\resources\MK.PowerShell-config.ps1" -Destination $ConfigFilePath
        
        $CloudPowerShell = New-Item -Path "TestDrive:\User\Bob\CloudDrive\PowerShell"

        $Data = @{
            Path        = @("'$ConfigFilePath'")
            Destination = "'$CloudPowerShell'"
        }

        Invoke-Command -ScriptBlock {
            .$ConfigFilePath
            $MKPowerShellConfig.BackUpLocations = $Data
        }
    }

    
}
    
AfterAll {
    [TestFunctions]::DescribeTeardown(@('MK.PowerShell.4PS', 'MKPowerShellDocObject', 'TestFunctions'))
}
    
Context "When 'TurnOnBackup' set to 'true' and 'BackupPolicy' set to 'Auto' with valid values for 'BackupLocations'." {
    <# 
        Set-MKPowerShellSetting -Name 'TurnOnBackup' -Value $true
        Set-MKPowerShellSetting -Name 'BackupPolicy' -Value 'Auto'
        Set-MKPowerShellSetting -Name 'BackupLocations' -Value @{
            Path        = @($__.ConfigFilePath)
            Destination = $CloudPowerShell
        } #>

    It "Should call Backup-SelectedData on PowerShell startup" {
        $__.ConfigFilePath | Should -FileContentMatch "TurnOnRememberLastLocation = '$Value'"
        Assert-MockCalled Restore-RememberLastLocation -ModuleName MK.PowerShell.4PS -Times 1
    }
} 
}