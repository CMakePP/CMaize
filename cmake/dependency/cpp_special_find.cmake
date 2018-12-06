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

include_guard()
include(dependency/cpp_find_package)

function(_cpp_special_find _csf_output _csf_cache _csf_name _csf_version
                           _csf_comps)
    string(TOUPPER "${_csf_name}" _csf_uc_name)
    string(TOLOWER "${_csf_name}" _csf_lc_name)
    set(_csf_was_found FALSE)
    foreach(_csf_case ${_csf_name} ${_csf_uc_name} ${_csf_lc_name})
        foreach(_csf_suffix _DIR _ROOT)
            set(_csf_var ${_csf_case}${_csf_suffix})
            #Did the user set this variable
            _cpp_is_not_empty(_csf_set ${_csf_var})
            if(_csf_set)
                set(_csf_value ${${_csf_var}})
                _cpp_debug_print(
                    "Looking for ${_csf_name} with ${_csf_var}=${_csf_value}"
                )
                _cpp_find_package(
                    _csf_found
                    ${_csf_cache}
                    ${_csf_name}
                    "${_csf_version}"
                    "${_csf_comps}"
                    ${_csf_value}
                )
                if(NOT _csf_found)
                   _cpp_error(
                       "${_csf_var} set, but ${_csf_name} not found there"
                       "Troubleshooting:"
                       "  Is ${_csf_name} installed to ${_csf_value}?"
                   )
                endif()
                set(_csf_was_found TRUE)
                break()
            endif()
        endforeach()
        if(_csf_was_found)
            break()
        endif()
    endforeach()
    set(${_csf_output} ${_csf_was_found} PARENT_SCOPE)
endfunction()

