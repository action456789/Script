#!/bin/bash
# 
# This script was inspired by Coneboy_K
#
# 介绍：
# 这个脚本全部自动化编译各指令集静态库后合并。现在支持指令集有armv7 armv7s arm64 i386 x86_64
#  
# 使用：
# 	1. 将该sh文件拷贝到工程根目录，
#   2. cd 到xcode工程目录 然后运行 "sh ./build.sh"  
#   3. 修改 PROJECT、MY_TARGET_NAME 以及 MY_STATIC_LIB
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
MY_PROJECT_NAME='${PROJECT}.xcodeproj'
#编译target的名字：手动填写
MY_TARGET_NAME="libProtobufScrip"
#LIB名字：手动填写
MY_STATIC_LIB="liblibProtobuf.a"
#编译路径
# 编译静态库名称路径：可以自己修改
LIB_DIR='./build'
#合并静态库文件路径：可以自己修改
LIB_FAT_PATH='./build/fat'

#如果目标文件不存在则创建
echo "创建路径${LIB_DIR}"
if [ ! -d "${LIB_DIR}" ]; then
  mkdir -p "${LIB_DIR}"
fi 

echo "创建路径${LIB_FAT_PATH}"
if [ ! -d "${LIB_FAT_PATH}" ]; then
  mkdir -p "${LIB_FAT_PATH}"
fi 

# 使用 xcodebuild -showsdks 命令查看支持的 SDK 版本
# 修改参数 iphoneos11.0 为对于的版本

# armv7 
MY_ARMV7_BUILD_PATH=${LIB_DIR}'/armv7'

echo "编译 armv7 armv7s，目录：${MY_ARMV7_BUILD_PATH}"

MY_CURRENT_BUILD_PATH="${MY_ARMV7_BUILD_PATH}"
if [ ! -d "${MY_ARMV7_BUILD_PATH}" ]; then
  mkdir -p "${MY_ARMV7_BUILD_PATH}"
fi

xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release'  -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='armv7 armv7s'  VALID_ARCHS='armv7' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# armv7s

MY_ARMV7S_BUILD_PATH=${LIB_DIR}'/armv7S'
MY_CURRENT_BUILD_PATH="${MY_ARMV7S_BUILD_PATH}"
if [ ! -d "${MY_ARMV7S_BUILD_PATH}" ]; then
  mkdir -p "${MY_ARMV7S_BUILD_PATH}"
fi

xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release'  -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='armv7s'  VALID_ARCHS='armv7s' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# arm64  
MY_ARM64_BUILD_PATH=${LIB_DIR}'/arm64'

echo "编译 arm64，目录：${MY_ARM64_BUILD_PATH}"

MY_CURRENT_BUILD_PATH="${MY_ARM64_BUILD_PATH}"
if [ ! -d "${MY_ARM64_BUILD_PATH}" ]; then
  mkdir -p "${MY_ARM64_BUILD_PATH}"
fi

xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk 'iphoneos11.0' CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='arm64' IPHONEOS_DEPLOYMENT_TARGET='7.0'  clean build
 
# i386
MY_I386_BUILD_PATH=${LIB_DIR}'/i386'

echo "编译 i386，目录：${MY_I386_BUILD_PATH}"

MY_CURRENT_BUILD_PATH="${MY_I386_BUILD_PATH}"
if [ ! -d "${MY_I386_BUILD_PATH}" ]; then
    mkdir -p "${MY_I386_BUILD_PATH}"
fi

xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk 'iphonesimulator11.0' CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='i386' VALID_ARCHS='i386' IPHONEOS_DEPLOYMENT_TARGET='5.0' clean build

# x86_64 
MY_X86_64_BUILD_PATH=${LIB_DIR}'/x86_64'

echo "编译 x86_64，目录：${MY_X86_64_BUILD_PATH}"

MY_CURRENT_BUILD_PATH="${MY_X86_64_BUILD_PATH}"
if [ ! -d "${MY_X86_64_BUILD_PATH}" ]; then
    mkdir -p "${MY_X86_64_BUILD_PATH}"
fi

xcodebuild -project "${MY_PROJECT_NAME}" -target "${MY_TARGET_NAME}" -configuration 'Release' -sdk 'iphonesimulator11.0' CONFIGURATION_BUILD_DIR="${MY_CURRENT_BUILD_PATH}" ARCHS='x86_64' VALID_ARCHS='x86_64' IPHONEOS_DEPLOYMENT_TARGET='7.0' clean build


# #####################
# 
# # # 需要重新设置编译target的名字，
# 
# #####################
# TARGET 名字
# MY_TARGET_NAME="libProtobufScrip"
#LIB名字
# MY_STATIC_LIB="libProtobuf.a"

#最终静态库路径
# MY_FINAL_BUILD_PATH=LIB_DIR/final
#最终静态库名字
# MY_FINAL_STATIC_LIB="libProtobuf.a"
# if [ ! -d "${MY_FINAL_BUILD_PATH}" ]; then
#   mkdir -p "${MY_FINAL_BUILD_PATH}"
# fi


# 合并不同版本的编译库 
echo "生成了静态库：${MY_ARMV7_BUILD_PATH}/${MY_STATIC_LIB}"
echo "生成了静态库：${MY_ARMV7S_BUILD_PATH}/${MY_STATIC_LIB}"
echo "生成了静态库：${MY_ARM64_BUILD_PATH}/${MY_STATIC_LIB}"
echo "生成了静态库：${MY_I386_BUILD_PATH}/${MY_STATIC_LIB}"
echo "生成了静态库：${MY_X86_64_BUILD_PATH}/${MY_STATIC_LIB}"

echo "合并静态库，目录：${LIB_FAT_PATH}/${MY_STATIC_LIB}"

lipo -create "${MY_ARMV7_BUILD_PATH}/${MY_STATIC_LIB}" \
             "${MY_ARMV7S_BUILD_PATH}/${MY_STATIC_LIB}" \
             "${MY_ARM64_BUILD_PATH}/${MY_STATIC_LIB}" \
             "${MY_I386_BUILD_PATH}/${MY_STATIC_LIB}" \
             "${MY_X86_64_BUILD_PATH}/${MY_STATIC_LIB}" \
     -output "${LIB_FAT_PATH}/${MY_STATIC_LIB}"
	  
# rm -rf 'temp'
# rm -rf 'build'

#真机build生成的头文件的文件夹路径
ARVM7_INCLUDE_PATH=${MY_ARMV7_BUILD_PATH}'/include/'${PROJECT}
echo "ARVM7_INCLUDE_PATH=${ARVM7_INCLUDE_PATH}"

# 复制头文件到目标文件夹
cp -R "${ARVM7_INCLUDE_PATH}" "${LIB_FAT_PATH}"

open "${LIB_DIR}"