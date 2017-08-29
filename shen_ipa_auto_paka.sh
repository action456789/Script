#! /bin/bash

# 使用第三方工具shenzhen(https://github.com/nomad/shenzhen)进行自动化打包

PROJECT_DIR="/Users/kesen./Desktop/Repository/YouPinGuPiaoTong"

USER_KEY="b3fe10ea230d1c593799975ab127e96a"
APP_KEY="bb5b5db02e91e523bc4130ae13cf72c4" # APP_KEY 或 API Key

function autoPaka() {
    cd $1
    ipa build
    ipa distribute:pgyer -u ${USER_KEY} -a ${APP_KEY}
}

autoPaka ${PROJECT_DIR}

# 使用 altool 上传您的应用程序二进制文件到 AppStore 参见 xcode Application Loader 帮助
