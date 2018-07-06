using module ..\..\.\TestRunnerSupportModule.psm1

Describe "Test Get-GitBranchName" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
        Set-Variable -Name MockDirectoryPath -Value $TestSupportModule.MockDirectoryPath -Scope Global
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
        Remove-Variable -Name MockDirectoryPath -Scope Global
    }

    Context "Calling on MockModuleB" {
        It "Should return current branch name of master" {
            InModuleScope PowerEquip {
                $SemVer = Get-GitBranchName -Path $MockDirectoryPath
                $SemVer | Should -Be 'master'
            }
        }

        It "Should return branch name of 0.0.1" {
            
            Push-Location
            Set-Location $MockDirectoryPath
            Invoke-Expression -Command 'git checkout -b 0.0.1'

            InModuleScope PowerEquip {
                $SemVer = Get-GitBranchName -Path $MockDirectoryPath
                $SemVer | Should -Be '0.0.1'
            }

            Pop-Location
        } 
    }
}
