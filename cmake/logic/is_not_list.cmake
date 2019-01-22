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
include(logic/is_list)
include(logic/negate)

## Determines whether the value held by and identifier is a list
#
# This function works by negating :ref:`cpp_is_list-label`.
#
# :param return: The identifier to hold the returned value.
# :param input: The identifier to check for list-ness
function(_cpp_is_not_list _cinl_return _cinl_input)
    _cpp_is_list(_cinl_temp "${_cinl_input}")
    _cpp_negate(_cinl_temp ${_cinl_temp})
    set(${_cinl_return} ${_cinl_temp} PARENT_SCOPE)
endfunction()
