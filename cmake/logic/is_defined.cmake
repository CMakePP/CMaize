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

## Determines if the supplied identifier is defined.
#
# In CMake an identifier can be defined or not defined. More specifically, an
# identifier is defined if it is set to some value, including the empty string.
#
# :param return: An identifier to assign the result to.
# :param input: The identifier to check for defined-ness.
function(_cpp_is_defined _cid_return _cid_input)
    if(DEFINED ${_cid_input})
        set(${_cid_return} 1 PARENT_SCOPE)
    else()
        set(${_cid_return} 0 PARENT_SCOPE)
    endif()
endfunction()
