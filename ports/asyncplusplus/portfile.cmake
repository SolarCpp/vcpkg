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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/asyncplusplus-0.0.4)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/BeautyCpp/asyncplusplus/archive/v0.0.4.zip"
    FILENAME "asyncplusplus-0.0.4.zip"
    SHA512 4dd80a7a28b05fe9e3b43d8b88110b798e98218a492e2bc1ca02738d902056367b9371ecf5f5f86cc3473e4edcc6a8b9ebe3af68257c6e2a1cdbbaa5385552db
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

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Async++)
file(COPY ${CURRENT_BUILDTREES_DIR}/src/asyncplusplus-0.0.4/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/asyncplusplus)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/asyncplusplus/LICENSE ${CURRENT_PACKAGES_DIR}/share/asyncplusplus/copyright)

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/asyncplusplus3 RENAME copyright)
