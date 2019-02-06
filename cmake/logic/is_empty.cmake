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

## Determines if an identifier is set to a value or not.
#
# An identifer is empty if its value is equal to the empty string. This can
# occur if:
#
# * the identifier is not defined
# * the identifier is defined, but not set
# * the identifier is defined and set to the empty string
#
# This function will return true if the identifier's value is the empty string
# and false otherwise.
#
# :param return: An identifier to hold the result.
# :param input: The identifier to check for emptyness
function(_cpp_is_empty _cie_return _cie_input)
    set(_cie_value "${${_cie_input}}")
    _cpp_are_equal(_cie_temp "${_cie_value}" "")
    _cpp_set_return(${_cie_return} ${_cie_temp})
endfunction()
