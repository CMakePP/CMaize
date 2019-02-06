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
include(logic/are_equal)
include(utility/set_return)

## Splits a string on the provided substring
#
# This function works similar to the Python string member split. Basically,
# given a string, this function will return a list of substrings formed by
# breaking the input string on the provided delimiter. The delimiter is not
# included in the returned strings. This function will error if the substring is
# empty.
#
# :param return: An identifier to hold the returned list.
# :param str: The string to split.
# :param substr: The substring to split on.
#
# :Example Usage:
#
# .. code-block:: cmake
#
#     #Split the string "hello world" on the space character
#     _cpp_string_split(list "hello world" " ")
#     _cpp_assert_equal("${list}" "hello;world")
#
#     #Split on the "ll"
#     _cpp_string_split(list "hello world" "ll")
#     _cpp_assert_equal("${list}" "he;o world")
#
#     #Split on the "d"
#     _cpp_string_split(list "hello world" "d")
#     _cpp_assert_equal("${list}" "hello worl;") #Note the trailing ";"
#
function(_cpp_string_split _css_return _css_str _css_substr)
    _cpp_is_empty(_css_empty _css_substr)
    if(_css_empty)
        _cpp_error("The substring to split on can not be empty")
    endif()

    string(LENGTH "${_css_substr}" _css_substr_n)
    while(TRUE)
        string(FIND "${_css_str}" "${_css_substr}" _css_end)
        string(SUBSTRING "${_css_str}" 0 "${_css_end}" _css_elem)
        list(APPEND _css_rv "${_css_elem}")

        _cpp_are_equal(_css_done "${_css_end}" "-1")
        if(_css_done)
            break()
        endif()
        math(EXPR _css_start "${_css_end} + ${_css_substr_n}")
        string(SUBSTRING "${_css_str}" ${_css_start} -1 _css_str)
    endwhile()
    _cpp_set_return(${_css_return} "${_css_rv}")
endfunction()
