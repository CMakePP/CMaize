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

## Determines if the input is a target
#
# This function wraps CMake's mechanism for branching based on whether or not
# the string maps to a registered target.
#
# :param return: Identifier to hold whether or not the input is a valid target
# :param target: The string to test for target-ness
function(_cpp_is_target _cit_return _cit_target)
    if(TARGET "${_cit_target}")
        set(${_cit_return} 1 PARENT_SCOPE)
    else()
        set(${_cit_return} 0 PARENT_SCOPE)
    endif()
endfunction()
