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
  1. export ANDROID_NDK={Android NDK Base Path}
  2. you need msys and cmake, and the NDK of course.
  3. pacman -S make perl mingw-w64-x86_64-clang git pkg-config python
* Compile
  ./android_build.sh
* Done
  Now you can go suffer trying to use this on Java in Android Studio.

Have fun!
---------
  . Have fun
