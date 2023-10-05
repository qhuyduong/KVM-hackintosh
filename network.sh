#!/bin/bash

sudo iptables -A FORWARD -i wlp1s0 -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i br0 -o wlp1s0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o wlp1s0 -j MASQUERADE
