# JxCore Build

This covers the build of the following:

* JxCore - desktop
* JxCore - iOS
* JxCore - Android
* jxcore-cordova plugin
    * this ingests the iOS & Android builds from above...

# Overall Steps

## JxCore - Desktop build

* create some base path

```
cd ~/tmp
mkdir builds
cd builds
```

* Clone https://github.com/thaliproject/jxcore

```
git clone —depth=50 https://github.com/ThaliProject/jxcore
```
* Now make simple copies for other platforms after deleting the .git folder

```
cd jxcore
git submodule init && git submodule update
```

* This should give you feedback as follows:

```
cicoriasmbp13@Shawns-MBP:$ git submodule init && git submodule update
Submodule path 'deps/leveldown-mobile': checked out 'd22099865674a7821ee6417213418581d969b7a2'
```

* We’ll remote the .git repository as we don’t need it anymore and it’s large; this makes our copies faster.

```
rm -rf .git
cd ../
cp -R jxcore/ ios/
cp -R jxcore/ android/
```

* You should have something like:

```
drwxr-xr-x 27 501 20 918B Mar 15 14:38 android/
drwxr-xr-x 27 501 20 918B Mar 15 14:39 ios/
drwxr-xr-x 27 501 20 918B Mar 15 14:35 jxcore/
```

* Build the Desktop version of JxCore - as you’re going to need the ./jx binary in the path for later builds.
* We don’t need SpiderMonkey now - but if you want it you add the —engine-mozilla switch

```
cd jxcore
./configure --embed-leveldown && make  
OR 
./configure --engine-mozilla --embed-leveldown && make
```

* Compilation takes some time
* Once the desktop version is built, we need to add it to the PATH
* **NOTE**: if you get an error like the following, you failed to “init” and “update” git submodules

```
gyp: //jxcore/deps/leveldown-mobile/leveldown_embedded.gyp not found (cwd: //jxcore) while loading dependencies of //jxcore/jx.gyp while trying to load /Users/cicoriasmbp13/tmp/jxcore/builds/debug/jxcore/jx.gyp
**Error running GYP**
```

* from the `./jxcore directory`:  (note the symbolic link ./jx → out/Release

```
export PATH=$PATH:$(pwd)
cd ../
jx -jxv
```

* this should output the version of JxCore - current this is 0.3.1.2

## IOS Build

* Now we will build the iOS mobile version with SpiderMonkey support. By default, the script supplied builds a static library and uses SpiderMonkey. We will add the option to embed Level Down

```
cd ios
./build_scripts/ios_compile.sh  --embed-leveldown 
```

* This compilation takes significantly MORE time..  Grab something to drink… (it actually builds 5 Mach-O libraries into each library — *.a)
* When done, you should see the following output

```
JXcore iOS binaries are ready under out_ios/ios 
cicoriasmbp13@Shawns-MBP:~/tmp/jxcore/builds/debug/ios$ 
```

* check to see that all libraries and headers are present

```
ls -lt out_ios/ios/bin
-rw-r--r-- 1 cicoriasmbp13 staff 3956 Mar 14 15:30 jx.h
-rw-r--r-- 1 cicoriasmbp13 staff 4780 Mar 14 15:30 jx_result.h
-rw-r--r-- 1 cicoriasmbp13 staff 3779528 Mar 14 15:30 **libleveldb.a**
-rw-r--r-- 1 cicoriasmbp13 staff 202688 Mar 14 15:30 **libsnappy.a**
-rw-r--r-- 1 cicoriasmbp13 staff 1449832 Mar 14 15:30 **libleveldown.a**
-rw-r--r-- 1 cicoriasmbp13 staff 7875216 Mar 14 15:29 **libsqlite3.a**
-rw-r--r-- 1 cicoriasmbp13 staff 1499080 Mar 14 15:29 **libuv.a**
-rw-r--r-- 1 cicoriasmbp13 staff 28254288 Mar 14 15:29 **libopenssl.a**
-rw-r--r-- 1 cicoriasmbp13 staff 89886200 Mar 14 15:29 **libmozjs.a**
-rw-r--r-- 1 cicoriasmbp13 staff 17266704 Mar 14 15:29 **libjx.a**
-rw-r--r-- 1 cicoriasmbp13 staff 1037688 Mar 14 15:29 **libchrome_zlib.a**
-rw-r--r-- 1 cicoriasmbp13 staff 152752 Mar 14 15:29 **libhttp_parser.a**
-rw-r--r-- 1 cicoriasmbp13 staff 986968 Mar 14 15:29 **libcares.a**
```

* At this point, we need to ZIP the ios libraries.

```
cd ./ios/out_ios/ios/bin
zip ../../../../ios *          (that’s 4 ..)

 adding: out_ios/ios/bin/jx.h (deflated 62%)
 adding: out_ios/ios/bin/jx_result.h (deflated 76%)
 adding: out_ios/ios/bin/libcares.a (deflated 55%)
 adding: out_ios/ios/bin/libchrome_zlib.a (deflated 37%)
 adding: out_ios/ios/bin/libhttp_parser.a (deflated 36%)
 adding: out_ios/ios/bin/libjx.a (deflated 51%)
 adding: out_ios/ios/bin/libleveldb.a (deflated 50%)
 adding: out_ios/ios/bin/libleveldown.a (deflated 53%)
 adding: out_ios/ios/bin/libmozjs.a (deflated 56%)
 adding: out_ios/ios/bin/libopenssl.a (deflated 53%)
 adding: out_ios/ios/bin/libsnappy.a (deflated 46%)
 adding: out_ios/ios/bin/libsqlite3.a (deflated 36%)
 adding: out_ios/ios/bin/libuv.a (deflated 50%)
 
 zip ../../../../jx_iosFATsm *  (that's 4 ..)
 ... same...
cd ../../../../                (that’s 4 ..)

```

# Android Build

* Ensure you download the NDK from: http://developer.android.com/ndk/downloads/index.html
* On  OS X the direct link is here
    * http://dl.google.com/android/repository/android-ndk-r11-darwin-x86_64.zip

* Change to the directory root where you doing builds.

```
curl http://dl.google.com/android/repository/android-ndk-r11-darwin-x86_64.zip -o ndk.zip
unzip ndk
```

* This creates a directory **./android-ndk-r11** in the current directory
* You should have something similar to this.

```
drwxr-xr-x 31 501 20 1.0K Mar 15 15:51 android/
drwxr-xr-x 11 501 20 374B Mar 3 17:16 android-ndk-r11/
drwxr-xr-x 37 501 20 1.2K Mar 15 17:15 ios/
-rw-r--r-- 1 501 20 68M Mar 15 17:19 ios.zip
drwxr-xr-x 31 501 20 1.0K Mar 15 15:42 jxcore/
```

* Change directory into the extracted path and setup the PATH to allow running the ndk-build later on.

```
cd android-ndk-r11
export PATH=$PATH:$(pwd)
```

* We will be building a static library, with SpiderMonkey (sm), and leveldown embedded.
* Given the directory structure from above, run the following

```
build_scripts/android-configure.sh ../android-ndk-r11/
build_scripts/android_compile.sh ../android-ndk-r11/ --embed-leveldown
```

* This compilation also take quite some time.  grab another drink...

* When done you should see the following message..

```
Preparing FAT binaries
JXcore Android binaries are ready under out_android/android
```

* Create the FAT zip

```
zip ../../../../jx_androidFATsm *
cd ../../../../
```



* Make a note of the output path above - that path with a /bin added to the end will be used during the Cordova Build

# Cordova Build

Go back to the root path of where your build are and Clone the repository:

```
cd ./builds 
git clone --depth=10 https://github.com/ThaliProject/jxcore-cordova
cd jxcore-cordova
```

### Put the IOS binaries in the /bin path

* At the end of the IOS build, you created a zip file.  Now copy that file into the ./jxcore-cordova/bin directory
    * **(this assumes you’re in the jxcore-cordova repository path)**

```
mkdir -p bin && cp ../ios.zip bin
```

* Now we will generate the dynamic (*.so) libraries that are to become part of the Cordova plugin.
* Recall the path for the Android binaries from - /out_android/android/bin
* Also, ensure that the Android NDK path is also setup in the environment variable PATH.

```
from the ./jxcore-cordova path
cd src/android
./build_leveldown.sh ../../../android/out_android/android/bin/
```

* You should see the following - **you can ignore the failed ‘cp’ commands as they are not being used**.

```
[armeabi] Compile++ thumb: jxcore <= JniHelper.cpp
[armeabi] Compile++ thumb: jxcore <= jxcore.cpp
[armeabi] SharedLibrary : libjxcore.so
[armeabi] Install : libjxcore.so => libs/armeabi/libjxcore.so
[armeabi-v7a] Compile++ thumb: jxcore <= JniHelper.cpp
[armeabi-v7a] Compile++ thumb: jxcore <= jxcore.cpp
[armeabi-v7a] SharedLibrary : libjxcore.so
[armeabi-v7a] Install : libjxcore.so => libs/armeabi-v7a/libjxcore.so
[x86] Compile++ : jxcore <= JniHelper.cpp
[x86] Compile++ : jxcore <= jxcore.cpp
[x86] SharedLibrary : libjxcore.so
[x86] Install : libjxcore.so => libs/x86/libjxcore.so
cp: directory ../../../platforms/android/libs/armeabi does not exist
cp: directory ../../../platforms/android/libs/armeabi-v7a does not exist
cp: directory ../../../platforms/android/libs/x86 does not exist`
```

In the end, you should end up with a directory structure like the following, and the key artifacts from iOS and Android builds

![](https://cicorias-transit.s3.amazonaws.com/jxcore-cordova_2016-03-15_18-33-22.png)


## Creating the Cordova Binary

* At this point the only remaining step is to generate the io.jxcore.node.jx plugin binary.

* From the ./jxcore-cordova path

```
jx compile io.jxcore.node.jxp
mv io.jxcore.node.jx ../
```

### Extraction Test

* move back to the root path of your build location.
* in that directory, you should see the io.jxcore.node.jx file.
* Run the following to sample an extract

```
jx io.jxcore.node.jx EXTRACT
```

* Review the files created in the directory io.jxcore.node

```
Total 96
-rw-r--r-- 1 501 20 1.1K Mar 15 18:47 Changelog.md
-rw-r--r-- 1 501 20 3.1K Mar 15 18:47 LICENSE
-rw-r--r-- 1 501 20 10K Mar 15 18:47 README.md
drwxr-xr-x 4 501 20 136B Mar 15 18:47 app/
drwxr-xr-x 16 501 20 544B Mar 15 18:47 bin/
-rw-r--r-- 1 501 20 1.0K Mar 15 18:47 index.js
-rw-r--r-- 1 501 20 1.8K Mar 15 18:47 install_and_run.bat
-rw-r--r-- 1 501 20 1.5K Mar 15 18:47 install_and_run.md
-rw-r--r-- 1 501 20 1.4K Mar 15 18:47 install_and_run.sh
drwxr-xr-x 3 501 20 102B Mar 15 18:47 node_modules/
-rw-r--r-- 1 501 20 680B Mar 15 18:47 package.json
-rw-r--r-- 1 501 20 4.7K Mar 15 18:47 plugin.xml
drwxr-xr-x 7 501 20 238B Mar 15 18:47 sample/
drwxr-xr-x 4 501 20 136B Mar 15 18:47 src/
drwxr-xr-x 7 501 20 238B Mar 15 18:47 test/
drwxr-xr-x 3 501 20 102B Mar 15 18:47 www/
```
