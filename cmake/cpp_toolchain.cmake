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

function(_cpp_change_toolchain)
    cpp_parse_arguments(
        _cct "${ARGN}"
        OPTIONS TOOLCHAIN
        LISTS CMAKE_ARGS
    )
    cpp_option(_cct_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    if(EXISTS ${_cct_TOOLCHAIN})
        file(READ "${_cct_TOOLCHAIN}" _cct_contents)
    endif()
    foreach(_cct_cmake_arg ${_cct_CMAKE_ARGS})
        string(REGEX MATCH "([^=]*)=(.*)" _cct_found "${_cct_cmake_arg}")
        set(_cct_var "${CMAKE_MATCH_1}")
        set(_cct_val "${CMAKE_MATCH_2}")
        _cpp_contains(_cct_has_val "${_cct_var}" "${_cct_contents}")
        set(_cct_new_line "set(${_cct_var} ${_cct_val} CACHE INTERNAL \"\")")
        if(_cct_has_val)
            set(_cct_regex_str "set\\(${_cct_var} [^\\)]*\\)")
            string(
                    REGEX
                    REPLACE "${_cct_regex_str}"
                    "${_cct_new_line}"
                    _cct_contents "${_cct_contents}"
            )
        else()
            set(_cct_contents "${_cct_contents}${_cct_new_line}\n")
        endif()
    endforeach()
    _cpp_unpack_list(_cct_unpacked "${_cct_contents}")
    file(WRITE "${_cct_TOOLCHAIN}" "${_cct_unpacked}")
endfunction()

function(_cpp_write_toolchain_file)
    cpp_parse_arguments(
        _cwtf "${ARGN}"
        OPTIONS DESTINATION
    )
    cpp_option(_cwtf_DESTINATION "${CMAKE_BINARY_DIR}")
    set(_cwtf_file ${_cwtf_DESTINATION}/toolchain.cmake)
    _cpp_get_toolchain_vars(_cwtf_vars)
    foreach(_cwtf_var ${_cwtf_vars})
        _cpp_is_not_empty(_cwtf_non_empty ${_cwtf_var})
        if(_cwtf_non_empty)
            #string(REPLACE ";" "\;" _cwtf_temp "${${_cwtf_var}}")
            _cpp_pack_list(_cwtf_packed "${${_cwtf_var}}")
            list(APPEND _cwtf_contents "${_cwtf_var}=\"${_cwtf_packed}\"")
        endif()
    endforeach()
    _cpp_change_toolchain(TOOLCHAIN ${_cwtf_file} CMAKE_ARGS ${_cwtf_contents})
    set(CMAKE_TOOLCHAIN_FILE ${_cwtf_file} PARENT_SCOPE)
endfunction()


