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
include(object/are_equal)
include(logic/negate)
include(utility/set_return)

## Determines if two objects are different
#
# This function simply negates :ref:`cpp_Object_are_equal-label`.
#
# :param lhs: The handle for the object that goes on the left of ``!=``
# :param return: An identifier to hold whether or not the two objects are
#                different
# :param rhs: The handle for the object that goes on the right of ``!=``
function(_cpp_Object_are_not_equal _cOane_lhs _cOane_return _cOane_rhs)
    _cpp_Object_are_equal("${_cOane_lhs}" _cOane_rv "${_cOane_rhs}")
    _cpp_negate(_cOane_rv "${_cOane_rv}")
    _cpp_set_return(${_cOane_return} ${_cOane_rv})
endfunction()
