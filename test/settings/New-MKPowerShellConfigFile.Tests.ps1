using module ..\.\TestRunnerSupportModule.psm1

Describe "Test New-PowerBoltConfigFile" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleA')
    }
    
    AfterAll {
        $TestSupportModule.Teardown()
    }
    
    Context "Call New-PowerBoltConfigFile when no file exists" {
        BeforeEach {
            $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'PowerBolt-config.json'
        }
        AfterEach {

        }

        It "Should copy a new file to the destination folder ('MK.PowerShell')" {
            New-PowerBoltConfigFile -Path $TestDrive

            Get-Item $FullName | Should -Exist 
        }
    }

    Context "Call New-PowerBoltConfigFile when file exists" {
        It "Should prompt user about exisiting file" {
            InModuleScope PowerBolt {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After
                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'PowerBolt-config.json'
                Get-Module PowerBolt | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*PowerBolt-config.json') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName 

                ### TEST
                Mock WriteWarningWrapper { $true }
                
                Get-Item $FullName | Should -Exist
                
                New-PowerBoltConfigFile -Path $TestDrive
                
                Assert-MockCalled WriteWarningWrapper 1
                
                Get-Item $FullName | Should -Exist

                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            }
        }

        It "Should not prompt user about exisiting file" {
            InModuleScope PowerBolt {
                ### HACK: Before and After block is inside here since Pester seems to not like 
                # nested Before and After

                ### Before
                $FullName = Join-Path -Path $TestDrive -ChildPath '\MK.PowerShell\' -AdditionalChildPath 'PowerBolt-config.json'
                Get-Module PowerBolt | `
                    Select-Object -ExpandProperty FileList | `
                    ForEach-Object {if ($_ -like '*PowerBolt-config.json') {$_}} -OutVariable ModuleConfigFile
                New-Item -Path "$TestDrive\MK.PowerShell" -ItemType Directory -OutVariable ModuleConfigFolder
                Copy-Item -Path $ModuleConfigFile -Destination $ModuleConfigFolder.FullName 

                ### TEST
                Mock WriteWarningWrapper { $true }

                Get-Item $FullName | Should -Exist 

                New-PowerBoltConfigFile -Path $TestDrive -Force
                # NOTE: although this mock wasnt called '1' time in this 'It', this is from the 
                # previous 'It' block
                Assert-MockCalled WriteWarningWrapper 1

                Get-Item $FullName | Should -Exist
                
                ### After
                Remove-Item -Path "$TestDrive\MK.PowerShell" -Recurse
            } 
        }
    }
}