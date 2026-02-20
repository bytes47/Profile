
# Windows Client Security and Deployment Guide v1.063
## Table of Contents
1. Scope, Objectives, and Assumptions
2. Hardware and OS Prerequisites
3. Pre-Domain vs Post-Domain Deployment Summary
4. Windows Edition Selection and Support Lifecycle
5. Identity and Credential Protection / Account Management (Pre-Domain)
6. Platform and Operating System Hardening
7. Logging, Auditing, and Verification
7.1 Windows 10 Audit Policy Verification Process
7.2 Windows 11 Audit Policy Note
8. Patch and Update Strategy
9. Security Hardening Verification and Audit
10. Backup and Data Resilience
11. Imaging and Deployment Methodology
12. Documentation and Handoff Requirements
13. References

## 1. Scope, Objectives, and Assumptions
### Policy
This document defines mandatory security and deployment requirements for Windows client operating systems prior to and immediately following domain or identity provider integration. It applies to all physical and virtual Windows client systems in managed environments.
Objective: Establish a secure, repeatable, and auditable baseline that reduces attack surface, enforces least privilege, protects credentials and data, and ensures recoverability.
Systems unable to meet these requirements must be documented as formal exceptions and approved through organizational risk management processes.
Rationale: Standardized, auditable baselines reduce misconfigurations, enable faster incident response, and align with regulatory and enterprise security requirements.
### Implementation Guidance
Use this guide as the authoritative baseline.
Apply controls consistently using:
- Local Policy
- Group Policy
- Microsoft Intune
- Windows Autopilot
- Microsoft Deployment Toolkit
- Configuration Manager
All configurations must align with Microsoft Security Baselines and supported Windows features.
Deferred enforcement steps must be documented and tracked.
Verification must be performed using built-in Windows security indicators, PowerShell validation, and event logging.

## 2. Hardware and OS Prerequisites
### Policy
Enterprise security features require compatible hardware and supported OS editions.

| Requirement | Minimum |
|-------------|---------|
| CPU | 64-bit, SLAT-capable |
| TPM | 2.0 |
| Secure Boot | Enabled and validated |
| RAM | 8 GB (16 GB recommended) |
| Disk | SSD recommended |
| UEFI | Required for Secure Boot, Credential Guard, and strongest WDAC enforcement |
Secure Boot and virtualization-based security prerequisites must be validated prior to enabling Credential Guard or WDAC.
### Implementation Guidance
Hardware compatibility must be verified before deployment.
### Verification Commands
- `Get-ComputerInfo | Select CsProcessors,OsArchitecture`
- `Get-Tpm`
- `Confirm-SecureBootUEFI`
- `systeminfo | findstr /C:"Virtualization-based Security"`

## 3. Pre-Domain vs Post-Domain Deployment Summary
| Control | Pre-Domain | Post-Domain |
|--------|------------|-------------|
| Local Policy | Basic enforcement | Full baseline via GPO/Intune |
| BitLocker | TPM encryption enabled | Recovery key escrow enforced |
| Admin Accounts | Temporary deployment accounts | Removed or disabled post-validation |
| Standard Accounts | Least privilege enforced | Domain policies applied |
| Credential Guard | Possible with validated hardware | Enforced via GPO/MDM |
| WDAC/AppLocker | Limited pre-domain | Fully enforced |
| ASR Rules | Locally configurable; local event logging only | Centrally managed with Defender visibility |
| Defender AV | Enabled | Policy + cloud + tamper protection |
| Firewall | Enabled | Profile enforcement |
| Logging | Basic logging | Centralized logging |
| Patch Compliance | Current at build time | Enforced and monitored |
| Backup | Local recovery prepared | Integrated enterprise backup |

## 4. Windows Edition Selection and Support Lifecycle
### Policy
Windows edition must align with required security controls and compliance obligations.
Enterprise features such as WDAC, AppLocker, Credential Guard, and centrally managed ASR enforcement require Enterprise licensing and management tooling.

| Feature | Pro | Enterprise |
|---------|-----|------------|
| BitLocker | Yes | Yes |
| AppLocker | No | Yes |
| WDAC | Limited | Full |
| Credential Guard | No | Yes |
| Defender for Endpoint | Supported (license-dependent) | Yes |
| ASR Rules | Local enforcement only | Centralized enforcement |
Verification:
- `Get-ComputerInfo | Select WindowsProductName,WindowsEditionId`

## 5. Identity and Credential Protection
### Policy
Least privilege must be enforced.
Temporary local administrator accounts may be used for deployment but must be removed or disabled after validation.
Built-in Administrator must be disabled or renamed.
Credential Guard may be enabled pre-domain if hardware and Secure Boot are validated; final enforcement is typically applied via GPO or MDM.
### Verification
- `Get-LocalGroupMember -Group "Administrators"`
- `Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -Class Win32_DeviceGuard`

## 6. Platform and Operating System Hardening
### Policy
All production systems must:
- Enable BitLocker on fixed drives
- Enable Microsoft Defender Antivirus with real-time protection
- Enable Windows Firewall on all profiles
- Configure ASR rules per baseline
- Remove or disable unnecessary services
### Verification
- `Get-BitLockerVolume`
- `Get-MpComputerStatus`
- `Get-NetFirewallProfile`

## 7. Logging, Auditing, and Verification
Advanced audit policies must be enabled in alignment with Microsoft Security Baselines.
Logs must be protected from tampering and retained per organizational policy.
### Verification
- `auditpol /get /category:*`
- `wevtutil gl System`

## 7.1 Windows 10 Audit Policy Verification Process
- `auditpol /get /category:*`
- `auditpol /get /subcategory:"Credential Validation"`

## 7.2 Windows 11 Audit Policy Note
Windows 11 and newer Windows 10 builds support:
```powershell
Get-AuditPolicy | Format-Table -AutoSize
```

## 8. Patch and Update Strategy
Systems must be fully patched prior to production use.
Documented exceptions may be permitted for validated compatibility constraints but must include risk acknowledgment and remediation timelines.
Verification:
- `Get-HotFix`
- `Get-WindowsUpdateLog`

## 9. Security Hardening Verification and Audit
All baseline controls must be validated prior to production release.
Evidence of verification must be retained for audit.

## 10. Backup and Data Resilience
Encrypted backups must be implemented.
RPO and RTO must be formally defined.
Backup frequency must meet defined RPO (Recovery Point Objective).
Systems must be restorable within defined RTO (Recovery Time Objective).
Restore testing must occur at least annually or after major system changes.
Backup retention policy must be documented.
At least one offsite or immutable backup copy is required.
Backup verification results must be documented.

## 11. Imaging and Deployment Methodology
Deployments must use standardized and version-controlled images or Autopilot provisioning.
Baseline validation must occur prior to production handoff.

## 12. Documentation and Handoff Requirements

### Policy

All deployments must include complete, accurate, and reviewable documentation prior to production release.  
Documentation must be sufficient to allow independent validation, operational support, audit review, and disaster recovery without reliance on the original implementer.

At minimum, the following must be documented:

- System identification (hostname, asset tag, OS version, edition, build number)
- Hardware specifications relevant to security features (TPM version, Secure Boot status, virtualization support)
- Applied security baseline version and configuration source (Local Policy, GPO, Intune, Autopilot, MDT, Configuration Manager)
- All security configurations implemented, including:
  - BitLocker configuration and recovery key escrow location
  - Credential Guard status
  - WDAC or AppLocker policy version
  - ASR rule configuration and enforcement mode
  - Defender Antivirus configuration
  - Firewall profile configuration
  - Audit policy configuration
- Patch level at time of release
- Backup configuration details, including:
  - Backup solution used
  - Backup frequency
  - Retention policy
  - Encryption status
  - Offsite or immutable storage confirmation
- Defined Recovery Point Objective (RPO)
- Defined Recovery Time Objective (RTO)
- Results of validation testing (security verification, restore testing if applicable)
- Any deviations, exceptions, or risk acceptances with documented approval

### Validation Evidence

Evidence must be retained in a centralized and auditable location. Acceptable evidence includes:

- PowerShell output exports
- Screenshots of security status indicators
- Exported policy configurations
- Backup verification reports
- Restore test results
- Change management tickets

Evidence must clearly demonstrate that required controls were implemented and verified prior to release.

### Exception Handling

Any deviation from this baseline must include:

- Description of the deviation
- Business justification
- Risk assessment
- Compensating controls (if applicable)
- Approval from authorized risk owner
- Defined remediation timeline

### Formal Sign-Off

Prior to production release:

- Deployment validation must be completed.
- Documentation must be reviewed for completeness.
- All required evidence must be attached.
- Responsible technical authority must formally approve the system for production use.

No system may enter production without documented sign-off and archived validation evidence.

## 13. References

### Core Security & Platform Features
- Microsoft Security Baselines  
  https://learn.microsoft.com/windows/security/threat-protection/windows-security-baselines
- BitLocker Overview  
  https://learn.microsoft.com/windows/security/information-protection/bitlocker/bitlocker-overview
- Windows Defender Antivirus  
  [[https://learn.microsoft.com/microsoft-365/security/defender-endpoint/microsoft-defender-antivirus](https://learn.microsoft.com/en-us/training/browse/?expanded=microsoft-defender%2Cms-graph&products=microsoft-defender)](https://learn.microsoft.com/en-us/training/browse/?expanded=microsoft-defender%2Cms-graph&products=microsoft-defender)
- Attack Surface Reduction (ASR) Rules  
  https://learn.microsoft.com/microsoft-365/security/defender-endpoint/attack-surface-reduction
- Credential Guard  
  https://learn.microsoft.com/windows/security/identity-protection/credential-guard/credential-guard
- Windows Firewall with Advanced Security  
  https://learn.microsoft.com/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security

### Deployment & Management
- Microsoft Intune  
  https://learn.microsoft.com/mem/intune/
- Windows Autopilot  
  https://learn.microsoft.com/mem/autopilot/
- Microsoft Deployment Toolkit (MDT)  
  **[https://learn.microsoft.com/en-us/intune/configmgr/mdt/](https://learn.microsoft.com/en-us/intune/configmgr/mdt/)
- Microsoft Configuration Manager  
  https://learn.microsoft.com/mem/configmgr/

### Auditing & Logging
- Advanced Audit Policy Configuration  
  https://learn.microsoft.com/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings
- Auditpol Command Reference  
  https://learn.microsoft.com/windows-server/administration/windows-commands/auditpol

### Update & Patch Management
- Windows Update
  [ https://learn.microsoft.com/windows/deployment/update/windows-update-for-business-overview](https://learn.microsoft.com/en-us/windows/deployment/update/waas-manage-updates-wufb)
- Get-HotFix (PowerShell)  
  https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-hotfix
- Get-WindowsUpdateLog  
  https://learn.microsoft.com/windows/deployment/update/windows-update-logs

