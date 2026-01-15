Connect-AzAccount -TenantId xxxxxxxxxxxxxx -Subscription xxxxxxxxxxxxxxxx


$resourceGroup = "jmInfra"
$vmName = "jmInfra-1"
$newVMSize = "Standard_E4s_v3"


## Turn off the VM
Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force

## Change the size

Get-AzVMSize -ResourceGroupName $resourceGroup -VMName $vmName
$vm = Get-AzVM -ResourceGroupName $resourceGroup -VMName $vmName
$vm.HardwareProfile.VmSize = $newVMSize
Update-AzVM -VM $vm -ResourceGroupName $resourceGroup
Stop-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Force
$vm = Get-AzVM -ResourceGroupName $resourceGroup -VMName $vmName
$vm.HardwareProfile.VmSize = $newVMSize
Update-AzVM -VM $vm -ResourceGroupName $resourceGroup
Start-AzVM -ResourceGroupName $resourceGroup -Name $vmName


## Change Disk Size to SSD

$rgName = 'jmInfra'
$vmName = 'jmInfra-1'
$storageType = 'Premium_LRS'
$vm = Get-AzVM -Name $vmName -resourceGroupName $rgName

## Turn off the VM
Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force

# Get all disks in the resource group of the VM
$vmDisks = Get-AzDisk -ResourceGroupName $rgName 

# For disks that belong to the selected VM, convert to Premium storage
foreach ($disk in $vmDisks)
{
	if ($disk.ManagedBy -eq $vm.Id)
	{
		$disk.Sku = [Microsoft.Azure.Management.Compute.Models.DiskSku]::new($storageType)
		$disk | Update-AzDisk
	}
}

Start-AzVM -ResourceGroupName $rgName -Name $vmName
