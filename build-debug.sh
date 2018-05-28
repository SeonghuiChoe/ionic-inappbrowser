#!/bin/bash

# 사용 할 keystore alias
KEYSTORE_ALIAS="crm"

PATH_UNSIGNED="/usr/local/app/platforms/android/build/outputs/apk/debug/android-debug.apk"

# 생성 할 signed apk 이름
OUT_SIGNED_NAME="./crm_debug"
OUT_SIGNED_EXT=".apk"

# App 버전, config.xml 파싱
version=$(cat config.xml | grep "<widget" | grep -o "version=\"[^ ]*" | sed -e "s/version=//g" -e "s/\"//g")

# 안드로이드 플랫폼 추가
eval "cordova platform rm android"
eval "cordova platform add android@6.4.0"

# 안드로이드 릴리즈 빌드
eval "cordova build --debug android"

eval "cp $PATH_UNSIGNED $OUT_SIGNED_NAME\_$version$OUT_SIGNED_EXT"
