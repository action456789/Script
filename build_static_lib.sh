#!/bin/bash
# 
# This script was inspired by Coneboy_K
#
# 介绍：
# 这个脚本全部自动化编译各指令集静态库后合并。现在支持指令集有armv7 armv7s arm64 i386 x86_64
#  
# 使用：
# 	1. 将该sh文件拷贝到工程根目录，cd 到xcode工程目录
#   2. 运行 "./build.sh"  
#   3. 修改 PROJECT、TARGET_NAME 以及 LIB_OUTPUT_NAME
# 
#   PS:xcode不能含有xcodebuild的Runscript切记！
# 
# 验证:
#	 cd 到静态库目录  然后 "lipo -info 静态库名称.a "
# 
# TODO :
# 完成宏定义，解决多次修改工程名字的问题

# 参考
# https://gist.github.com/Coneboy-k/11077391
#

set -e
set +u

# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

#工程名称: 手动填写
PROJECT='libProtobuf'

#工程的全名，增加了后缀 
PROJECT_NAME=${PROJECT}'.xcodeproj'
#编译target的名字：手动填写
TARGET_NAME="libProtobufScrip"
#LIB名字：手动填写
LIB_OUTPUT_NAME="liblibProtobuf.a"
#编译路径
# 编译静态库名称路径：可以自己修改
LIB_OUTPUT_DIR='./build'
#合并静态库文件路径：可以自己修改
FAT_LIB_OUTPUT_DIR='./build/fat'

#如果目标文件不存在则创建
echo "创建路径${LIB_OUTPUT_DIR}"
if [ ! -d "${LIB_OUTPUT_DIR}" ]; then
  mkdir -p "${LIB_OUTPUT_DIR}"
fi 

echo "创建路径${FAT_LIB_OUTPUT_DIR}"
if [ ! -d "${FAT_LIB_OUTPUT_DIR}" ]; then
  mkdir -p "${FAT_LIB_OUTPUT_DIR}"
fi 

# 使用 xcodebuild -showsdks 命令查看支持的 SDK 版本
# 修改参数 iphoneos11.0 为对于的版本

# armv7 
LIB_OUTPUT_DIR_ARMV7=${LIB_OUTPUT_DIR}'/armv7'

echo "编译 armv7 armv7s，目录：${LIB_OUTPUT_DIR_ARMV7}"

CURRENT_BUILD_PATH="${LIB_OUTPUT_DIR_ARMV7}"
if [ ! -d "${LIB_OUTPUT_DIR_ARMV7}" ]; then
  mkdir -p "${LIB_OUTPUT_DIR_ARMV7}"
fi

xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Release'  -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${CURRENT_BUILD_PATH}" ARCHS='armv7 armv7s'  VALID_ARCHS='armv7' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# armv7s

LIB_OUTPUT_DIR_ARMV7s=${LIB_OUTPUT_DIR}'/armv7S'
CURRENT_BUILD_PATH="${LIB_OUTPUT_DIR_ARMV7s}"
if [ ! -d "${LIB_OUTPUT_DIR_ARMV7s}" ]; then
  mkdir -p "${LIB_OUTPUT_DIR_ARMV7s}"
fi

xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Release'  -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${CURRENT_BUILD_PATH}" ARCHS='armv7s'  VALID_ARCHS='armv7s' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# arm64  
LIB_OUTPUT_DIR_ARMV64=${LIB_OUTPUT_DIR}'/arm64'

echo "编译 arm64，目录：${LIB_OUTPUT_DIR_ARMV64}"

CURRENT_BUILD_PATH="${LIB_OUTPUT_DIR_ARMV64}"
if [ ! -d "${LIB_OUTPUT_DIR_ARMV64}" ]; then
  mkdir -p "${LIB_OUTPUT_DIR_ARMV64}"
fi

xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Release' -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${CURRENT_BUILD_PATH}" ARCHS='arm64' IPHONEOS_DEPLOYMENT_TARGET='7.0'  clean build
 
# i386
LIB_OUTPUT_DIR_I386=${LIB_OUTPUT_DIR}'/i386'

echo "编译 i386，目录：${LIB_OUTPUT_DIR_I386}"

CURRENT_BUILD_PATH="${LIB_OUTPUT_DIR_I386}"
if [ ! -d "${LIB_OUTPUT_DIR_I386}" ]; then
    mkdir -p "${LIB_OUTPUT_DIR_I386}"
fi

xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Release' -sdk 'iphonesimulator11.0' CONFIGURATION_BUILD_DIR="${CURRENT_BUILD_PATH}" ARCHS='i386' VALID_ARCHS='i386' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# x86_64 
LIB_OUTPUT_DIR_x86_64=${LIB_OUTPUT_DIR}'/x86_64'

echo "编译 x86_64，目录：${LIB_OUTPUT_DIR_x86_64}"

CURRENT_BUILD_PATH="${LIB_OUTPUT_DIR_x86_64}"
if [ ! -d "${LIB_OUTPUT_DIR_x86_64}" ]; then
    mkdir -p "${LIB_OUTPUT_DIR_x86_64}"
fi

xcodebuild -project "${PROJECT_NAME}" -target "${TARGET_NAME}" -configuration 'Release' -sdk 'iphonesimulator11.0' CONFIGURATION_BUILD_DIR="${CURRENT_BUILD_PATH}" ARCHS='x86_64' VALID_ARCHS='x86_64' IPHONEOS_DEPLOYMENT_TARGET='7.0' clean build


# #####################
# 
# # # 需要重新设置编译target的名字，
# 
# #####################
# TARGET 名字
# TARGET_NAME="libProtobufScrip"
#LIB名字
# LIB_OUTPUT_NAME="libProtobuf.a"

#最终静态库路径
# MY_FINAL_BUILD_PATH=LIB_OUTPUT_DIR/final
#最终静态库名字
# MY_FINAL_STATIC_LIB="libProtobuf.a"
# if [ ! -d "${MY_FINAL_BUILD_PATH}" ]; then
#   mkdir -p "${MY_FINAL_BUILD_PATH}"
# fi


# 合并不同版本的编译库 
echo "生成了静态库：${LIB_OUTPUT_DIR_ARMV7}/${LIB_OUTPUT_NAME}"
echo "生成了静态库：${LIB_OUTPUT_DIR_ARMV7s}/${LIB_OUTPUT_NAME}"
echo "生成了静态库：${LIB_OUTPUT_DIR_ARMV64}/${LIB_OUTPUT_NAME}"
echo "生成了静态库：${LIB_OUTPUT_DIR_I386}/${LIB_OUTPUT_NAME}"
echo "生成了静态库：${LIB_OUTPUT_DIR_x86_64}/${LIB_OUTPUT_NAME}"

echo "合并静态库，目录：${FAT_LIB_OUTPUT_DIR}/${LIB_OUTPUT_NAME}"

lipo -create "${LIB_OUTPUT_DIR_ARMV7}/${LIB_OUTPUT_NAME}" \
             "${LIB_OUTPUT_DIR_ARMV7s}/${LIB_OUTPUT_NAME}" \
             "${LIB_OUTPUT_DIR_ARMV64}/${LIB_OUTPUT_NAME}" \
             "${LIB_OUTPUT_DIR_I386}/${LIB_OUTPUT_NAME}" \
             "${LIB_OUTPUT_DIR_x86_64}/${LIB_OUTPUT_NAME}" \
     -output "${FAT_LIB_OUTPUT_DIR}/${LIB_OUTPUT_NAME}"
	  
# rm -rf 'temp'
# rm -rf 'build'

#真机build生成的头文件的文件夹路径
LIB_OUTPUT_INCLUDE_PATH_ARVM7=${LIB_OUTPUT_DIR_ARMV7}'/include/'${PROJECT}
echo "头文件路径：${LIB_OUTPUT_INCLUDE_PATH_ARVM7}"

# 复制头文件到目标文件夹
cp -R "${LIB_OUTPUT_INCLUDE_PATH_ARVM7}" "${FAT_LIB_OUTPUT_DIR}"

open "${LIB_OUTPUT_DIR}"
