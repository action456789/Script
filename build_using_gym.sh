#!/bin/bash

# 使用方法
# 1.将本脚本放到项目根目录
# 2.修改项目名称和scheme名称
# 参考：http://www.jianshu.com/p/edcd8d9430f6

#计时
SECONDS=0

#项目名称
project_name="RICISmartSwift"

#假设脚本放置在与项目相同的路径下
project_path=$(pwd)
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称，名称自己输入
scheme="RICISmartSwift"

#指定要打包的配置名
configuration="Adhoc"
# configuration="Release"

#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method='ad-hoc'
# export_method='development'


#指定项目地址，名称自己输入
workspace_path="$project_path/${project_name}.xcworkspace"
#指定输出路径
output_path="project_path/APP"
#指定输出归档文件地址
archive_path="$output_path/${project_name}_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/${project_name}_${now}.ipa"
#指定输出ipa名称
ipa_name="${project_name}_${now}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===export method: ${export_method}==="
echo "===commit msg: $1==="

#先清空前一次build
gym --workspace ${workspace_path} \
    --scheme ${scheme} \
    --clean \
    --configuration ${configuration} \
    --archive_path ${archive_path} \
    --export_method ${export_method} \
    --output_directory ${output_path} \
    --output_name ${ipa_name}

#上传到fir
fir publish ${ipa_path} -T fir_token -c "${commit_msg}"

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="