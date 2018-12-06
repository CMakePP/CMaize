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

## Checks if a toolchain contains a variable
#
# :param output: The identifier to store the result in.
# :param tc: The toolchain to search for the variable.
# :param var: The identifier to search for
function(_cpp_toolchain_contains _ctg_output _ctg_tc _ctg_var)
    file(READ ${_ctg_tc} _ctg_tc_contents)
    _cpp_contains(_ctg_temp "${_ctg_var}" "${_ctg_tc_contents}")
    set(${_ctg_output} ${_ctg_temp} PARENT_SCOPE)
endfunction()
