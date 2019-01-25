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

## Determines if the values held by two identifiers are the same
#
# For all intents and purposes this function implements ``lhs == rhs``. Since
# pretty much everything in CMake is a string this just compares the values as
# strings. In turn lists will be demoted to semicolon separated strings. This
# function only works with CMake native objects.
#
# :param return: An identifier to hold the result.
# :param lhs: The identifier holding the value for the left side of the equality
#             comparison.
# :param rhs: The identifier holding the value for the right side of the
#             equality comparison.
function(_cpp_are_equal _cae_return _cae_lhs _cae_rhs)
    if("${_cae_lhs}" STREQUAL "${_cae_rhs}")
        set(${_cae_return} 1 PARENT_SCOPE)
    else()
        set(${_cae_return} 0 PARENT_SCOPE)
    endif()
endfunction()
