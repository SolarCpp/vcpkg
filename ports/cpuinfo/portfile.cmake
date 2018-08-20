include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/cpuinfo
    REF d0222b47948234cc01983243a2e0ede018f97f3a
    SHA512 0b39adc1443e0e2002f117454b967b08631a68a3b9a9ef87dae4952b8fd4edd63cd6c0f56bbf39996aa1d292ec50278210f0c076996bd881cd0958d62029f03a
    HEAD_REF master
)

set(OPTIONS ${OPTIONS} 
    -DCPUINFO_BUILD_UNIT_TESTS=OFF
    -DCPUINFO_BUILD_MOCK_TESTS=OFF
    -DCPUINFO_BUILD_BENCHMARKS=OFF
    -DCPUINFO_LIBRARY_TYPE=static
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${OPTIONS}        
    OPTIONS_DEBUG
        ${OPTIONS}
)

vcpkg_install_cmake()

#vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL
    ${SOURCE_PATH}/README.md
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpuinfo RENAME copyright)

vcpkg_copy_pdbs()