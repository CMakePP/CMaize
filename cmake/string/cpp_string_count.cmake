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

## Function for determining how many times a substring appears in a string.
#
# Given a string, this function will determine how many times a particular
# substring appears in that string. Since CMake values are intrinsically
# convertible to strings this function can also be used to determine how many
# times an element appears in a list.
#
# .. note::
#
#     This function does not limit its search to whole words. That is to say, if
#     you search for a string "XXX" then it will return 1 for the string
#     "FindXXX.cmake".
#
# :param return: The identifier this function should assign the result to.
# :param substr: The substring to search for.
# :param str: The string to search in.
function(_cpp_string_count _csc_return _csc_substr _csc_str)
    string(REGEX MATCHALL "${_csc_substr}" _csc_matches "${_csc_str}")
    list(LENGTH _csc_matches _csc_length)
    set(${_csc_return} ${_csc_length} PARENT_SCOPE)
endfunction()
