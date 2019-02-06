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
include(utility/set_return)

## Determines if the values held by two identifiers are the same
#
# This function is capable of comparing native CMake objects (strings and
# lists). Two objects are equal if their string representations are identical.
#
# :param return: An identifier to hold the result of the comparision.
# :param lhs: The value on the left of the imaginary "=="
# :param rhs: The value on the right of the imaginary "=="
#
# :Example Usage
function(_cpp_are_equal _cae_return _cae_lhs _cae_rhs)
    if("${_cae_lhs}" STREQUAL "${_cae_rhs}")
        _cpp_set_return(${_cae_return} 1)
    else()
        _cpp_set_return(${_cae_return} 0)
    endif()
endfunction()
