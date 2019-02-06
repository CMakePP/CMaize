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

include(logic/is_directory)
include(logic/negate)
include(utility/set_return)

## Determines if a path does not point to a directory
#
# This function simply negates :ref:`cpp_is_directory-label`.
#
# :param return: An identifier to hold the result.
# :param path: The path whose directoryless-ness is in question.
function(_cpp_is_not_directory _cind_return _cind_path)
    _cpp_is_directory(_cind_temp "${_cind_path}")
    _cpp_negate(_cind_temp "${_cind_temp}")
    _cpp_set_return(${_cind_return} ${_cind_temp})
endfunction()
