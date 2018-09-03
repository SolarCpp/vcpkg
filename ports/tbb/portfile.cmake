

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO SolarCute/tbb
    REF 4c3ffe5a5f37addef0dd6283c74c4402a3b4ebc9
    SHA512 ffde550909fc1d566ad36c08ab6d9a1d7b0c1b70c129c1c0fbdbb06a5b3c86585f0383d03285446f290f6a63efcd133b1bc1c75357ac35d92a4066c05937211b
    HEAD_REF master)

vcpkg_configure_cmake(
      SOURCE_PATH ${SOURCE_PATH}
      PREFER_NINJA
      OPTIONS
          -DTBB_BUILD_TESTS=OFF
  )


vcpkg_install_cmake()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include
)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/tbb)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/tbb/LICENSE ${CURRENT_PACKAGES_DIR}/share/tbb/copyright)
