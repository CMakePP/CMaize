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

include(cpp_checks) #For _cpp_is_valid
include(cpp_options) #For cpp_option

function(_cpp_get_toolchain_vars _cgtv_return)
    set(_cgtv_vars CMAKE_C_COMPILER CMAKE_CXX_COMPILER CMAKE_Fortran_COMPILER
                    CMAKE_SYSTEM_NAME
                    CMAKE_MODULE_PATH CMAKE_PREFIX_PATH
                    BUILD_SHARED_LIBS
                    CMAKE_SHARED_LIBRARY_PREFIX CMAKE_SHARED_LIBRARY_SUFFIX
                    CMAKE_STATIC_LIBRARY_PREFIX CMAKE_STATIC_LIBRARY_SUFFIX
                    CPP_INSTALL_CACHE CPP_GITHUB_TOKEN
    )
    set(${_cgtv_return} "${_cgtv_vars}" PARENT_SCOPE)
endfunction()

function(_cpp_write_toolchain_file)
    set(_cwtf_O_kwargs DESTINATION)
    cmake_parse_arguments(_cwtf "" "${_cwtf_O_kwargs}" "" ${ARGN})
    cpp_option(_cwtf_DESTINATION "${CMAKE_BINARY_DIR}")
    set(_cwtf_file ${_cwtf_DESTINATION}/toolchain.cmake)
    set(_cwtf_contents)
    _cpp_get_toolchain_vars(_cwtf_vars)
    foreach(_cwtf_var ${_cwtf_vars})
        _cpp_non_empty(_cwtf_non_empty ${_cwtf_var})
        if(_cwtf_non_empty)
            set(_cwtf_line "set(${_cwtf_var} \"${${_cwtf_var}}\")\n")
            set(_cwtf_contents "${_cwtf_contents}${_cwtf_line}")
        endif()
    endforeach()
    file(WRITE ${_cwtf_file} ${_cwtf_contents})
    set(CMAKE_TOOLCHAIN_FILE ${_cwtf_file} PARENT_SCOPE)
endfunction()

function(_cpp_change_toolchain)
    set(_cct_O_kwargs TOOLCHAIN)
    set(_cct_M_kwargs VARIABLES)
    cmake_parse_arguments(_cct "" "${_cct_O_kwargs}" "${_cct_M_kwargs}" ${ARGN})
    cpp_option(_cct_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    file(READ "${_cct_TOOLCHAIN}" _cct_contents)
    list(LENGTH _cct_VARIABLES _cct_length)
    set(_cct_i "0")
    while(_cct_i LESS _cct_length)
        math(EXPR _cct_j "${_cct_i} + 1")
        list(GET _cct_VARIABLES "${_cct_i}" _cct_var)
        list(GET _cct_VARIABLES "${_cct_j}" _cct_value)
        _cpp_contains(_cct_has_val "${_cct_var}" "${_cct_contents}")
        set(_cct_new_line "set(${_cct_var} \"${_cct_value}\")")
        if(_cct_has_val)
            set(_cct_regex_str "set\\(${_cct_var} [^\\)]*\\)")
            string(
                REGEX
                REPLACE "${_cct_regex_str}"
                "${_cct_new_line}"
                _cct_contents "${_cct_contents}"
            )
        else()
            list(APPEND _cct_contents "${_cct_new_line}")
        endif()
        math(EXPR _cct_i "${_cct_i} + 2")
    endwhile()
    file(WRITE "${_cct_TOOLCHAIN}" "${_cct_contents}")
endfunction()
