# Windows Client Security and Deployment Guide

## 1. Scope, Objectives, and Assumptions
### Policy
This document defines the security and deployment requirements for Windows client operating systems prior to and immediately following domain or identity provider integration. It applies to all physical and virtual Windows client systems deployed in managed environments, including corporate, regulated, and security-sensitive use cases.  
The objective is to establish a secure, repeatable, and auditable baseline that reduces attack surface, enforces least privilege, protects credentials and data, and ensures recoverability. This guide assumes a defense-in-depth approach and prioritizes security controls that are enforceable, measurable, and aligned with Microsoft-supported configurations. Systems that cannot meet these requirements must be formally documented as exceptions and approved through organizational risk management processes.

### Implementation Guidance
Use this document as the authoritative baseline for Windows client deployment and hardening. Apply controls consistently across all endpoints using supported Microsoft tooling such as:
- Local Policy, Group Policy
- Microsoft Intune
- Windows Autopilot, Microsoft Deployment Toolkit, or Configuration Manager
- All configurations should align with Microsoft Security Baselines and supported Windows features for the selected edition

Where controls cannot be enforced pre-domain, document deferred enforcement steps to be applied immediately after domain or MDM enrollment. Validate configurations using:
- Built-in Windows security status indicators
- PowerShell verification commands
- Event logging

Treat this guide as a minimum standard; additional controls may be layered based on organizational risk tolerance or regulatory requirements.

---

## 2. Windows Edition Selection and Support Lifecycle
### Policy
The Windows edition selected for deployment must align with organizational security requirements, compliance obligations, and required enterprise features. Low-risk or temporary endpoints may use Windows Pro, but production, high-risk, or compliance-sensitive endpoints must use Windows Enterprise. The edition decision impacts enforceable security controls including application control, credential protection, attack surface reduction, and baseline compliance. Unsupported or misaligned editions may create security gaps or non-compliance risks. Organizations must document edition decisions, including exceptions or temporary deployments, and review them regularly against support lifecycle requirements.

### Implementation Guidance
- Evaluate endpoint risk, regulatory requirements, and required security controls to determine edition selection
- Windows Pro supports: BitLocker with TPM, Local Group Policy, Windows Defender Antivirus and Firewall, Windows Update for Business
- Windows Enterprise supports all Pro features plus: AppLocker, Windows Defender Application Control (WDAC), Credential Guard, Device Guard, full ASR rule enforcement, and Microsoft Defender for Endpoint EDR

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

- Verify edition and features using `winver`, `Get-ComputerInfo`, or `Get-WindowsOptionalFeature`
- Align configurations with Microsoft Security Baselines
- Ensure alignment with Microsoft support lifecycle

---

## 3. Identity and Credential Protection / Account Management (Pre-Domain)
### Policy
Local and domain identities must follow the principle of least privilege. Administrative privileges should be minimized and used only when necessary. Shared or unmanaged accounts are prohibited. Credential protection features such as Windows Credential Guard and virtualization-based security (VBS) must be enabled on Enterprise systems to protect high-value credentials and reduce the risk of lateral movement. Temporary local accounts may be used for deployment and staging purposes but must be documented and removed or transitioned after domain or MDM enrollment.

### Implementation Guidance
- **Administrative Accounts**
  - Create a temporary local administrative account for deployment tasks only
  - Disable or rename the built-in Administrator account
  - Remove temporary accounts immediately after deployment or domain join
- **Standard Accounts**
  - Configure standard accounts for daily operations
  - Ensure least privilege and prevent installation of unapproved software
- **Passwords and Authentication**
  - Enforce password complexity, minimum length, expiration, and history
  - Implement account lockout policies
  - Enable Windows Hello for Business or other modern authentication methods
- **Credential Protection**
  - Enable Windows Credential Guard ([Credential Guard](https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/))
  - Enable Virtualization-Based Security ([VBS](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-vbs))
- **Documentation and Verification**
  - Record all local accounts, transitions, and exceptions
  - Validate account and security configurations using PowerShell and event logs

---

## 4. Platform and Operating System Hardening
### Policy
All Windows client systems must be hardened prior to production deployment to reduce the attack surface and protect system integrity and data at rest. Hardening includes disk encryption, endpoint protection, firewall configuration, unnecessary service reduction, application control, attack surface reduction, and recovery readiness. Enterprise security features must be applied where available, and deviations must be documented and approved.

### Implementation Guidance
- **BitLocker and Disk Encryption**
  - Enable BitLocker on all system and data volumes using TPM-based protection
  - Escrow recovery keys securely ([BitLocker Recovery Overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/recovery-overview))
  - Verify status using `manage-bde -status`
- **Windows Defender Antivirus and Exploit Protection**
  - Enable Defender Antivirus, cloud protection, tamper protection, and exploit protection ([Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/))
- **Firewall Configuration**
  - Enable Windows Defender Firewall for all profiles
  - Block unsolicited inbound connections by default
- **Application Control**
  - Deploy AppLocker or WDAC on Enterprise editions ([WDAC Overview](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/wdac))
  - Remove unnecessary startup applications
- **Attack Surface Reduction (ASR)**
  - Enable ASR rules aligned with Microsoft Security Baselines ([ASR Rules Overview](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/attack-surface-reduction))
- **Unnecessary Services and Features**
  - Disable or remove non-essential services (e.g., SMBv1, Telnet, unused print spooler)
- **Recovery and Rebuild Readiness**
  - Prepare bootable recovery media
  - Define repair vs reimage criteria
  - Standardize rebuilds using Autopilot or Configuration Manager ([Deploy Clients with ConfigMgr](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/deploy/deploy-clients-to-windows-computers))
  - Integrate rebuild procedures into incident response planning
  - Test recovery paths periodically and document results

---

## 5. Logging, Auditing, and Verification
### Policy
All Windows client systems must enable logging and auditing to capture security-relevant events. Logs must support compliance, incident response, and forensic investigation requirements.

### Implementation Guidance
- Enable basic and advanced audit policies ([Basic Security Audit Policies](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/basic-security-audit-policies), [Advanced Audit Policy Settings](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/advanced-security-audit-policy-settings))
- Configure Windows Event Log retention and size ([Windows Event Log Overview](https://learn.microsoft.com/en-us/windows/win32/eventlog/event-logging))
- Protect logs from tampering
- Prepare for centralized log forwarding post-domain join
- Verify audit events and document results

---

## 6. Patch and Update Strategy
### Policy
All systems must be fully patched prior to production use.

### Implementation Guidance
- Use [Windows Update](https://learn.microsoft.com/en-us/windows/deployment/update/waas-manage-updates-wufb) or Configuration Manager
- Apply security updates promptly; defer feature updates as needed
- Verify update compliance before deployment
- Track update status and maintain audit records

---

## 7. Security Hardening Verification and Audit
### Policy
All systems must undergo verification to confirm security hardening and audit readiness.

### Implementation Guidance
- Verify BitLocker, Defender, firewall, ASR, and audit policies
- Collect evidence of compliance
- Document remediation actions
- Ensure baseline alignment with Microsoft Security Baselines

---

## 8. Backup and Data Resilience
### Policy
Windows client systems must implement enterprise-grade backup and recovery strategies. Protect user data, system configuration, and critical application data to ensure rapid recovery.

### Implementation Guidance
- Use Windows-native features: [File History](https://learn.microsoft.com/en-us/windows/compatibility/new-file-history-feature), [System Image Backup](https://learn.microsoft.com/en-us/answers/questions/4376899/(article)-how-to-create-a-system-image-in-windows)
- Backup to secure, encrypted storage
- Define recovery point objectives (RPO) and recovery time objectives (RTO)
- Periodically test restores and maintain logs
- Integrate backup strategy into incident response plans
- Ensure cloud or offsite replication for high-value data

---

## 9. Imaging and Deployment Methodology
### Policy
All Windows client systems must be deployed using standardized, repeatable, and auditable methods.

### Implementation Guidance
- Use Windows Autopilot or Configuration Manager
- Maintain updated reference images
- Use automated task sequences for imaging, policy application, and software deployment
- Validate baseline compliance post-deployment

---

## 10. Documentation and Handoff Requirements
### Policy
Comprehensive documentation is required before production approval.

### Implementation Guidance
- Document configurations, baselines, recovery procedures, backup strategy, and deployment steps
- Maintain audit-ready records
- Require formal sign-off prior to domain join

---

## 11. References
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
