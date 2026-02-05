```powershell
# ==========================================
# Azure Disk Backup Script
# ==========================================
# This script creates an Azure Backup Vault, defines a backup policy, 
# and assigns Azure managed disks to the backup vault.
# ==========================================

## -----------------------------
## Step 1: Define Variables
## -----------------------------
# Azure region where the backup vault will be created
$location = "eastus"
# Resource group to contain the backup vault
$vaultrg = "ResourceGroup"
# Name of the backup vault
$vaultname = "TestBkpVault"
# Azure subscription ID
$subscriptionID = "Put Subscription ID here"

# Names of disks to back up
$disk_OS = "Define OS Disk here"
$disk_Data = "Define Data Disk here"
$disk_Data0 = "Define Data Disk 0 here"
$disk_Data1 = "Define Data Disk 1 here"
$disk_Data2 = "Define Data Disk 2 here"

# Redundancy type for vault storage
# Options: "LocallyRedundant" or "GeoRedundant"
$redundanttype = "LocallyRedundant"

## -----------------------------
## Step 2: Create Storage Setting for Backup Vault
## -----------------------------
# Defines the storage configuration for the backup vault
$storageSetting = New-AzDataProtectionBackupVaultStorageSettingObject -Type $redundanttype -DataStoreType VaultStore


## -----------------------------
## Step 3: Create Backup Vault
## -----------------------------
# Create the backup vault in Azure
New-AzDataProtectionBackupVault -ResourceGroupName $vaultrg -VaultName $vaultname -Location $location -StorageSetting $storageSetting

# Retrieve the backup vault object for verification
$TestBkpVault = Get-AzDataProtectionBackupVault -VaultName $vaultname

# Display vault details in a formatted list
$TestBkpVault | fl


## -----------------------------
## Step 4: Retrieve Backup Policy Template
## -----------------------------
# Backup policies define backup schedules and retention
# Get the default policy template for Azure managed disks
$policyDefn = Get-AzDataProtectionPolicyTemplate -DatasourceType AzureDisk

# Display the policy template for inspection
$policyDefn | fl

# Inspect policy rules (backup schedule, triggers, and retention)
$policyDefn.PolicyRule | fl
$policyDefn.PolicyRule[0].Trigger | fl    # Trigger details (schedule)
$policyDefn.PolicyRule[1].Lifecycle | fl  # Retention details (e.g., delete after 30 days)


## -----------------------------
## Step 5: Create a Backup Policy from Template
## -----------------------------
# Create a new policy object based on the template
# Name of the policy
$policyName = "AzureDiskBackupPolicy"

# Assign the policy to the vault
$policy = New-AzDataProtectionBackupPolicy -Vault $TestBkpVault -Name $policyName -PolicyRule $policyDefn.PolicyRule

# Display the created policy details
$policy | fl


## -----------------------------
## Step 6: Assign Disks to Backup Policy
## -----------------------------
# Convert disk names to resource IDs
$diskList = @($disk_OS, $disk_Data, $disk_Data0, $disk_Data1, $disk_Data2)

$diskResourceIds = foreach ($disk in $diskList) {
    if ($disk -ne "Define OS Disk here" -and $disk -ne "") {
        # Retrieve the disk object and get its ID
        $d = Get-AzDisk -ResourceGroupName $vaultrg -DiskName $disk
        $d.Id
    }
}

# Create backup protected items for each disk
foreach ($diskId in $diskResourceIds) {
    New-AzDataProtectionBackupProtectedItem -Vault $TestBkpVault -Policy $policy -ItemName (Split-Path $diskId -Leaf) -DatasourceId $diskId
}

# Display all protected items in the vault
Get-AzDataProtectionBackupProtectedItem -Vault $TestBkpVault | fl
```
