﻿














function Test-RegisteredServer
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Get RegisteredServer by ParentObject"
        $registeredServers = Get-AzStorageSyncServer -ParentObject $storageSyncService -Verbose
        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Get RegisteredServer by ParentResourceId"
        $registeredServers = Get-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -Verbose
        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-RegisteredServerPipeline1
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"

        Register-AzStorageSyncServer -ParentObject $storageSyncService | Get-AzStorageSyncServer | Unregister-AzStorageSyncServer -Force -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-RegisteredServerPipeline2
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"

        Register-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId | Unregister-AzStorageSyncServer -Force -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-NewRegisteredServer
{
   
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-NewRegisteredServerParentObject
{
   
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ParentObject $storageSyncService -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-NewRegisteredServerParentResourceId
{
   
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-GetRegisteredServer
{
     
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by StorageSyncService"
        $registeredServers = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -Verbose

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-GetRegisteredServers
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by StorageSyncService"
        $registeredServers = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -Verbose

        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]

        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-GetRegisteredServerParentObject
{
      
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ParentObject $storageSyncService -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-GetRegisteredServerParentResourceId
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-RemoveRegisteredServer
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


function Test-RemoveRegisteredServerInputObject
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -InputObject $expectedRegisteredServer -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}



function Test-RemoveRegisteredServerResourceId
{
    
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceId $expectedRegisteredServer.ResourceId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}
