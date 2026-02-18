
## Enterprise Infrastructure and Multi-Project Enablement

As an Infrastructure Consultant, I supported multiple simultaneous deployments and migrations for clients moving from their current solutions to Dynamics 365 Finance and Operations. Each project had unique deployment options and customizations, but the information the infrastructure technical leads required for configuration management and training was largely consistent across deployments.

After refining the required Azure services and deployment processes for the infrastructure, I automated them with PowerShell scripts. This ensured consistent environments for each project, with changes handled primarily through variable updates and minor adjustments. In addition, I automated several developer processes using DevOps pipelines, improving efficiency and reducing manual effort across projects.

To manage the complexity of multiple projects, I implemented a documentation process: all configuration options, environment variables, and critical data points were logged in Excel for consistent tracking across deployments. Using this dataset, I generated polished technical manuals via mail merge, producing **complete, guide-based instructions** for deploying new instances from scratch, configuring services, and handling operational considerations specific to the client.

This approach enabled the client’s technical leads to quickly understand and execute deployments across projects without confusion or errors. The project reinforced the value of **structured documentation, multi-project organization, practical enablement, and workflow automation** in complex enterprise migrations.

## Getting Infrastructure Mode Usable on Linux (Debian, Kernel 2.6.24 Era)

In 2008, Linux support for Wi-Fi hardware was inconsistent. My Debian system included a **Realtek RTL8187** adapter, which lacked usable drivers in the kernel. Without a compatible driver, Wi-Fi functionality was unavailable, limiting my ability to use WIFI in Linux.

To solve this, I configured a Linux development environment and learned to edit the kernel using `make menuconfig`. I obtained community-maintained drivers, integrated them into a custom kernel, and installed it via the GRUB bootloader. Rebooting confirmed the adapter was operational.

A few years later, with a **Toshiba A20**, I repeated the process, identifying all hardware components via the command line and building a **minimal, hardware-specific kernel**.

This project reinforced **practical problem-solving**, low-level system understanding, and the ability to adapt infrastructure to unsupported hardware when official support was unavailable.


## Custom Reporting and Database Tools for Syspro 7

At a door and window manufacturing plant, multiple departments relied on **Syspro 7 ERP**, but custom reporting and data updates were costly and time-consuming. Accounting, product management, manufacturing, and sales faced repetitive tasks, slow access to critical information, and frequent errors.

To solve this, I built a **virtual Linux server** hosting a custom web interface. SQL scripts executed via PHP leveraged temporary tables, functions, and security controls to prevent accidental data changes. Reports were delivered through **Crystal Reports** or the web interface depending on departmental needs. I tested changes on fresh database copies and maintained a restore process for production safety.  

The solution streamlined inventory updates, centralized access to key information, and improved Microsoft SQL performance and stability. Direct engagement with users ensured tools aligned with workflows, eliminating technical bottlenecks and reducing operational errors. This reinforced the importance of **practical problem-solving and workflow-driven development**.



