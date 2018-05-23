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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/lmdbxx-1.0.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SolarCpp/lmdbxx/archive/v1.0.0.zip"
    FILENAME "lmdbxx-1.0.0.zip"
    SHA512 fc9d2a50cd8b0cf7591e4562fc3d9637aa695f0b375d63bf26ad2fa8525d5a1ea12070fd3e511b74d107ae8f6c2946bab850c7496b92b12f69919bf489489019
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${SOURCE_PATH}/lmdb++.h 
     DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/UNLICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(RENAME ${CURRENT_PACKAGES_DIR}/share/${PORT}/UNLICENSE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/lmdbxx RENAME copyright)
