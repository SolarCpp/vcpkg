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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/poco-onlyosp-1.9.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SolarCpp/poco/archive/onlyosp-1.9.0.tar.gz"
    FILENAME "onlyosp-1.9.0.tar.gz"
    SHA512 09acbd163587358a49186b7f0ff6d64afd5ea400e4c0d84c811bac26af1139571091c6d74adc5822e45fc8c5ec28d7f71e6257e0ea2716932afc4f91df09f9fc
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/pocoosp RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)


vcpkg_fixup_cmake_targets(CONFIG_PATH cmake)
file(REMOVE ${CURRENT_PACKAGES_DIR}/share/pocoosp/PocoConfig.cmake)
file(REMOVE ${CURRENT_PACKAGES_DIR}/share/pocoosp/PocoConfigVersion.cmake)

# copy license
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/pocoosp)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pocoosp/LICENSE ${CURRENT_PACKAGES_DIR}/share/pocoosp/copyright)