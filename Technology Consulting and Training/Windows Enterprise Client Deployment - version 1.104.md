# Windows Client Security and Deployment Guide v1.4
## Table of Contents
1. [Scope, Objectives, and Assumptions](#1-scope-objectives-and-assumptions)
2. [Hardware and OS Prerequisites](#2-hardware-and-os-prerequisites)
3. [Pre-Domain vs Post-Domain Deployment Summary](#3-pre-domain-vs-post-domain-deployment-summary)
4. [Windows Edition Selection and Support Lifecycle](#4-windows-edition-selection-and-support-lifecycle)
5. [Identity and Credential Protection / Account Management (Pre-Domain)](#5-identity-and-credential-protection--account-management-pre-domain)
6. [Platform and Operating System Hardening](#6-platform-and-operating-system-hardening)
7. [Logging, Auditing, and Verification](#7-logging-auditing-and-verification)
7a. [Windows 10 Audit Policy Verification Process](#7a-windows-10-audit-policy-verification-process)
7b. [Windows 11 Audit Policy Note](#7b-windows-11-audit-policy-note)
8. [Patch and Update Strategy](#8-patch-and-update-strategy)
9. [Security Hardening Verification and Audit](#9-security-hardening-verification-and-audit)
10. [Backup and Data Resilience](#10-backup-and-data-resilience)
11. [Imaging and Deployment Methodology](#11-imaging-and-deployment-methodology)
12. [Documentation and Handoff Requirements](#12-documentation-and-handoff-requirements)
13. [References](#13-references)
## 1. Scope, Objectives, and Assumptions
### Policy
This document defines security and deployment requirements for Windows client operating systems prior to and immediately following domain or identity provider integration. It applies to all physical and virtual Windows client systems in managed environments, including corporate, regulated, and security-sensitive use cases.

**Objective:** Establish a secure, repeatable, and auditable baseline that reduces attack surface, enforces least privilege, protects credentials and data, and ensures recoverability. Systems unable to meet these requirements must be formally documented as exceptions and approved through organizational risk management processes.**Rationale:** Standardized, auditable baselines reduce misconfigurations, enable faster incident response, and align with regulatory and enterprise security requirements.
### Implementation Guidance
Use this guide as the authoritative baseline for deployment and hardening. Apply controls consistently using Microsoft tooling: Local Policy, Group Policy; Microsoft Intune; Windows Autopilot, MDT, or Configuration Manager. Align all configurations with Microsoft Security Baselines and supported Windows features. Document deferred enforcement steps to be applied post-domain or MDM enrollment. Validate configurations using built-in Windows security indicators, PowerShell verification commands, and event logging. This guide defines minimum standards; additional controls may be added based on risk tolerance or regulatory requirements.
## 2. Hardware and OS Prerequisites
### Policy
Enterprise security features require compatible hardware and supported OS editions.
| Requirement | Minimum |
|-------------|---------|
| CPU | 64-bit, SLAT-capable |
| TPM | 2.0 |
| Secure Boot | Enabled |
| RAM | 8 GB (recommended 16 GB) |
| Disk | SSD preferred |
| UEFI | Required for Credential Guard, BitLocker TPM, and WDAC |
### Implementation Guidance
Verify hardware meets requirements before deployment. Use `systeminfo` or `Get-ComputerInfo` to confirm system details. Document hardware validation.
### Verification Commands
- CPU/Architecture: `Get-ComputerInfo | Select-Object CsProcessors,OsArchitecture`
- TPM Status: `Get-Tpm`
- Secure Boot: `Confirm-SecureBootUEFI`
- UEFI: `Get-WmiObject -Class Win32_ComputerSystem | Select-Object BootROMVersion`
- RAM: `Get-ComputerInfo | Select-Object CsTotalPhysicalMemory`
## 3. Pre-Domain vs Post-Domain Deployment Summary
| Control / Feature | Pre-Domain Enforcement | Post-Domain / MDM Enforcement |
|------------------|----------------------|-------------------------------|
| Local Policy / Group Policy | ✅ Basic policies (password, account lockout, firewall) | ✅ Full baseline policies via GPO/Intune |
| BitLocker | ✅ TPM-based encryption enabled | ✅ Recovery key escrow verified and enforced |
| Administrative Accounts | ✅ Temporary admin accounts created | ✅ Temporary accounts removed; domain admin delegation applied |
| Standard Accounts | ✅ Least privilege accounts configured | ✅ Domain user accounts enforced |
| Credential Guard / VBS | ⚠️ Enterprise-only; pre-domain if hardware allows | ✅ Fully enabled on Enterprise endpoints |
| AppLocker / WDAC | ⚠️ Limited enforcement pre-domain | ✅ Full enforcement post-domain |
| Attack Surface Reduction (ASR) Rules | ⚠️ Basic ASR if possible | ✅ Full ASR rules applied per baseline |
| Windows Defender / Antivirus | ✅ Enabled | ✅ Full policy + cloud protection and tamper protection |
| Firewall | ✅ Enabled, block unsolicited inbound | ✅ Profile enforcement via domain/Intune |
| Logging / Auditing | ✅ Basic event logging enabled | ✅ Advanced auditing, centralized log forwarding configured |
| Patch Compliance | ⚠️ Ensure latest security updates pre-domain | ✅ Updates enforced and monitored post-domain |
| Recovery & Backup | ✅ Local recovery media prepared | ✅ Backup strategy integrated with enterprise systems |
| Imaging / Deployment | ✅ Standardized image applied | ✅ Baseline compliance validated, policies applied |
**Legend:** ✅ = Fully enforced ⚠️ = Partial or hardware-dependent enforcement
## 4. Windows Edition Selection and Support Lifecycle
### Policy
Windows edition must align with security requirements, compliance obligations, and enterprise feature needs.**Rationale:** Enterprise features such as Credential Guard, WDAC, AppLocker, and full ASR enforcement are only available in Enterprise editions.
### Implementation Guidance
Evaluate endpoint risk, regulatory requirements, and required security controls. **Pro Edition:** BitLocker with TPM, Local Group Policy, Defender Antivirus/Firewall, Windows Update for Business **Enterprise Edition:** All Pro features plus AppLocker, WDAC, Credential Guard, Device Guard, full ASR enforcement, Defender for Endpoint EDR
| Feature | Pro | Enterprise |
|------|------|------------|
| BitLocker | ✅ | ✅ |
| Local Group Policy | ✅ | ✅ |
| AppLocker | ❌ | ✅ |
| WDAC | ❌ | ✅ |
| Credential Guard | ❌ | ✅ |
| Device Guard | ❌ | ✅ |
| Defender Antivirus | ✅ | ✅ |
| Defender for Endpoint | ❌ | ✅ |
| ASR Rules | ❌ | ✅ |
| Security Baseline Enforcement | Limited | Full |
### Verification Commands
- Edition: `Get-ComputerInfo | Select-Object WindowsProductName, WindowsEditionId`
- Optional Features: `Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"}`
## 5. Identity and Credential Protection / Account Management (Pre-Domain)
### Policy
Local and domain identities must follow least privilege. Administrative privileges should be minimized. Disable or rename built-in Administrator and create a temporary deployment admin account. Remove temporary accounts post-domain join. Enable Credential Guard and VBS on Enterprise endpoints.
### Implementation Guidance
**Administrative Accounts:** Create temporary local admin accounts for deployment only, disable or rename built-in Administrator, remove temporary accounts immediately post-deployment. **Standard Accounts:** Configure standard accounts for daily operations, restrict installation of unapproved software. **Passwords and Authentication:** Enforce complexity, expiration, history, account lockout policies, enable Windows Hello for Business or equivalent. **Credential Protection:** Enable [Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/) and [VBS](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs). **Documentation & Verification:** Record all local accounts, transitions, and exceptions, verify account configuration via PowerShell and event logs.
### Verification Commands
- List local admins: `Get-LocalGroupMember -Group "Administrators"`
- Check built-in Administrator status: `Get-LocalUser -Name "Administrator" | Select-Object Name, Enabled`
- Credential Guard status: `Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard`
- VBS status: `systeminfo | findstr /C:"Hyper-V Requirements"`
## 6. Platform and Operating System Hardening
### Policy
All systems must be hardened before production. Hardening reduces attack surface and protects integrity and data.
### Implementation Guidance
**BitLocker & Disk Encryption:** Enable TPM-based BitLocker, escrow keys ([BitLocker Recovery](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/recovery-overview)), verify `manage-bde -status`. **Defender & Exploit Protection:** Enable Defender, cloud protection, tamper protection, exploit protection ([Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/)). **Firewall:** Enable for all profiles, block unsolicited inbound connections. **Application Control:** Deploy AppLocker/WDAC on Enterprise, remove unnecessary startup apps. **ASR:** Enable per Microsoft Security Baselines ([ASR Rules](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/attack-surface-reduction)). **Unnecessary Services:** Disable/remove non-essential services (SMBv1, Telnet, unused print spooler). **Recovery & Rebuild:** Prepare bootable recovery media, standardize rebuilds via Autopilot/ConfigMgr, integrate into incident response, test recovery paths.  
### Verification Commands
- BitLocker: `Get-BitLockerVolume`
- Defender: `Get-MpComputerStatus`
- Firewall: `Get-NetFirewallProfile | Select Name, Enabled, DefaultInboundAction`
- ASR rules: `Get-MpPreference | Select AttackSurfaceReductionRules_Ids, AttackSurfaceReductionRules_Actions`
- Disabled services: `Get-Service | Where-Object {$_.StartType -eq "Disabled"}`
## 7. Logging, Auditing, and Verification
### Policy
Enable logging/auditing to capture security events supporting compliance, incident response, and forensics.
### Implementation Guidance
Enable basic and advanced audit policies ([Audit Policies](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings)), configure Event Log retention ([Event Log Overview](https://learn.microsoft.com/en-us/windows/win32/eventlog/event-logging)), protect logs from tampering, prepare for centralized log forwarding post-domain.
### Verification Commands
- Event log size/retention: `wevtutil gl System`
- Centralized logging config: `Get-WinEvent -ListLog *`
## 7a. Windows 10 Audit Policy Verification Process
### Policy
Windows 10 endpoints must have audit policies configured per Microsoft Security Baselines.
### Implementation Guidance
**1. List all categories/subcategories:** `auditpol /get /category:*`  
**2. Export report:** `auditpol /get /category:* /r > C:\AuditPolicyReport.txt`  
**3. Query specific subcategories:** `auditpol /get /subcategory:"Credential Validation"`  
**4. Compare against baseline** and document deviations  
**5. Automate verification:**  
```powershell
$audit = auditpol /get /category:* 
$audit | Out-String | Select-String "Logon"
```
**6. Remediation:**  
```powershell
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable
```
**7. Workflow:** Capture outputs, compare to baseline, remediate, document results.
## 7b. Windows 11 Audit Policy Note
Windows 11 supports `Get-AuditPolicy` in PowerShell. Example:  
```powershell
Get-AuditPolicy | Format-Table -AutoSize
```
- Filter specific categories:  
```powershell
Get-AuditPolicy | Where-Object {$_.Category -eq "Logon/Logoff"}
```
## 8. Patch and Update Strategy
### Policy
Systems must be fully patched prior to production use.
### Implementation Guidance
Use [Windows Update](https://learn.microsoft.com/en-us/windows/deployment/update/waas-manage-updates-wufb) or ConfigMgr. Apply security updates promptly, defer feature updates if needed. Track and document compliance.
### Verification Commands
- Check updates: `Get-WindowsUpdateLog` / `Get-HotFix`
- Pending updates: `Get-WindowsUpdate -IsInstalled $false`
## 9. Security Hardening Verification and Audit
### Policy
All systems must undergo verification to confirm hardening and audit readiness.
### Implementation Guidance
Verify BitLocker, Defender, firewall, ASR, credential guard/VBS, and audit policies. Collect evidence, document remediation, ensure baseline alignment.
### Verification Commands
- BitLocker: `Get-BitLockerVolume`
- Defender: `Get-MpComputerStatus`
- Firewall: `Get-NetFirewallProfile | Select Name, Enabled, DefaultInboundAction`
- ASR: `Get-MpPreference | Select AttackSurfaceReductionRules_Ids, AttackSurfaceReductionRules_Actions`
- Audit: Windows 10: `auditpol /get /category:*`, Windows 11: `Get-AuditPolicy`
- Credential Guard / VBS: `Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard`
## 10. Backup and Data Resilience
### Policy
Implement enterprise-grade backup and recovery for user data, system configs, and applications.
### Implementation Guidance
Windows-native: [File History](https://learn.microsoft.com/en-us/windows/compatibility/new-file-history-feature), [System Image Backup](https://learn.microsoft.com/en-us/answers/questions/4376899/(article)-how-to-create-a-system-image-in-windows). Encrypt backups, define RPO/RTO, test restores, integrate into incident response.
### Verification Commands
- File History: `Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\FileHistory"`
- System Image: `wbadmin get versions`
- Backup schedule: `Get-ScheduledTask | Where-Object {$_.TaskName -like "*Backup*"}`
## 11. Imaging and Deployment Methodology
### Policy
Deploy systems using standardized, repeatable, auditable methods.
### Implementation Guidance
Use Autopilot or ConfigMgr. Maintain updated reference images, automate task sequences, validate baseline compliance.
### Verification Commands
- Check Autopilot profile: `Get-AutopilotProfile`
- ConfigMgr client: `Get-CMDevice | Select Name, ClientVersion`
## 12. Documentation and Handoff Requirements
### Policy
Comprehensive documentation required before production approval.
### Implementation Guidance
Document configurations, baselines, recovery procedures, backup strategy, deployment steps. Maintain audit-ready records. Require formal sign-off prior to domain join.
## 13. References
- [Microsoft Security Baselines](https://learn.microsoft.com/en-us/mem/intune/protect/security-baselines)
- [Windows Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/)
- [Virtualization-Based Security (VBS)](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs)
- [BitLocker Recovery Overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/recovery-overview)
- [Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/)
- [WDAC Overview](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/wdac)
- [ASR Rules Overview](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/attack-surface-reduction)
- [Deploy Clients with ConfigMgr](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/deploy/deploy-clients-to-windows-computers)
- [File History Backup](https://learn.microsoft.com/en-us/windows/compatibility/new-file-history-feature)
- [System Image Backup](https://learn.microsoft.com/en-us/answers/questions/4376899/(article)-how-to-create-a-system-image-in-windows)
- [Windows Update for Business](https://learn.microsoft.com/en-us/windows/deployment/update/waas-manage-updates-wufb)
- [Windows Event Log Overview](https://learn.microsoft.com/en-us/windows/win32/eventlog/event-logging)
- [Advanced Audit Policy Settings](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings)
