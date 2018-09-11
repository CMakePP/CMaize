cmake_minimum_required(VERSION 3.6)
project(CPP VERSION 0.0.0)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(CMakePackageConfigHelpers)
include(CPPMain)
include(cpp_options)
CPPMain()
cpp_option(BUILD_TESTS TRUE)

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()


#These are the names/paths for the generated config files pre-install
set(cpp_config_file ${CMAKE_BINARY_DIR}/cpp-config.cmake)
set(cpp_version_file ${CMAKE_BINARY_DIR}/cpp-config-version.cmake)

#Configure the main config file
configure_package_config_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/cpp-config.cmake.in
        ${cpp_config_file}
        INSTALL_DESTINATION ${CPP_SHAREDIR}
)

#Configure the version file
write_basic_package_version_file(
        ${cpp_version_file} COMPATIBILITY SameMajorVersion
)


#Install the submodules
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cmake
        DESTINATION ${CPP_SHAREDIR})

#Install the config files
install(
    FILES "${cpp_config_file}" "${cpp_version_file}"
    DESTINATION ${CPP_SHAREDIR}
)
