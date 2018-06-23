using module ..\.\TestRunnerSupportModule.psm1

Describe "Test GetPlasterTemplateVarSet" {
    BeforeAll {
        $TestSupportModule = [TestRunnerSupportModule]::new('MockModuleB')

        $AlicesTemplates = New-Item -Path (Join-Path $TestSupportModule.TestDrivePath "AlicesTemplates") -ItemType Directory
        <#         
        Copy-Item -Path (Join-Path -Path $TestSupportModule.FixtureDirectoryPath -ChildPath 'resources\templates\NewModule') -Destination $AlicesTemplates -Recurse
        $MockNewModuleTemplatePath = Join-Path -Path $AlicesTemplates -ChildPath 'NewModule\plasterManifest_en-US.xml' 
        #>
        Copy-Item -Path (Join-Path -Path $TestSupportModule.FixtureDirectoryPath -ChildPath 'resources\templates\NewScript') -Destination $AlicesTemplates -Recurse
        $MockNewScriptTemplatePath = Join-Path -Path $AlicesTemplates -ChildPath 'NewScript\plasterManifest_en-US.xml'

        Set-Variable -Name MockNewScriptTemplatePath -Value $MockNewScriptTemplatePath -Scope Global
    }
    
    AfterAll {
        Remove-Variable -Name MockNewScriptTemplatePath 
        $TestSupportModule.Teardown()
    }
    
    Context "Call with path to a plaster template file" {
        It "`$Result should have entries matching variable names" {
            InModuleScope MK.PowerShell.Flow {
                $Results = GetPlasterTemplateVarSet -Path $MockNewScriptTemplatePath
                $Results.Keys -Contains "ScriptCongruentPath" | Should -Be $True
                $Results.Keys -Contains "ScriptName" | Should -Be $True
            }
        }
    }
}