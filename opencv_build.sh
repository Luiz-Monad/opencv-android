#!/bin/bash

# $1 = architecture
# $2 = base directory
# $3 = pass 1 if you want to export default compiler environment variables

. abi_settings.sh $1 $2 $3

pushd opencv

export SRC="`pwd`/sources"
export INSTALL="`pwd`/build-android"
export CMAKE_TOOLCHAIN="$SRC/platforms/android/android.toolchain.cmake"
export ANT_DIR="$2/apache-ant-1.10.0-bin"

rm -rf build-android-$1

mkdir build-android-$1
pushd build-android-$1

#dont use msys cmake, install the native build
#also, dont use the msys make too, use the toolkit one
#MAKE="/usr/bin/make"

echo "MAKE:" $MAKE
echo "AR:" $AR
echo "AS:" $AS
echo "CC:" $CC
echo "CPP:" $CPP
echo "CXX:" $CXX
echo "LD:" $LD
echo "STRIP:" $STRIP
echo "RANLIB:" $RANLIB
echo "NM:" $NM
echo "OBJCOPY:" $OBJCOPY
echo "OBJDUMP:" $OBJDUMP
echo "STRINGS:" $STRINGS
echo "SRC:" $SRC
echo "INSTALL:" $INSTALL
echo "CMAKE_TOOLCHAIN:" $CMAKE_TOOLCHAIN
echo "TOOLCHAIN_PREFIX:" $TOOLCHAIN_PREFIX
echo "ANT_DIR:" $ANT_DIR

echo "=-=-=-=-="
echo " prepare "
echo "=-=-=-=-="

#we dont need it because we're using the toolchain
unset ANDROID_NDK

cmake $SRC \
-G "Unix Makefiles" \
-DANDROID_NDK_HOST_X64=1 \
-DANDROID_API_LEVEL="$ANDROID_API_VERSION" \
-DANDROID_STANDALONE_TOOLCHAIN="$TOOLCHAIN_PREFIX" \
-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN" \
-DCMAKE_SYSTEM_NAME="Android" \
-DCMAKE_HOST_WIN32=1 \
-DCMAKE_SKIP_RPATH=1 \
-DCMAKE_MAKE_PROGRAM="$MAKE" \
-DCMAKE_CXX_COMPILER="$CXX" \
-DCMAKE_C_COMPILER="$CC" \
-DCMAKE_CXX="$CXX" \
-DCMAKE_CXXFLAGS="$CFLAGS" \
-DCMAKE_CC="$CC" \
-DCMAKE_CFLAGS="$CFLAGS" 

echo "=-=-=-=-="
echo "toolchain"
echo "=-=-=-=-="

cmake $SRC \
-DCMAKE_HOST_WIN32=1 \
-DCMAKE_MAKE_PROGRAM="$MAKE" \
-DCMAKE_AS="$AS" \
-DCMAKE_AR="$AR" \
-DCMAKE_CXX="$CXX" \
-DCMAKE_CXXFLAGS="$CFLAGS" \
-DCMAKE_CC="$CC" \
-DCMAKE_CFLAGS="$CFLAGS" \
-DCMAKE_LINKER:FILEPATH="$LD" \
-DCMAKE_STRIP="$STRIP" \
-DCMAKE_RANLIB="$RANLIB" \
-DCMAKE_NM="$NM" \
-DCMAKE_OBJCOPY="$OBJCOPY" \
-DCMAKE_OBJDUMP="$OBJDUMP" 

echo "=-=-=-=-="
echo "configure"
echo "=-=-=-=-="

cmake $SRC \
-DBUILD_EXAMPLES=0 \
-DBUILD_DOCS=0 \
-DBUILD_SHARED_LIBS=0 \
-DBUILD_JASPER=1 \
-DBUILD_JPEG=1 \
-DBUILD_PNG=1 \
-DBUILD_OPENEXR=1 \
-DBUILD_opencv_apps=0 \
-DWITH_IPP:BOOL=0 \
-DWITH_CUDA:BOOL=0 \
-DWITH_CAROTENE:BOOL=0 \
-DWITH_CUFFT:BOOL=0 \
-DWITH_DIRECTX:BOOL=0 \
-DWITH_DSHOW:BOOL=0 \
-DWITH_EIGEN:BOOL=0 \
-DWITH_JASPER:BOOL=1 \
-DWITH_JPEG:BOOL=1 \
-DWITH_MATLAB:BOOL=0 \
-DWITH_OPENCL:BOOL=0 \
-DWITH_OPENGL:BOOL=1 \
-DWITH_OPENEXR:BOOL=1 \
-DWITH_TIFF:BOOL=0 \
-DWITH_PNG:BOOL=1 \
-DWITH_VFW:BOOL=0 \
-DWITH_VTK:BOOL=0 \
-DWITH_WEBP:BOOL=0 \
-DWITH_WIN32UI:BOOL=0 \
-DM_LIBRARY="$LD_LIBRARY_PATH/libm" \
-DCMAKE_BUILD_TYPE="Release" \
-DCMAKE_INSTALL_PREFIX="$INSTALL"

echo "=-=-=-=-="
echo " samples "
echo "=-=-=-=-="

cmake $SRC \
-DANDROID_EXAMPLES_WITH_LIBS=1 \
-DBUILD_ANDROID_EXAMPLES=1 \
-DINSTALL_ANDROID_EXAMPLES=1 \
-DANDROID_ABI="$1" \
-DANDROID_EXECUTABLE="$ANDROID_EXECUTABLE" \
-DANDROID_SDK_TARGET="android-$ANDROID_API_VERSION" \
-DANDROID_NATIVE_API_LEVEL="$ANDROID_API_VERSION" \
-DANT_DIR="$ANT_DIR"

echo "=-=-=-=-="
echo " make it "
echo "=-=-=-=-="

make clean
make -j${NUMBER_OF_CORES} && make install || exit 1

popd
popd
