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

## Wraps calling the build process on a sub project that possess a CMake-based
#  build system.
#
#  This function is primarily meant for testing and is thus not intended to
#  cover all possible use cases.
#
#  :param directory_name: The root directory of the project we are building.
#  :param *args: Any number of additional arguments which are not recognized
#                kwargs. These arguments will be forwarded as command
#                line arguments to the cmake command used for the configure
#                phase. They usually will be things like
#                `-DSOME_VARIABLE=SOME_VALUE`
#
#  kwargs:
#     NO_INSTALL If provided, the install step is skipped.
#     RUN_TEST_INSTALL If provided the conf_build_test.cmake script is run
#                      recursively. Specifically, after building the primary
#                      project which lives in ${scb_test_dir}, the
#                      conf_build_test.cmake will be run on a subproject that
#                      lives in ${scb_test_dir}/package_tests. The developer is
#                      expected to write the subproject so that it tests the
#                      main package by leveraging it in the subproject's build
#                      (e.g., by find_package).
function(sub_cmake_build directory_name)
    set(scb_options NO_INSTALL RUN_TEST_INSTALL)
    set(scb_one_value)
    cmake_parse_arguments(scb "${scb_options}" "${scb_one_value}" "" ${ARGN})
    set(scb_test_dir ${CMAKE_CURRENT_SOURCE_DIR}/${directory_name})

    get_filename_component(
        scb_script_name "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY
    )
    set(scb_script_name ${scb_script_name}/conf_build_test.cmake)


    string (REPLACE ";" "\\\;" CMAKE_MODULE_PATH_STR "${CMAKE_MODULE_PATH}")

    add_test(
        NAME ${directory_name}
        COMMAND ${CMAKE_COMMAND} -DTEST_SOURCE=${scb_test_dir}
                                 -DTEST_NAME=${directory_name}
                                 -DNO_INSTALL=${scb_NO_INSTALL}
                                 -DRUN_TEST_INSTALL=${scb_RUN_TEST_INSTALL}
                                 -P ${scb_script_name}
                                 -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH_STR}
                                 ${scb_UNPARSED_ARGUMENTS}
    )
endfunction()

# Note that even though the first two build systems are subsets of the third, we
# maintain separate tests because the documentation states that all three build
# systems will work. Should CMake ever decide they don't, we want to know.
sub_cmake_build(bare_bones_cmake NO_INSTALL)
sub_cmake_build(warning_free_bare_bones NO_INSTALL)
sub_cmake_build(minimal_cmake RUN_TEST_INSTALL)
sub_cmake_build(bp_minimal_cmake RUN_TEST_INSTALL)
sub_cmake_build(minimal_cmaize)
