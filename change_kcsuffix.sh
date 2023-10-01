#!/bin/bash
VALUE=$1
./mount.sh
sed -i "571s/kcsuffix=.*</kcsuffix=$VALUE</" mnt/EFI/OC/config.plist
./unmount.sh
