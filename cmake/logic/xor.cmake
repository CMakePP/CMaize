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

## Ensures that only one of the provided identifiers is set to a true value
#
# Logic in CMake is a pain. This function implements xor on an arbitrary number
# of inputs and will return true if one, and only one, of them is true. The
# return will be false in all other instances.
#
# :param return: True if only one of the identifiers is true.
# :param args: A variadic list of identifiers to check for truth-ness.
function(_cpp_xor _cx_return)
    set(_cx_found_true FALSE)
    foreach(_cx_item ${ARGN})
        if(${_cx_item} AND _cx_found_true)
            _cpp_set_return(${_cx_return} FALSE)
            return()
        elseif(${_cx_item})
            set(_cx_found_true TRUE)
        endif()
    endforeach()
    _cpp_set_return(${_cx_return} ${_cx_found_true})
endfunction()
