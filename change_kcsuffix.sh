#!/bin/bash
VALUE=$1
sed -i "571s/kcsuffix=.*</kcsuffix=$VALUE</" mnt/EFI/OC/config.plist
