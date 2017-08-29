#!/bin/bash

# 获取 MAC 电脑的 IPv4 地址 
regex_ip="(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}"

echo "IP 地址是:"
IP=C ifconfig | grep "inet" | awk '{print $2}' | grep -E "$regex_ip"



