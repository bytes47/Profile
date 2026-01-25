## Create Backup Vault
#

$location = "eastus"
$vaultrg = "ResourceGroup"
$vaultname = "TestBkpVault"
$subscriptionID = "Put Subscription ID here"
$disk_OS = "Define OS Disk here"
$disk_Data = "Define Data Disk here"
$disk_Data0 = "Define Data Disk 0 here"
$disk_Data1 = "Define Data Disk 1 here"
$disk_Data2 = "Define Data Disk 2 here"
$redundanttype = "LocallyRedundant"       #GeoRedundant

$storageSetting = New-AzDataProtectionBackupVaultStorageSettingObject -Type $redundanttype -DataStoreType VaultStore
New-AzDataProtectionBackupVault -ResourceGroupName $vaultrg -VaultName $vaultname -Location $location -StorageSetting $storageSetting
$TestBkpVault = Get-AzDataProtectionBackupVault -VaultName $vaultname
$TestBKPVault | fl
ETag                :
Id                  : /subscriptions/$subscriptionID/resourceGroups/$vaultrg/providers/Microsoft.DataProtection/backupVaults/$vaultname
Identity            : Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.DppIdentityDetails
IdentityPrincipalId :
IdentityTenantId    : 
IdentityType        :
Location            : $location
Name                : $vaultname
ProvisioningState   : Succeeded
StorageSetting      : {Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.StorageSetting}
SystemData          : Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.SystemData
Tag                 : Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.DppTrackedResourceTags
Type                : Microsoft.DataProtection/backupVaults


## Create Backup Policy
# To understand the inner components of a backup policy for Azure disk backup, retrieve the policy template using the command Get-AzDataProtectionPolicyTemplate. 
# This command returns a default policy template for a given datasource type. 
$policyDefn = Get-AzDataProtectionPolicyTemplate -DatasourceType AzureDisk
$policyDefn | fl

DatasourceType : {Microsoft.Compute/disks}
ObjectType     : BackupPolicy
PolicyRule     : {BackupHourly, Default}

$policyDefn.PolicyRule | fl

BackupParameter           : Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.AzureBackupParams
BackupParameterObjectType : AzureBackupParams
DataStoreObjectType       : DataStoreInfoBase
DataStoreType             : OperationalStore
Name                      : BackupWeekly
ObjectType                : AzureBackupRule
Trigger                   : Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.ScheduleBasedTriggerContext
TriggerObjectType         : ScheduleBasedTriggerContext

IsDefault  : True
Lifecycle  : {Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20210201Preview.SourceLifeCycle}
Name       : Default
ObjectType : AzureRetentionRule

$policyDefn.PolicyRule[0].Trigger | fl
ObjectType                    : ScheduleBasedTriggerContext
ScheduleRepeatingTimeInterval : {R/2022-10-25T13:00:00+00:00/PT4H}
TaggingCriterion              : {Default}

$policyDefn.PolicyRule[1].Lifecycle | fl
DeleteAfterDuration        : P30D
DeleteAfterObjectType      : AbsoluteDeleteOption
SourceDataStoreObjectType  : DataStoreInfoBase
SourceDataStoreType        : OperationalStore
TargetDataStoreCopySetting :



