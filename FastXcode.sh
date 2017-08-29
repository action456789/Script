#!/bin/bash
# 将 xcode 的 driveData 数据存到内存中，提升Xcode编译速度
# 1. 配置 RAM。在内存中专门开出一块让 Xcode 使用。
# 2. 连接 Xcode。让 Xcode 连接到我们开辟出来的专属内存空间。

RAMDISK="ramdisk"
SIZE=1024         #size in MB for ramdisk.
diskutil erasevolume HFS+ $RAMDISK \
     `hdiutil attach -nomount ram://$[SIZE*2048]`