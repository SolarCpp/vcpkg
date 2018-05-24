# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/cpp-bredis-0.04)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SolarCpp/cpp-bredis/archive/v0.04.tar.gz"
    FILENAME "cpp-bredis-v0.04.tar.gz"
    SHA512 9d0e93717abdd747006c87a746a31dca0db46f63f48b8530ff3bac4e5f2bbb82c4c944472ba4552b852d5c5d6729b68e22a7fcf36007b1463397cd7a656837a4
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

file(GLOB HEADER_FILES ${SOURCE_PATH}/include/bredis/*.hpp )
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/bredis/)

file(GLOB HEADER_FILES_IMPL ${SOURCE_PATH}/include/bredis/impl/*.ipp )
file(INSTALL ${HEADER_FILES_IMPL} DESTINATION ${CURRENT_PACKAGES_DIR}/include/bredis/impl)

#vcpkg_install_cmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpp-bredis RENAME copyright)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpp-bredis)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/cpp-bredis/LICENSE ${CURRENT_PACKAGES_DIR}/share/cpp-bredis/copyright)