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

## Determines if a substring appears in a particular string.
#
# :param return: True if the substring is present and false otherwise.
# :param substring: The substring we are looking for.
# :param string: The string we are searching for the substring in.
function(_cpp_contains _cc_return _cc_substring _cc_string)
    string(FIND "${_cc_string}" "${_cc_substring}" _cc_pos)
    if("${_cc_pos}" STREQUAL "-1")
        set(${_cc_return} 0 PARENT_SCOPE)
    else()
        set(${_cc_return} 1 PARENT_SCOPE)
    endif()
endfunction()
