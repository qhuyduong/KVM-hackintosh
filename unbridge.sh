#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo "$0 <interface>"
    exit 1
fi

IF=$1
IP=$(ip addr | grep "inet.*virbr0" | awk '{print $2}')
GW=$(ip route | grep default | awk '{print $3}')

ip link delete virbr0
ip address add $IP dev $IF
ip route append default via $GW dev $IF
