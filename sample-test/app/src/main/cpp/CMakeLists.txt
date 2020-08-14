# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.

cmake_minimum_required(VERSION 3.4.1)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds it for you.
# Gradle automatically packages shared libraries with your APK.

# configure include dir
set(include_DIR ${sub_DIR}/../jni/include)

include_directories(
    ${include_DIR}
    ${include_DIR}/opencv)

# configure source dir
set(src_DIR ${sub_DIR})

add_library( # Sets the name of the library.
             ferns-lib

             # Sets the library as a static library.
             STATIC

             # Provides a relative path to your source file(s).
             # Associated headers in the same location as their source
             # file are automatically included.
             ${src_DIR}/affine_image_generator06.cc
             ${src_DIR}/affine_transformation_range.cc
             ${src_DIR}/buffer_management.cc
             ${src_DIR}/cmphomo.cc
             ${src_DIR}/ferns.cc
             ${src_DIR}/fern_based_point_classifier.cc
             ${src_DIR}/fine_gaussian_pyramid.cc
             ${src_DIR}/homography06.cc
             ${src_DIR}/homography_estimator.cc
             ${src_DIR}/main.cc
             ${src_DIR}/mcv.cc
             ${src_DIR}/mcvGaussianSmoothing.cc
             ${src_DIR}/planar_pattern_detector.cc
             ${src_DIR}/planar_pattern_detector_builder.cc
             ${src_DIR}/pyr_yape06.cc
             ${src_DIR}/template_matching_based_tracker.cc )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in the
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       ferns-lib )

