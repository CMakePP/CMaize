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
include(kwargs/kwargs)
include(toolchain/cpp_toolchain_get_vars)

function(_cpp_change_toolchain)
    _cpp_Kwargs_ctor(
        _cct_kwargs "${ARGN}"
        OPTIONS TOOLCHAIN
        LISTS CMAKE_ARGS
    )
    _cpp_Kwargs_set_default(${_cct_kwargs} TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    _cpp_Kwargs_kwarg_value(${_cct_kwargs} _cct_tc TOOLCHAIN)
    _cpp_exists(_cct_is_file "${_cct_tc}")
    if(_cct_is_file)
        file(READ "${_cct_tc}" _cct_contents)
    endif()
    _cpp_Kwargs_kwarg_value(${_cct_kwargs} _cct_args CMAKE_ARGS)
    foreach(_cct_cmake_arg ${_cct_args})
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
    file(WRITE "${_cct_tc}" "${_cct_unpacked}")
endfunction()

function(_cpp_write_toolchain_file)
    _cpp_Kwargs_ctor(_cwtf_kwargs "${ARGN}" OPTIONS DESTINATION)
    _cpp_Kwargs_set_default(${_cwtf_kwargs} DESTINATION ${CMAKE_BINARY_DIR})
    _cpp_Kwargs_kwarg_value(${_cwtf_kwargs} _cwtf_dest DESTINATION)

    set(_cwtf_file ${_cwtf_dest}/toolchain.cmake)
    _cpp_toolchain_get_vars(_cwtf_vars)
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


