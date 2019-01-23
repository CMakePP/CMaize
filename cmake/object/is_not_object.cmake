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
include(object/is_object)
include(logic/negate)

## Determines if the input is not a handle to a valid CPP object
#
# This function is implemented by negating :ref:`cpp_is_object-label`.
#
# :param return: The identifier to assign the result to.
# :param input: The thing to consider for being a handle to an object
function(_cpp_is_not_object _cino_return _cino_input)
    _cpp_is_object(_cino_temp "${_cino_input}")
    _cpp_negate(_cino_temp ${_cino_temp})
    set(${_cino_return} ${_cino_temp} PARENT_SCOPE)
endfunction()
