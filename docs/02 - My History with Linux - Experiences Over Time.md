# My History with Linux - Experiences over time

Author: Jason McGinn  
Date: February 2026  

This document is shared for reference and learning purposes.  
You are welcome to use and adapt this material, provided attribution to the original author is maintained.
— Jason McGinn


**For me, Linux isn't just a technical skill—it’s the essential layer that enables comprehensive, infrastructure-level thinking.**

## Purpose
This document outlines my practical experience with Linux. My Linux skills were not acquired in isolation or through theory-heavy study. They were developed organically through real-world needs — solving problems, building systems, hosting services, automating workflows, and supporting infrastructure.

This reflects applied experience rather than specialization in a single distribution or role.

---
## Early Exposure
My use of Linux began through curiosity and experimentation — installing distributions, breaking systems, rebuilding them, and learning through iteration.

**Key early experiences included:**
* Installing and configuring multiple Linux distributions 
	* Debian, Slackware, Red Hat, and SUSE) and BSD systems
* Manual X Server installation and configuration via the command line
* Dual-boot environments and partition management
* Basic shell usage and package management
* Network configuration and service troubleshooting
* SSH access and remote administration
* Verifying module loading and resolving driver conflicts

Compiling kernels and integrating drivers was done when required to make hardware function properly. This required understanding kernel configuration workflows, module vs. built-in driver decisions, dependency handling, bootloader interaction, and recovery procedures if a kernel failed to load.

---
## Infrastructure & Service Hosting
Linux was always a practical tool when I needed systems that were stable, lightweight, and controllable.

**Applied areas:**
* Hosting production deployments, internal services, and lab environments
* Custom firmware installations on various hardware
* Web server setup (Apache/Nginx)
* Database deployment (MySQL/MariaDB/PostgreSQL)
* Squid Proxy configurations (deployed in all modes: forward, reverse, and transparent)

These were driven by project requirements rather than academic exercises.

---
## Automation & Scripting
As environments grew more complex, I relied on automation to reduce manual repetition.

**Experience includes:**
* Bash and Python scripting for task automation
* Automated alerting and notifications — configuring mail server integration to send system status, task completion, or error alerts via email
* Cron-based scheduling
* System monitoring scripts
* Log parsing and filtering
* Environment provisioning scripts

I use scripting pragmatically — to solve problems efficiently — rather than as a primary development focus.

---
## Containerization & Modern Workloads
Linux is my foundation for working with containerized workloads.

**Experience includes:**
* Docker installation and image management
* Writing and maintaining Dockerfiles
* Running and troubleshooting containers
* Volume and network configuration
* Basic orchestration exposure
* Kubernetes cluster experimentation and workload deployment

My focus has been **operational understanding to build better infrastructure options**
Troubleshooting along the way has taught how workloads run, fail, scale, and recover.

---
## Security & System-Level Work
Security practices and deeper system familiarity were learned through necessity — especially when hardware compatibility or infrastructure requirements required going beyond distribution defaults.

**Experience includes:**
* System hardening and security operations — applying security baselines across virtualized environments, integrated with comprehensive auditing, centralized logging, and proactive alerting frameworks
* SSL/TLS certificate management — including proxy testing to analyze how certificates are validated, authenticated, and how they encrypt traffic
* Advanced firewall configuration (iptables / ufw) — utilizing log analysis to trigger automated scripts that modify firewall rules or operating system states in real-time
	* Implementing port knocking techniques for stealth service access
* Traffic encapsulation and securing communications via SSH tunnels
* Snort (Intrusion Detection and Prevention) — learning traffic patterns
* Fail2ban and other OS-layer monitoring 
* Log review, anomaly detection, and patch management discipline
* Minimal-service deployment philosophy

I approach Linux systems with a “control the stack when necessary” mindset and a consistent focus on reducing attack surface.

---
## Networking & Diagnostic Mindset
A significant portion of my Linux experience involved network-level visibility and validation. I became comfortable using CLI networking tools as part of normal troubleshooting and system verification workflows.

**Tools and utilities I have used include:**
* **tcpdump** (packet inspection and traffic validation)
* **ss / netstat** (socket and port inspection)
* **ip** (interface and routing configuration)
* **iptables** (rule inspection and traffic filtering)
* **nmap** (network discovery and port scanning)
* **Snort** (IDS alert review and traffic analysis)
* **nslookup / dig** (DNS validation)

**These tools were used to:**
* Verify service exposure and confirm firewall rule behavior
* Validate routing decisions and troubleshoot connectivity failures
* Review suspicious traffic patterns
* Compare internal vs. external service presentation

This developed a habit of validating assumptions at the packet and port level rather than relying solely on application-layer errors. It also provided tangible evidence of the functionality and output of my system.

---
## Troubleshooting Approach
Linux strengthened my problem-solving discipline.

**Common activities:**
* Reading logs first
* Verifying service states
* Reviewing permissions and ownership
* Checking open ports and listeners
* Identifying resource bottlenecks (CPU, memory, disk I/O)
* Reviewing kernel messages (**dmesg**) when diagnosing hardware or driver issues

I am comfortable diagnosing from the CLI without relying on GUI tooling.

---
## Current Use
Today, Linux remains central to:
* Lab environments and container workloads
* Automation experiments and infrastructure testing
* Self-hosted services and observability experiments

---
## Summary
I am not positioning myself as a Linux kernel developer or distribution maintainer.

**What I am:**
* **Terminal-fluent**
* **Operationally competent**
* **Automation-oriented**
* **Security-conscious**
* **Capable of building and maintaining Linux-based infrastructure**

Everything I know about Linux was learned through application; by constantly utilizing man pages, internet searches, and technical documentation, as well as seeking guidance from those more experienced in Linux. If a system needed to run, scale, or be secured — I learned what was necessary to make it work.