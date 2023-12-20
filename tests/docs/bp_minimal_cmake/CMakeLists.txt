# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.5)
project(hello_world VERSION 1.0.0)

add_executable(hello_world hello_world.cpp)

include(GNUInstallDirs)
set(target_name hello_world)
install(
    TARGETS ${target_name}
    EXPORT ${PROJECT_NAME}Targets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

include(CMakePackageConfigHelpers)

set(install_cmake_dir ${CMAKE_INSTALL_LIBDIR}/cmake)
install(
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}-targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${install_cmake_dir}/${PROJECT_NAME}
)

set(version_file ${PROJECT_NAME}-config-version.cmake)
set_property(
    TARGET ${target_name}
    PROPERTY VERSION ${${PROJECT_NAME}_VERSION}
)
set_property(
    TARGET ${target_name}
    PROPERTY
        INTERFACE_${target_name}_MAJOR_VERSION ${${PROJECT_NAME}_VERSION_MAJOR}
)
set_property(
    TARGET ${target_name}
    APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${target_name}_MAJOR_VERSION
)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${version_file}"
    VERSION ${${PROJECT_NAME}_VERSION}
    COMPATIBILITY SameMajorVersion
)

set(config_file ${PROJECT_NAME}-config.cmake)
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/${config_file}.in
    "${CMAKE_CURRENT_BINARY_DIR}/${config_file}"
    INSTALL_DESTINATION ${install_cmake_dir}/${PROJECT_NAME}
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${config_file}
          ${CMAKE_CURRENT_BINARY_DIR}/${version_file}
    DESTINATION ${install_cmake_dir}/${PROJECT_NAME}

)

# The below lines of code are used in unit testing this code example
include(CTest)
enable_testing()

add_test(
    NAME "run_hello_world"
    COMMAND hello_world
)
