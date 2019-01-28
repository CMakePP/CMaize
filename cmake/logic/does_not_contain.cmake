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
include(logic/contains)
include(logic/negate)
include(utility/set_return)

## Determines if a substring is not contained in a string.
#
# This function works by negating :ref:`cpp_has_contains-label`.
#
# :param return: The identifier to hold the returned value.
# :param substring: The string we are looking for.
# :param string: The string we are searching through.
function(_cpp_does_not_contain _cdnc_return _cdnc_substring _cdnc_string)
    _cpp_contains(_cdnc_temp "${_cdnc_substring}" "${_cdnc_string}")
    _cpp_negate(_cdnc_temp ${_cdnc_temp})
    _cpp_set_return(${_cdnc_return} ${_cdnc_temp})
endfunction()
