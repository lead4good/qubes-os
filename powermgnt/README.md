Power management in Qubes OS
============================

**! work in progress !**

With between a few to a lot of VMs running simultanously Qubes OS will never be as power/battery friendly as a "stock" Linux distribution. This document tries to describe a few power management customizations and tweaks that should improve battery life.

Virtualization means that we'll have to tweak power management (PM) at different levels:

- Xen
- dom0
- in VMs with attached devices

Xen PM
======

Resources:
- https://wiki.xenproject.org/wiki/Xen_power_management
- http://confluence.wartungsfenster.de/display/Adminspace/Xen+Power+management#XenPowermanagement-2.dom0OS

We'll use method A (hypervisor based cpufreq implementation). Eg.:

~~~
xenpm set-scaling-governor powersave
xenpm set-sched-smt enable
xenpm set-vcpu-migration-delay 1000
xenpm enable-turbo-mode
~~~




# powermgnt

Set a few xenpm parameters and run TLP in running VMs.

Prerequisites
* 90-powermgnt-dom0.rules -> /etc/udev/rules.d
* powermgnt-dom0.service -> /etc/systemd/system
* powermgnt-dom0 -> /usr/local/bin
* TLP installed in VMs with physical devices attached (for fedora: rpm 'tlp')

After copying files in dom0:

```sh
udevadm control --reload
systemctl daemon-reload
```

Note: debug is enabled by default (DEBUG=1), so the commands will only be echoed without being run. Disable it once you're confident the script doesn't break your setup.


# TLP in dom0

Installing tlp in dom0 pulls too many dependencies. -> review and install only specific scripts (download from https://github.com/linrunner/TLP)


```
/usr/local/bin/bluetooth
/usr/local/bin/run-on-ac
/usr/local/bin/run-on-bat
/usr/local/bin/tlp-stat
/usr/local/bin/tlp-usblist
/usr/local/bin/tlp-pcilist
/usr/local/bin/wifi
/usr/local/bin/wwan
/usr/local/sbin/tlp
/usr/local/lib/pm-utils/sleep.d/49tlp
/usr/local/share/tlp-pm
/usr/local/share/tlp-pm/tlp-rf-func
/usr/local/share/tlp-pm/tlp-functions
/usr/local/share/tlp-pm/tlp-nop
/etc/systemd/system/tlp-sleep.service
/etc/systemd/system/tlp.service
/etc/udev/rules.d/85-tlp.rules
/etc/default/tlp 
```

Note: some of the scripts are probably never called (eg. wifi, wwan, ...) since there's no network adapter in dom0, and they wouldn't work anyway since some packages/functionality are missing (eg. rfkill). 
 
