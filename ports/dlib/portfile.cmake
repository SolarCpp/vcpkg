include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    message("dlib only supports static linkage")
    set(VCPKG_LIBRARY_LINKAGE "static")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO davisking/dlib
    REF v19.15
    SHA512 e815d4cd3cf75de4bf3df25597f1b13e831129b8e780909194be05bde4c811792886e7370980edf0fe294aa1ad7a69ba9b9ca729e05713d3ee4f6aa4236baaf7
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/ignore_png_create_read_struct.patch" 
)

file(REMOVE_RECURSE ${SOURCE_PATH}/dlib/external/libjpeg)
file(REMOVE_RECURSE ${SOURCE_PATH}/dlib/external/libpng)
file(REMOVE_RECURSE ${SOURCE_PATH}/dlib/external/zlib)

# This fixes static builds; dlib doesn't pull in the needed transitive dependencies
file(READ "${SOURCE_PATH}/dlib/CMakeLists.txt" DLIB_CMAKE)
string(REPLACE "PNG_LIBRARY" "PNG_LIBRARIES" DLIB_CMAKE "${DLIB_CMAKE}")
file(WRITE "${SOURCE_PATH}/dlib/CMakeLists.txt" "${DLIB_CMAKE}")

set(WITH_CUDA OFF)
if("cuda" IN_LIST FEATURES)
  set(WITH_CUDA ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA 
    OPTIONS
        -DDLIB_LINK_WITH_SQLITE3=ON
        -DDLIB_USE_FFTW=ON
        -DDLIB_PNG_SUPPORT=ON
        -DDLIB_JPEG_SUPPORT=ON
        -DDLIB_USE_BLAS=ON
        -DDLIB_USE_LAPACK=ON
        -DDLIB_USE_CUDA=${WITH_CUDA}
        -DDLIB_GIF_SUPPORT=OFF
        -DDLIB_USE_MKL_FFT=OFF
    OPTIONS_DEBUG
        -DDLIB_ENABLE_ASSERTS=ON
        #-DDLIB_ENABLE_STACK_TRACE=ON
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/dlib)

# There is no way to suppress installation of the headers and resource files in debug build.
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Remove other files not required in package
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/all)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/appveyor)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/test)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/travis) 
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_neon)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_cudnn)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_cuda)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_cpp11)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_avx)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/cmake_utils/test_for_sse4)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/dlib/external/libpng/arm)

# Dlib encodes debug/release in its config.h. Patch it to respond to the NDEBUG macro instead.
file(READ ${CURRENT_PACKAGES_DIR}/include/dlib/config.h _contents)
string(REPLACE "/* #undef ENABLE_ASSERTS */" "#if defined(_DEBUG)\n#define ENABLE_ASSERTS\n#endif" _contents ${_contents})
string(REPLACE "#define DLIB_DISABLE_ASSERTS" "#if !defined(_DEBUG)\n#define DLIB_DISABLE_ASSERTS\n#endif" _contents ${_contents})
file(WRITE ${CURRENT_PACKAGES_DIR}/include/dlib/config.h "${_contents}")

file(READ ${CURRENT_PACKAGES_DIR}/share/dlib/dlib.cmake _contents)
string(REPLACE
    "get_filename_component(_IMPORT_PREFIX \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)\nget_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)"
    "get_filename_component(_IMPORT_PREFIX \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)"
    _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/dlib/dlib.cmake "${_contents}")

# Handle copyright
file(COPY ${SOURCE_PATH}/dlib/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/dlib)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/dlib/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/dlib/copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
