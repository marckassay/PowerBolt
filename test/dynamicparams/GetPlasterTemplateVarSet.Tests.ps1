using module ..\.\TestRunnerSupportModule.psm1

$script:PlasterTemplateFilePath
Describe "Test GetPlasterTemplateVarSet" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')
        $script:PlasterTemplateFilePath = Join-Path -Path $TestSupportModule.MockDirectoryPath -ChildPath 'resources\plasterManifest_en-US.xml'
        Set-Variable -Name PlasterTemplateFilePath -Value $script:PlasterTemplateFilePath -Scope Global
    }
    
    AfterAll {
        Remove-Variable -Name PlasterTemplateFilePath 
        $TestSupportModule.Teardown()
    }
    
    Context "Call with path to a plaster template file" {
        It "`$Result should have entries matching variable names" {
            InModuleScope MK.PowerShell.4PS {
                $Results = GetPlasterTemplateVarSet -Path $PlasterTemplateFilePath
                $Results.Keys -Contains "ScriptCongruentPath" | Should -Be $True
                $Results.Keys -Contains "ScriptName" | Should -Be $True
            }
        }
    }
}