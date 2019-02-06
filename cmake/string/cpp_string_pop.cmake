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
include(string/cpp_string_peek)

## Takes the first character off of a string and returns it.
#
# This function is particularly useful for when you are manually parsing a
# string character by character. This function will copy the first character
# from the string into the return and then advance the string one character
# (thinking of the string as a stream).
#
# :param return: An identifier to hold the first character of the string.
# :param str: An identifier whose value is a string. After the call the first
#             character will have been removed from str.
function(_cpp_string_pop _csp_return _csp_str)
    set(_csp_value "${${_csp_str}}")
    _cpp_is_empty(_csp_is_empty _csp_value)

    if(_csp_is_empty)
        set(${_csp_return} "" PARENT_SCOPE)
        return()
    endif()
    _cpp_string_peek(_csp_1st_char _csp_value)
    string(SUBSTRING "${_csp_value}" 1 -1 _csp_value)
    set(${_csp_return} "${_csp_1st_char}" PARENT_SCOPE)
    set(${_csp_str} "${_csp_value}" PARENT_SCOPE)
endfunction()
