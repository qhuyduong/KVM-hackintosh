# KVM-hackintosh

Credits to [DarwinKVM](https://github.com/royalgraphx/DarwinKVM) for the detailed guide for making this work.

## Create OpenCore.qcow2

```
qemu-img create -f qcow2 OpenCore.qcow2 200M
sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 OpenCore.qcow2
sudo gdisk
/dev/nbd0
n
1
<Enter>
<Enter>
EF00
w
y
sudo mkfs.fat -F 32 -n EFI /dev/nbd0p1
```
