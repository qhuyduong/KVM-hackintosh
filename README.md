# KVM-hackintosh

Credits to [DarwinKVM](https://github.com/royalgraphx/DarwinKVM) for the detailed guide for making this work.

## Create OpenCore.qcow2

```
qemu-img create -f qcow2 OpenCore.qcow2 200M
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 OpenCore.qcow2
gdisk
/dev/nbd0
w
y
gdisk
/dev/nbd0
n
1
<Enter>
<Enter>
EF00
w
y
mkfs.fat -F 32 /dev/nbd0p1
```
