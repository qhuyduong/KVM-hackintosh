#!/bin/bash

VFIO_PCI_HOSTS=()

while getopts 'hp:' opt
do
    case $opt in
        h) HEADLESS=true;;
        p) VFIO_PCI_HOSTS+=($OPTARG);;
    esac
done

ARGS=(
    -enable-kvm \
    -m 4G \
    -machine q35,accel=kvm \
    -smp 8,cores=4 \
    -cpu Penryn,vendor=GenuineIntel,kvm=on,+avx,+topoext,+xsave,+xsaveopt  \
    -smbios type=2 \
    -nodefaults \
    -display gtk,zoom-to-fit=on \
    -serial stdio \
    -vga qxl \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
    -device qemu-xhci \
    -device usb-kbd \
    -device usb-mouse \
    -device virtio-net,netdev=vmnic \
    -netdev user,id=vmnic,hostfwd=tcp:127.0.0.1:9001-:22 \
    -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive id=ESP,if=virtio,format=qcow2,file=OpenCore.qcow2 \
    -drive id=macOS,if=virtio,format=qcow2,file=macOS.qcow2 \
)

[[ $HEADLESS == true ]] && {
    ARGS+=(-nographic -vnc :0 -k en-us)
}

[[ $VFIO_PCI_HOSTS ]] && {
    for value in "${VFIO_PCI_HOSTS[@]}"
    do
	ARGS+=(-device vfio-pci,host=$value,multifunction=on)
    done
}

qemu-system-x86_64 "${ARGS[@]}"
