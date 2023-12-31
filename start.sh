#!/bin/bash

VFIO_PCI_HOSTS=()

while getopts 'hp:sa' opt
do
    case $opt in
        h) HEADLESS=true;;
        p) VFIO_PCI_HOSTS+=($OPTARG);;
        s) SERIAL=true;;
	a) AMD=true;;
    esac
done

ARGS=(
    -enable-kvm \
    -m 4G \
    -machine q35,accel=kvm \
    -smbios type=2 \
    -nodefaults \
    -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
    -device virtio-net,netdev=vmnic \
    -netdev user,id=vmnic,hostfwd=tcp:127.0.0.1:9001-:22 \
    -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=OVMF_VARS.fd \
    -drive id=macOS,if=virtio,format=qcow2,file=macOS.qcow2 \
)

if [[ $HEADLESS == true ]]
then
    ARGS+=(-nographic -vnc :0 -k en-us)
else
    ARGS+=(
	-usb \
	-device usb-kbd \
	-device usb-tablet \
	-display gtk,zoom-to-fit=on \
	-vga qxl \
    )
fi

[[ $VFIO_PCI_HOSTS ]] && {
    for value in "${VFIO_PCI_HOSTS[@]}"
    do
	ARGS+=(-device vfio-pci,host=$value,multifunction=on,bus=pcie.0,addr=04.0)
    done
}

[[ $SERIAL == true ]] && {
    ARGS+=(-serial stdio)
}

if [[ $AMD == true ]]
then
    ARGS+=(
	-smp 1 \
	-cpu host,+invtsc,+svm \
	-drive id=ESP,if=virtio,format=qcow2,file=OpenCore_amd.qcow2 \
    )
else
    ARGS+=(
	-smp 16 \
	-cpu Haswell,vendor=GenuineIntel,+invtsc,-pcid,-hle,-rtm  \
	-drive id=ESP,if=virtio,format=qcow2,file=OpenCore_intel.qcow2 \
    )
fi

qemu-system-x86_64 "${ARGS[@]}"
