#!/bin/bash

IF=wlp1s0

sudo ./bridge.sh $IF

qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -machine q35,accel=kvm \
    -smp 8,cores=4 \
    -cpu Penryn,vendor=GenuineIntel,kvm=on,+sse3,+sse4.2,+aes,+xsave,+avx,+xsaveopt,+xsavec,+xgetbv1,+avx2,+bmi2,+smep,+bmi1,+fma,+movbe,+invtsc \
    -smbios type=2 \
    -nodefaults \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
    -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -vga qxl \
    -usb \
    -device usb-kbd \
    -device usb-mouse \
    -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
    -device vmxnet3,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
    -drive id=ESP,if=virtio,format=qcow2,file=OpenCore.qcow2 \
    -drive id=macOS,if=virtio,format=qcow2,file=macOS.qcow2 \

sudo ./unbridge.sh $IF
