################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include(cpp_cmake_helpers)
include(cpp_checks)
include(unit_testing/cpp_add_test)
include(unit_testing/cpp_dummy_cxx_library)
include(unit_testing/cpp_naive_cxx_package)
include(unit_testing/cpp_install_naive_cxx_package)
include(unit_testing/cpp_naive_find_module)

function(_cpp_make_random_dir _cmrd_result _cmrd_prefix)
    string(RANDOM _cmrd_random_prefix)
    set(${_cmrd_result} ${_cmrd_prefix}/${_cmrd_random_prefix} PARENT_SCOPE)
    file(MAKE_DIRECTORY ${_cmrd_prefix}/${_cmrd_random_prefix})
endfunction()

function(_cpp_dummy_cxx_executable _cdce_prefix)
    file(WRITE ${_cdce_prefix}/main.cpp "int main(){return 2;}")
endfunction()

function(_cpp_dummy_cxx_package _cdcp_prefix)
    set(_cdcp_O_kwargs NAME)
    cmake_parse_arguments(
            _cdcp
            ""
            "${_cdcp_O_kwargs}"
            ""
            ${ARGN}
    )
    cpp_option(_cdcp_NAME dummy)
    set(_cdcp_root ${_cdcp_prefix}/${_cdcp_NAME})
    _cpp_dummy_cxx_library(${_cdcp_root})
    _cpp_write_list(
        ${_cdcp_root}
        NAME ${_cdcp_NAME}
        CONTENTS "include(cpp_targets)"
                 "cpp_add_library("
                 "  ${_cdcp_NAME}"
                 "  SOURCES  a.cpp"
                 "  INCLUDES a.hpp"
                 ")"
                 "cpp_install(TARGETS ${_cdcp_NAME})"
    )
endfunction()

function(_cpp_install_dummy_cxx_package _cidcp_prefix)
    cmake_parse_arguments(_cidcp "" "NAME" "" ${ARGN})
    cpp_option(_cidcp_NAME dummy)
    set(_cidcp_root ${_cidcp_prefix}/${_cidcp_NAME})
    _cpp_dummy_cxx_package(${_cidcp_prefix} NAME ${_cidcp_NAME})
    _cpp_run_sub_build(
        ${_cidcp_root}
        INSTALL_DIR ${_cidcp_prefix}/install
        NAME ${_cidcp_NAME}
    )
    #Sanity check
    set(_cidcp_path ${_cidcp_prefix}/install/share/cmake)
    _cpp_assert_exists(
        ${_cidcp_path}/${_cidcp_NAME}/${_cidcp_NAME}-config.cmake
    )
endfunction()



function(_cpp_make_test_toolchain _cmtt_prefix)
    file(READ ${CMAKE_TOOLCHAIN_FILE} _cmtt_file)
    string(REGEX REPLACE "\n" ";" _cmtt_file "${_cmtt_file}")
    set(_cmtt_new_file)
    foreach(_cmtt_line ${_cmtt_file})
        string(FIND "${_cmtt_line}" "set(CPP_INSTALL_CACHE"  _cmtt_is_cache)
        if("${_cmtt_is_cache}" STREQUAL "-1")
            list(APPEND _cmtt_new_file "${_cmtt_line}")
        else()
            list(
                APPEND
                _cmtt_new_file
                "set(CPP_INSTALL_CACHE \"${_cmtt_prefix}/cpp_cache\")"
            )
        endif()
    endforeach()
    string(REGEX REPLACE ";" "\n" _cmtt_new_file "${_cmtt_new_file}")
    file(WRITE "${_cmtt_prefix}/toolchain.cmake" "${_cmtt_new_file}")
    set(CMAKE_TOOLCHAIN_FILE "${_cmtt_prefix}/toolchain.cmake" PARENT_SCOPE)
endfunction()

macro(_cpp_setup_build_env _csbe_name)
    #All tests associated with test will go in this directory
    set(test_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${_csbe_name})

    #The particular run will go in a randomly generated sub-directory
    _cpp_make_random_dir(test_prefix ${test_prefix})
    message(
       "Tests from this run of ${_cbse_name} are located in ${test_prefix}"
    )

    #Make sure we don't contaminate the real cache or build directory
    _cpp_make_test_toolchain(${test_prefix})
    set(CMAKE_BINARY_DIR ${test_prefix})
    include(${CMAKE_TOOLCHAIN_FILE})
endmacro()

#Factor out the testing of the installed library
function(verify_dummy_install test_root)
    _cpp_assert_exists(${test_root}/include/dummy/a.hpp)
    _cpp_assert_exists(${test_root}/lib)
    foreach(share_file dummy-config.cmake dummy-config-version.cmake
            dummy-targets.cmake)
        _cpp_assert_exists(${test_root}/share/cmake/dummy/${share_file})
    endforeach()
endfunction()

function(verify_cpp_install test_root)
    foreach(share_file cpp-config.cmake cpp-config-version.cmake)
        _cpp_assert_exists(${test_root}/share/cmake/cpp/${share_file})
    endforeach()
endfunction()
