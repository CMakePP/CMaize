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
include(logic/is_target)
include(logic/negate)

## Ensures an identifier is not currently assigned to a target
#
# This function works by negating :ref:`cpp_is_target-label`.
#
# :param return: The identifier to hold the returned value.
# :param target: The thing to check for target-ness
function(_cpp_is_not_target _cint_return _cint_target)
    _cpp_is_target(_cint_temp "${_cint_target}")
    _cpp_negate(_cint_temp ${_cint_temp})
    set(${_cint_return} ${_cint_temp} PARENT_SCOPE)
endfunction()
