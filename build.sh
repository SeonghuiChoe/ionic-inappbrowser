#!/bin/bash

# 사용 할 keystore
PATH_KEYSTORE="./.keystore"

# 사용 할 keystore alias
KEYSTORE_ALIAS="crm"

# 릴리즈 빌드 시 생성되는 unsigned apk
PATH_UNSIGNED="./platforms/android/build/outputs/apk/release/android-release-unsigned.apk"
#android-armv7-release-unsigned

# 생성 할 signed apk 이름
OUT_SIGNED_NAME="./crm"
OUT_SIGNED_EXT=".apk"

# keystore 비밀번호
KEYSTORE_PASS="!@balance"

# App 버전, config.xml 파싱
version=$(cat config.xml | grep "<widget" | grep -o "version=\"[^ ]*" | sed -e "s/version=//g" -e "s/\"//g")

# 안드로이드 플랫폼 추가
eval "cordova platform rm android"
eval "cordova platform add android@6.4.0"

# IOS 플랫폼 추가
# eval "cordova platform rm ios"
# eval "cordova platform add ios@4.5.3"

# 안드로이드 릴리즈 빌드
eval "cordova build --release android"

# unsigned apk 에 key 입히기
eval "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -storepass $KEYSTORE_PASS -keystore $PATH_KEYSTORE $PATH_UNSIGNED $KEYSTORE_ALIAS"

# signed apk 생성
eval "zipalign -v 4 $PATH_UNSIGNED $OUT_SIGNED_NAME\_$version$OUT_SIGNED_EXT"
