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

include(ExternalProject)
include(cpp_options)
include(cpp_checks)
include(cpp_print)
include(cpp_assert)

function(cpp_local_cmake _clc_name _clc_dir)
    ExternalProject_Add(
        ${_clc_name}_External
        SOURCE_DIR ${_clc_dir}
        INSTALL_DIR ${CMAKE_BINARY_DIR}/install
        CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}

    )
endfunction()


function(cpp_github_cmake _cgc_name _cgc_url)
    _cpp_parse_gh_url(_cgc_repo ${_cgc_url})
    set(_cgc_T_kwargs PRIVATE)
    set(_cgc_O_kwargs TOKEN BRANCH)
    set(_cgc_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
        _cgc
        "${_cgc_T_kwargs}"
        "${_cgc_O_kwargs}"
        "${_cgc_M_kwargs}"
        ${ARGN}
    )
    set(_cgc_gh_api "https://api.github.com/repos")

    _cpp_option(_cgc_BRANCH master)
    _cpp_is_not_empty(_cgc_token_set _cgc_TOKEN)
    if(_cgc_token_set AND _cgc_PRIVATE)
        set(_cgc_token "?access_token=${_cgc_TOKEN}")
    elseif(_cgc_PRIVATE)
        set(
            _cgc_msg1
            "Private repo encountered, but no token set.  Did you forget to"
        )
        message(
           FATAL_ERROR
           "${_cgc_msg1} set CPP_GITHUB_TOKEN?"
        )
    endif()
    set(
        _cgc_url
        "${_cgc_gh_api}/${_cgc_repo}/tarball/${_cgc_BRANCH}${_cgc_token}"
    )

    set(_crsb_add_args)
    foreach(_cgc_arg ${_cgc_CMAKE_ARGS})
        list(APPEND _cgc_add_args "-D${_cgc_arg}")
    endforeach()
    _cpp_debug_print("Building CMake project at URL: ${_cgc_url}")
    ExternalProject_Add(
        ${_cgc_name}_External
        URL ${_cgc_url}
        INSTALL_DIR ${CMAKE_BINARY_DIR}/install
        CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   ${_cgc_add_args}
    )
endfunction()
