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

function(_cpp_toolchain_get _ctg_output _ctg_tc _ctg_var)
    file(READ ${_ctg_tc} _ctg_tc_contents)
    string(
        REGEX MATCH "set\\(${_ctg_var} \"([^\\)]*)\" CACHE INTERNAL \"\"\\)"
        _ctg_found "${_ctg_tc_contents}"
    )
    if(NOT _ctg_found)
        _cpp_error(
            "Toolchain: ${_ctg_tc} does not contain variable: ${_ctg_var}."
        )
    endif()
    set(${_ctg_output} "${CMAKE_MATCH_1}" PARENT_SCOPE)
endfunction()
