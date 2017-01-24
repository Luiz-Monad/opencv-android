[OpenCV-Android](https://github.com/Byte-666/opencv-android)
==============

* OpenCV for Android compiled statically using msys2 on windows.
* Supports Android 15
* [OpenCV](https://github.com/opencv/opencv)

Supported Architecture
----
* armv7
* armv7-neon
* aarch64
* x86
* x86_64

Instructions
----
* Set environment variable

  - export ANDROID_SDK={Android SDK Base Path}
  - export ANDROID_NDK={Android NDK Base Path}
  
* Download and install deps  
  - You need msys and cmake, and the NDK of course.
  - pacman -S make perl mingw-w64-x86_64-clang git pkg-config python python2

* Samples

  - If you want to build the samples you need apache-ant and the SDK,
    the SDK is only needed for this, you can skip it.
  - wget https://www.apache.org/dist/ant/binaries/apache-ant-1.10.0-bin.zip
    tar -xzf apache-ant-1.10.0-bin.zip

* Compile

  - ./android_build.sh

* Done

  - Now you can go suffer trying to use this on Java in Android Studio.

Have fun!
---------
* Have fun
