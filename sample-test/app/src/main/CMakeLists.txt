# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.

cmake_minimum_required(VERSION 3.4.1)

set(MODULE_DIR ${CMAKE_SOURCE_DIR}/jni)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds it for you.
# Gradle automatically packages shared libraries with your APK.

# configure include dir
set(INCLUDE_DIR ${MODULE_DIR}/include)
include_directories(
    ${INCLUDE_DIR})

# configure source dir
set(SRC_DIR ${MODULE_DIR}/src)
file(GLOB_RECURSE SRC_FILES "${SRC_DIR}/*.cpp")

# add our library
add_library(
    # Sets the name of the library.
    native-lib

    # Sets the library as a shared library.
    SHARED

    # Provides a relative path to your source file(s).
    # Associated headers in the same location as their source
    # file are automatically included.
    ${SRC_FILES} )

# configure static-linked libs
set(LIB_DIR ${MODULE_DIR}/libs/${ANDROID_ABI})
set(LIB3_DIR ${MODULE_DIR}/3rdparty/libs/${ANDROID_ABI})
file(GLOB LIBS "${LIB_DIR}/*")
file(GLOB LIBS3 "${LIB3_DIR}/*")

add_library(
    libopencv
    STATIC IMPORTED)

set_target_properties(
    libopencv
    PROPERTIES IMPORTED_LOCATION
    ${LIB_DIR})

set_target_properties(
    libopencv
    PROPERTIES IMPORTED_LOCATION
    ${LIB3_DIR})

target_link_libraries(
    native-lib
    ${LIBS}
    ${LIBS3}
    ${LIBS})

# add another cmake module
# set(FERNS_DIR ${CMAKE_SOURCE_DIR}/cpp)
# add_subdirectory(${FERNS_DIR})

# Searches for a specified prebuilt library and stores the path as a
# variable. Because system libraries are included in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library(
    # Sets the name of the path variable.
    log-lib

    # Specifies the name of the NDK library that
    # you want CMake to locate.
    log )

find_library(
    # Sets the name of the path variable.
    z-lib

    # Specifies the name of the NDK library that
    # you want CMake to locate.
    z )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in the
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries(
    # Specifies the target library.
    native-lib

    # Other static libraries with cmake
    # libferns

    # Other shared libraries
    libopencv

    # Links the target library to the log library
    # included in the NDK.
    ${z-lib}
    ${log-lib} )
