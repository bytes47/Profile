
## Getting Infrastructure Mode Usable on Linux (Debian, Kernel 2.6.24 Era)

In 2008, Linux support for Wi-Fi hardware was inconsistent. My Debian system included a **Realtek RTL8187** adapter, which lacked usable drivers in the kernel. Without a compatible driver, Wi-Fi functionality was unavailable, limiting my ability to use WIFI in Linux.

To solve this, I configured a Linux development environment and learned to edit the kernel using `make menuconfig`. I obtained community-maintained drivers, integrated them into a custom kernel, and installed it via the GRUB bootloader. Rebooting confirmed the adapter was operational.

A few years later, with a **Toshiba A20**, I repeated the process, identifying all hardware components via the command line and building a **minimal, hardware-specific kernel**.

This project reinforced **practical problem-solving**, low-level system understanding, and the ability to adapt infrastructure to unsupported hardware when official support was unavailable.


## Custom Reporting and Database Tools for Syspro 7

At a door and window manufacturing plant, multiple departments relied on **Syspro 7 ERP**, but custom reporting and data updates were costly and time-consuming. Accounting, product management, manufacturing, and sales faced repetitive tasks, slow access to critical information, and frequent errors.

To solve this, I built a **virtual Linux server** hosting a custom web interface. SQL scripts executed via PHP leveraged temporary tables, functions, and security controls to prevent accidental data changes. Reports were delivered through **Crystal Reports** or the web interface depending on departmental needs. I tested changes on fresh database copies and maintained a restore process for production safety.  

The solution streamlined inventory updates, centralized access to key information, and improved Microsoft SQL performance and stability. Direct engagement with users ensured tools aligned with workflows, eliminating technical bottlenecks and reducing operational errors. This reinforced the importance of **practical problem-solving and workflow-driven development**.



