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
include(logic/negate)

## Determines if two values are not equal.
#
# This function works by negating :ref:`cpp_are_equal-label`.
#
# :param return: The identifier to hold the returned value.
# :param lhs: The thing on the left side of the ``!=`` operator
# :param rhs: The thing on the right side of the ``!=`` operator
function(_cpp_are_not_equal _cane_return _cane_lhs _cane_rhs)
    _cpp_are_equal(_cane_temp "${_cane_lhs}" "${_cane_rhs}")
    _cpp_negate(_cane_temp ${_cane_temp})
    set(${_cane_return} ${_cane_temp} PARENT_SCOPE)
endfunction()
