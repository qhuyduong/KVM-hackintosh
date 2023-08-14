#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo "$0 <interface>"
    exit 1
fi

IF=$1
IP=$(ip addr | grep "inet.*$IF" | awk '{print $2}')
GW=$(ip route | grep default | awk '{print $3}')

iw dev $IF set 4addr on
ip link add name virbr0 type bridge
ip link set dev virbr0 up
ip link set $IF master virbr0
ip address del $IP dev $IF
ip address add $IP dev virbr0
ip route append default via $GW dev virbr0
