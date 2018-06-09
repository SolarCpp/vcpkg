include(vcpkg_common_functions)


set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/poco-posp-1.9.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/SolarCpp/poco/archive/posp-1.9.0.tar.gz"
    FILENAME "posp-1.9.0.tar.gz"
    SHA512 dda4a7f0931c89a1ae6c5ad75d816c49cf39e7bb88f50d9cf59f887f7e465766cc33ae4809d75d0bba47548538e3e316f10266db2bb3cb85f41e1e4acd860702
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/config_h.patch
        ${CMAKE_CURRENT_LIST_DIR}/find_pcre.patch
        ${CMAKE_CURRENT_LIST_DIR}/foundation-public-include-pcre.patch
        ${CMAKE_CURRENT_LIST_DIR}/fix-static-internal-pcre.patch
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" POCO_STATIC)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" POCO_MT)

if("mysql" IN_LIST FEATURES)
    # enabling MySQL support
    set(MYSQL_INCLUDE_DIR "${CURRENT_INSTALLED_DIR}/include/mysql")
    set(MYSQL_LIB "${CURRENT_INSTALLED_DIR}/lib/libmysql.lib")
    set(MYSQL_LIB_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib/libmysql.lib")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPOCO_STATIC=${POCO_STATIC}
        -DPOCO_MT=${POCO_MT}
        -DENABLE_SEVENZIP=ON
        -DENABLE_TESTS=OFF
        -DPOCO_UNBUNDLED=ON # OFF means: using internal copy of sqlite, libz, pcre, expat, ...
        -DMYSQL_INCLUDE_DIR=${MYSQL_INCLUDE_DIR}
    OPTIONS_RELEASE
        -DMYSQL_LIB=${MYSQL_LIB}
    OPTIONS_DEBUG
        -DMYSQL_LIB=${MYSQL_LIB_DEBUG}
)

vcpkg_install_cmake()


if(WIN32)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/cpspc.exe ${CURRENT_PACKAGES_DIR}/tools/cpspc.exe)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/f2cpsp.exe ${CURRENT_PACKAGES_DIR}/tools/f2cpsp.exe)
elseif(LINUX)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
    file(COPY ${CURRENT_PACKAGES_DIR}/bin/cpspc ${CURRENT_PACKAGES_DIR}/tools/cpspc)
    file(COPY ${CURRENT_PACKAGES_DIR}/bin/f2cpsp ${CURRENT_PACKAGES_DIR}/tools/f2cpsp)
endif()


if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE 
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/bin)
else()
    if(WIN32)
        file(REMOVE 
            ${CURRENT_PACKAGES_DIR}/bin/cpspc.pdb
            ${CURRENT_PACKAGES_DIR}/bin/f2cpsp.pdb
            ${CURRENT_PACKAGES_DIR}/debug/bin/cpspc.exe
            ${CURRENT_PACKAGES_DIR}/debug/bin/cpspc.pdb
            ${CURRENT_PACKAGES_DIR}/debug/bin/f2cpsp.exe
            ${CURRENT_PACKAGES_DIR}/debug/bin/f2cpsp.pdb)
    elseif(LINUX)
        file(REMOVE_RECURSE 
            ${CURRENT_PACKAGES_DIR}/bin
            ${CURRENT_PACKAGES_DIR}/debug/bin)
    endif()
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Poco)

# copy license
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/posp)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/posp/LICENSE ${CURRENT_PACKAGES_DIR}/share/posp/copyright)
