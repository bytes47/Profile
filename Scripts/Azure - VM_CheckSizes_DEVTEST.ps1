Connect-AzAccount
Select-AzureRmSubscription -Default XXXXXXXXXXXXXX


[array]$VMs = Get-AzVM 

foreach ($VM in $VMs)
 {
IF ($VM.HardwareProfile.VmSize -ne 'Standard_E4s_v3')
    {
Write-Output "VM: $($VM.Name) Size: $($VM.HardwareProfile.VmSize)"
    }
 }

