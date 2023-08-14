#!/bin/bash

qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -machine q35,accel=kvm \
    -smp 8,cores=4 \
    -cpu Penryn,vendor=GenuineIntel,kvm=on,+sse3,+sse4.2,+aes,+xsave,+avx,+xsaveopt,+xsavec,+xgetbv1,+avx2,+bmi2,+smep,+bmi1,+fma,+movbe,+invtsc \
    -smbios type=2 \
    -nodefaults \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
    -display gtk,zoom-to-fit=on \
    -vga qxl \
    -usb \
    -device usb-kbd \
    -device usb-mouse \
    -device virtio-net,netdev=vmnic \
    -netdev user,id=vmnic,hostfwd=tcp:127.0.0.1:9001-:22 \
    -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive id=ESP,if=virtio,format=qcow2,file=OpenCore.qcow2 \
    -drive id=macOS,if=virtio,format=qcow2,file=macOS.qcow2 \
