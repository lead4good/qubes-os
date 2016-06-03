# Qubes OS stuff

## popup-appmenu

shows a popup menu (zenity list) with app vms for a given app.
 
meant to be used with a window manager's keyboard shortcuts, eg.
  - ctrl-alt-x -> popup-appmenu org.gnome.Terminal
  - ctrl-alt-f -> popup-appmenu firefox
  - ...

Screenshot: https://raw.githubusercontent.com/taradiddles/qubes-os/master/popup-appmenu.screenshot.jpg

## powermgnt

Set a few xenpm parameters and run TLP in running VMs.

Prerequisites
* 90-powermgnt-dom0.rules -> /etc/udev/rules.d
* powermgnt-dom0.service -> /etc/systemd/system
* powermgnt-dom0 -> /usr/local/bin
* qvm-list-running -> /usr/local/bin
* TLP installed in VMs (for fedora: rpm 'tlp')

After copying files in dom0:

```sh
udevadm control --reload
systemctl daemon-reload
```

Note: the script doesn't run TLP in dom0, that's the role of TLP's scripts if installed in dom0.

## TLP in dom0

Installing tlp in dom0 pulls too many dependencies. -> review and install only specific scripts.

files:

```
/etc/default/tlp
/etc/systemd/system/multi-user.target.wants/tlp.service
/etc/systemd/system/sleep.target.wants/tlp-sleep.service
/etc/systemd/system/tlp.service
/etc/systemd/system/tlp-sleep.service
/etc/udev/rules.d/85-tlp.rules
/usr/local/bin/tlp-pcilist
/usr/local/bin/tlp-stat
/usr/local/bin/tlp-usblist
/usr/local/lib/pm-utils/sleep.d/49tlp
/usr/local/sbin/tlp
/usr/local/share/tlp-pm
/usr/local/share/tlp-pm/tlp-functions
/usr/local/share/tlp-pm/tlp-nop
/usr/local/share/tlp-pm/tlp-rf-func
```

Note: we could probabvly weed out some of those scripts.
