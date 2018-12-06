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

function(_cpp_sanitize_version _csv_output _csv_version)
    _cpp_is_empty(_csv_no_version _csv_version)
    if(_csv_no_version)
        set(${_csv_output} "" PARENT_SCOPE)
        return()
    endif()

    string(REGEX MATCH "v(.*)" _csv_start_w_v "${_csv_version}")
    _cpp_debug_print("Found v in ${_csv_version} = ${_csv_start_w_v}.")
    if(_csv_start_w_v)
        set(_csv_temp "${CMAKE_MATCH_1}")
    else()
        set(_csv_temp "${_csv_version}")
    endif()

    set(${_csv_output} ${_csv_temp} PARENT_SCOPE)
endfunction()
