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

## Determines if the value of an identifier is a CMake list
#
# CMake defines a list as a string that has substrings separated by semicolons.
# If the semicolons are escaped then they are not considered to be seperators.
#
# :param return: An identifier to hold the returned value
# :param list: A value to check for list-ness
function(_cpp_is_list _cil_return _cil_list)
    list(LENGTH _cil_list _cil_length)
    if("${_cil_length}" GREATER  "1")
        set(${_cil_return} 1 PARENT_SCOPE)
    else()
        set(${_cil_return} 0 PARENT_SCOPE)
    endif()
endfunction()
