#!/bin/bash

# 输出 IP 地址
sh ./ipAddress.sh

sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist
ftp localhost


