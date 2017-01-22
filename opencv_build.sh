#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd opencv

export SRC="`pwd`/sources"
export INSTALL="`pwd`/build-android"
export CMAKE_TOOLCHAIN="$SRC/platforms/android/android.toolchain.cmake"

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

echo "=-=-=-=-="
echo " prepare "
echo "=-=-=-=-="

unset ANDROID_NDK

cmake $SRC \
-G "Unix Makefiles" \
-DANDROID_NDK:PATH="/c/Users/Luiz/AppData/Local/Android/sdk/ndk-bundle" \
-DANDROID_NDK_HOST_X64=ON \
-DANDROID_API_LEVEL="$ANDROID_API_VERSION" \
-DANDROID_STANDALONE_TOOLCHAIN="$TOOLCHAIN_PREFIX" \
-DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN" \
-DCMAKE_SYSTEM_NAME=Android \
-DCMAKE_HOST_WIN32=1 
-DCMAKE_MAKE_PROGRAM="$MAKE" \
-DCMAKE_CXX_COMPILER:FILEPATH="$CXX" \
-DCMAKE_C_COMPILER:FILEPATH="$CC" \
-DCMAKE_AS="$AS" \
-DCMAKE_AR="$AR" \
-DCMAKE_CXX_COMPILER:PATH="$CXX" \
-DCMAKE_C_COMPILER:PATH="$CC" 
-DCMAKE_CXX:PATH="$CXX" \
-DCMAKE_CXXFLAGS="$CFLAGS" \
-DCMAKE_CC:PATH="$CC" \
-DCMAKE_CFLAGS="$CFLAGS" \
-DCMAKE_LINKER:PATH="$LD" \
-DCMAKE_STRIP:PATH="$STRIP" \
-DCMAKE_RANLIB:PATH="$RANLIB" \
-DCMAKE_NM:PATH="$NM" \
-DCMAKE_OBJCOPY:PATH="$OBJCOPY" \
-DCMAKE_OBJDUMP:PATH="$OBJDUMP" \
-DM_LIBRARY="$LD_LIBRARY_PATH/libm" 

#-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
#-DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
#-DCMAKE_STATIC_LINKER_FLAGS="$LDFLAGS" \

echo "=-=-=-=-="
echo "configure"
echo "=-=-=-=-="

cmake $SRC \
-DCMAKE_BUILDTYPE=Release \
-DANDROID_EXAMPLES_WITH_LIBS=1 \
-DBUILD_EXAMPLES=0 \
-DBUILD_DOCS=0 \
-DBUILD_SHARED_LIBS=0 \
-DBUILD_JASPER=1 \
-DBUILD_JPEG=1 \
-DBUILD_PNG=1 \
-DBUILD_OPENEXR=1 \
-DBUILD_opencv_apps=0 \
-DWITH_IPP:BOOL="0" \
-DWITH_CUDA:BOOL="0" \
-DWITH_CAROTENE:BOOL="0" \
-DWITH_CUFFT:BOOL="0" \
-DWITH_DIRECTX:BOOL="0" \
-DWITH_DSHOW:BOOL="0" \
-DWITH_EIGEN:BOOL="0" \
-DWITH_JASPER:BOOL="1" \
-DWITH_MATLAB:BOOL="0" \
-DWITH_OPENGL:BOOL="1" \
-DWITH_OPENEXR:BOOL="1" \
-DWITH_TIFF:BOOL="0" \
-DWITH_VFW:BOOL="0" \
-DWITH_VTK:BOOL="0" \
-DWITH_WEBP:BOOL="0" \
-DWITH_WIN32UI:BOOL="0" \
-DCMAKE_INSTALL_PREFIX="$INSTALL" 

echo "making"

make clean
make -j${NUMBER_OF_CORES} && make install || exit 1

popd
popd
