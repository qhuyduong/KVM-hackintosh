#!/bin/bash

echo 0000:03:00.4 | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind
sudo modprobe vfio-pci
echo 1022 1639 | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id
