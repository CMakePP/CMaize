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
include(logic/is_empty)
include(logic/negate)
include(utility/set_return)

## This function determines if a variable is set to a non-empty value
#
# This function simply negates :ref:`cpp_is_empty-label`.
#
# :param return: An identifier to hold the result.
# :param input: The identifier to check.
function(_cpp_is_not_empty _cine_return _cine_input)
    _cpp_is_empty(_cine_temp "${_cine_input}")
    _cpp_negate(_cine_temp "${_cine_temp}")
    _cpp_set_return(${_cine_return} ${_cine_temp})
endfunction()
