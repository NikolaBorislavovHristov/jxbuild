#!/bin/bash
# This script builds the jxcore and the jxcore-cordova distribution files
# It runs on macOS with the latest XCode preinstalled.
# It downloads the Android NDK, it clones the jxcore and jxcore-cordova 
# repositories and it builds all the required files but the NPM modules

BUILD_DIR="$PWD"
EXEC_FROM="0"

# Log files
LOG_STDOUT="$BUILD_DIR/log-stdout"
LOG_STDERR="$BUILD_DIR/log-stderr"
LOG_ZIP="$BUILD_DIR/log-zip"

# Android NDK version
NDK_VER="r11c"
NDK_URL="http://dl.google.com/android/repository/android-ndk-"$NDK_VER"-darwin-x86_64.zip"

# Branches to build
JXCORE_BRANCH="master"
JXCORE_CORDOVA_BRANCH="master"

NORMAL_COLOR='\033[0m'
BOLD_COLOR='\033[1m'
RED_COLOR='\033[0;31m'
RED_BOLD_COLOR='\033[1;31m'
GREEN_COLOR='\033[0;32m'
GRAY_COLOR='\033[0;37m'

LOG() {
  COLOR="$1"
  TEXT="$2"
  echo -e "${COLOR}$TEXT ${NORMAL_COLOR}"
}
ABORT() {
  LOG $RED_COLOR "$1"
  exit
}
ERROR_ABORT() {
  if [[ $? != 0 ]]
  then
    tail log-stderr
    ABORT "$1"
  fi
}

# -----------------------------------------------------------------------------
# 0-Cleanup
if [ $EXEC_FROM -gt "0" ]
then
    LOG $NORMAL_COLOR "Skipping step 0."
else
    LOG $NORMAL_COLOR "0-Cleanup..."

    # Remove log files
    rm -rf log-stdout
    rm -rf log-stderr
    rm -rf log-unzip

    # Remove working dirs
    rm -rf android-ndk
    rm -rf jxcore-v8
    rm -rf jxcore-cordova
    rm -rf jxcore-sm
    rm -rf jxcore-android
    rm -rf jxcore-ios
    rm -rf jxbin
    rm -rf dist
fi
# -----------------------------------------------------------------------------
# 1-Download android ndk
if [ $EXEC_FROM -gt "1" ]
then
    LOG $NORMAL_COLOR "Skipping step 1."
else
    LOG $NORMAL_COLOR "1-Downloding Android NDK..."
    curl $NDK_URL -o android-ndk.zip
    ERROR_ABORT "FAILED to download android-ndk"

    LOG $NORMAL_COLOR "1-Unzipping android-ndk..."
    unzip android-ndk 1>$LOG_ZIP
    ERROR_ABORT "FAILED to unzip android-ndk"

    mv "android-ndk-"$NDK_VER android-ndk
    ERROR_ABORT "FAILED to rename android-ndk dir"

    rm -rf android-ndk.zip
    cd android-ndk
    export PATH=$PATH:$(pwd)
fi
# -----------------------------------------------------------------------------
# 2-Clone jxcore repo
if [ $EXEC_FROM -gt "2" ]
then
    LOG $NORMAL_COLOR "Skipping step 2."
else
    cd $BUILD_DIR
    LOG $NORMAL_COLOR "2-Cloning jxcore..."
    git clone https://github.com/ThaliProject/jxcore.git jxcore-v8
    ERROR_ABORT "FAILED to clone jxcore"

    cd jxcore-v8
    LOG $NORMAL_COLOR "2-Cloning jxcore submodules..."
    git submodule init && git submodule update
    ERROR_ABORT "FAILED to update submodule"
fi
# -----------------------------------------------------------------------------
# 3-Clone jxcore-cordova repo
if [ $EXEC_FROM -gt "3" ]
then
    LOG $NORMAL_COLOR "Skipping step 3."
else
    cd $BUILD_DIR
    LOG $NORMAL_COLOR "3-Cloning jxcore-cordova..."
    git clone https://github.com/ThaliProject/jxcore-cordova.git jxcore-cordova
    ERROR_ABORT "FAILED to clone jxcore-cordova"

    cd jxcore-cordova
    mkdir -p bin
fi
# -----------------------------------------------------------------------------
# 4-Checkout branch and update build scripts
# The compile scripts for Android and iOS that are present in the jxcore repo
# have the "-j 2" make flag hard-coded, it makes sense for the travis build
# since in travis the build machines have only 2 cores available. In order to
# avoid to make changes in two repos it was safer and quicker to just copy
# those files over here and change them to optimize the compilation for desktop
# CPUs (i.e. "-j 8").
if [ $EXEC_FROM -gt "4" ]
then
    LOG $NORMAL_COLOR "Skipping step 4."
else
    cd $BUILD_DIR/jxcore-v8
    git checkout $JXCORE_BRANCH
    ERROR_ABORT "FAILED to checkout branch $JXCORE_BRANCH"
    cd ..

    LOG $NORMAL_COLOR "4-Copying android and ios build scripts..."
    cp build-script-files/jxcore/build_scripts/android_compile.sh jxcore-v8/build_scripts/
    ERROR_ABORT "FAILED to copy android script"

    cp build-script-files/jxcore/build_scripts/ios_compile.sh jxcore-v8/build_scripts/
    ERROR_ABORT "FAILED to copy ios script"
fi
# -----------------------------------------------------------------------------
# 5-Duplicate jxcore folder
if [ $EXEC_FROM -gt "5" ]
then
    LOG $NORMAL_COLOR "Skipping step 5."
else
    cd $BUILD_DIR
    LOG $NORMAL_COLOR "5-Creating 'jxcore-sm' dir..."
    cp -R jxcore-v8/ jxcore-sm/
    ERROR_ABORT "FAILED to copy 'jxcore-sm' dir"

    LOG $NORMAL_COLOR "5-Creating 'jxcore-android' dir..."
    cp -R jxcore-v8/ jxcore-android/
    ERROR_ABORT "FAILED to copy 'jxcore-android' dir"

    LOG $NORMAL_COLOR "5-Creating 'jxcore-ios' dir..."
    cp -R jxcore-v8/ jxcore-ios/
    ERROR_ABORT "FAILED to copy 'jxcore-ios' dir"
fi
# -----------------------------------------------------------------------------
# 6-Build jxcore-v8
if [ $EXEC_FROM -gt "6" ]
then
    LOG $NORMAL_COLOR "Skipping step 6."
else
    LOG $NORMAL_COLOR "6-Bulding jxcore-v8..."
    cd $BUILD_DIR/jxcore-v8
    ./configure --embed-leveldown --debug 1>>$LOG_STDOUT 2>>$LOG_STDERR
    make V= -j 8 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to compile jxcore-v8"
fi
# -----------------------------------------------------------------------------
# 7-Build jxcore-sm
if [ $EXEC_FROM -gt "7" ]
then
    LOG $NORMAL_COLOR "Skipping step 7."
else
    LOG $NORMAL_COLOR "7-Bulding jxcore-sm..."
    cd $BUILD_DIR/jxcore-sm
    ./configure --engine-mozilla --embed-leveldown --debug 1>>$LOG_STDOUT 2>>$LOG_STDERR
    make V= -j 8 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to compile jxcore-sm"
fi
# -----------------------------------------------------------------------------
# 8-Create macOS X dist
if [ $EXEC_FROM -gt "8" ]
then
    LOG $NORMAL_COLOR "Skipping step 8."
else
    LOG $NORMAL_COLOR "8-Creating macOS X dist files..."
    cd $BUILD_DIR
    mkdir -p dist/jxcore/Release/jx_osx64v8
    cp jxcore-v8/out/Release/jx dist/jxcore/Release/jx_osx64v8/
    ERROR_ABORT "FAILED to copy jx_osx64v8 release"

    mkdir -p dist/jxcore/Release/jx_osx64sm
    cp jxcore-sm/out/Release/jx dist/jxcore/Release/jx_osx64sm/
    ERROR_ABORT "FAILED to copy jx_osx64sm release"

    cd dist/jxcore/Release
    zip jx_osx64v8 jx_osx64v8/jx 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jx_osx64v8 release"
    rm -rf jx_osx64v8

    zip jx_osx64sm jx_osx64sm/jx 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jx_osx64sm release"
    rm -rf jx_osx64sm

    cd $BUILD_DIR
    mkdir -p dist/jxcore/Debug/jx_osx64v8
    cp jxcore-v8/out/Debug/jx dist/jxcore/Debug/jx_osx64v8/
    ERROR_ABORT "FAILED to copy jx_osx64v8 debug"

    mkdir -p dist/jxcore/Debug/jx_osx64sm
    cp jxcore-sm/out/Debug/jx dist/jxcore/Debug/jx_osx64sm/
    ERROR_ABORT "FAILED to copy jx_osx64sm debug"

    cd dist/jxcore/Debug
    zip jx_osx64v8 jx_osx64v8/jx 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jx_osx64v8 debug"
    rm -rf jx_osx64v8

    zip jx_osx64sm jx_osx64sm/jx 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jx_osx64sm debug"
    rm -rf jx_osx64sm

    cd $BUILD_DIR
    mkdir jxbin
    cp jxcore-v8/out/Release/jx jxbin/
    cd jxbin
    export PATH=$PATH:$(pwd)
    cd ..
    jx -jxv
    ERROR_ABORT "FAILED to run jx -jxv"

    jx -jsv
    ERROR_ABORT "FAILED to run jx -jsv"
fi
# -----------------------------------------------------------------------------
# 9-Build jxcore-ios
if [ $EXEC_FROM -gt "9" ]
then
    LOG $NORMAL_COLOR "Skipping step 9."
else
    LOG $NORMAL_COLOR "9-Bulding jxcore-ios..."
    cd $BUILD_DIR/jxcore-ios
    ./build_scripts/ios_compile.sh --embed-leveldown 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to build jxcore-ios"
fi
# -----------------------------------------------------------------------------
# 10-Create ios dist
if [ $EXEC_FROM -gt "10" ]
then
    LOG $NORMAL_COLOR "Skipping step 10."
else
    LOG $NORMAL_COLOR "10-Creating iOS dist files..."
    cd $BUILD_DIR/jxcore-ios/out_ios/ios/bin
    zip ../../../../jx_iosFATsm * 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jxcore-ios"
    cd ../../../..

    cp jx_iosFATsm.zip jxcore-cordova/bin/ios.zip
    ERROR_ABORT "FAILED to copy jx_iosFATsm.zip to jxcore-cordova/bin/ios.zip"

    mv jx_iosFATsm.zip dist/jxcore/Release/
    ERROR_ABORT "FAILED to move jx_iosFATsm.zip to dist/jxcore/Release/"
fi
# -----------------------------------------------------------------------------
# 11-Build jxcore-android
if [ $EXEC_FROM -gt "11" ]
then
    LOG $NORMAL_COLOR "Skipping step 11."
else
    LOG $NORMAL_COLOR "11-Configuring jxcore-android..."
    cd $BUILD_DIR/jxcore-android
    build_scripts/android-configure.sh ../android-ndk/ 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to configure jxcore-android"

    LOG $NORMAL_COLOR "11-Bulding jxcore-android..."
    build_scripts/android_compile.sh ../android-ndk/ --embed-leveldown 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to build jxcore-android"
fi
# -----------------------------------------------------------------------------
# 12-Create ios dist
if [ $EXEC_FROM -gt "12" ]
then
    LOG $NORMAL_COLOR "Skipping step 12."
else
    LOG $NORMAL_COLOR "12-Creating Android dist files..."
    cd $BUILD_DIR/jxcore-android/out_android/android/bin
    zip ../../../../jx_androidFATsm * 1>>$LOG_ZIP
    ERROR_ABORT "FAILED to zip jxcore-android"
    cd ../../../..
    mv jx_androidFATsm.zip dist/jxcore/Release/
    ERROR_ABORT "FAILED to move jx_androidFATsm.zip to dist/jxcore/Release/"
fi
# -----------------------------------------------------------------------------
# 13-Build jxcore-cordova
if [ $EXEC_FROM -gt "13" ]
then
    LOG $NORMAL_COLOR "Skipping step 13."
else
    LOG $NORMAL_COLOR "13-Bulding jxcore-cordova plugin..."
    cd $BUILD_DIR/jxcore-cordova/
    git checkout $JXCORE_CORDOVA_BRANCH
    ERROR_ABORT "FAILED to checkout branch $JXCORE_CORDOVA_BRANCH"

    cd src/android
    ./build_leveldown.sh ../../../jxcore-android/out_android/android/bin/
    ERROR_ABORT "FAILED to build jxcore-cordova"
fi
# -----------------------------------------------------------------------------
# 14-Create jxcore-cordova dist
if [ $EXEC_FROM -gt "14" ]
then
    LOG $NORMAL_COLOR "Skipping step ."
else
    LOG $NORMAL_COLOR "14-Creating jxcore-cordova pluging dist files..."
    cd $BUILD_DIR
    mkdir -p dist/jxcore-cordova/Release/
    cd jxcore-cordova
    jx compile io.jxcore.node.jxp 1>>$LOG_STDOUT 2>>$LOG_STDERR
    ERROR_ABORT "FAILED to compile io.jxcore.node.jxp"

    cp io.jxcore.node.jx ../dist/jxcore-cordova/Release/
    ERROR_ABORT "FAILED to copy io.jxcore.node.jx to ../dist/jxcore-cordova/Release/"
fi
# -----------------------------------------------------------------------------
# Done
cd $BUILD_DIR
ls -lR dist/
LOG $NORMAL_COLOR "Done."