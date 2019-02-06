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
include(logic/exists)
include(logic/negate)
include(utility/set_return)

## Returns true if the provided path does not point to a file or directory
#
# This function simply negates :ref:`cpp_exists-label`.
#
# :param return: An identifier to hold the result.
# :param path: The path to check.
function(_cpp_does_not_exist _cdne_return _cdne_path)
    _cpp_exists(_cdne_temp "${_cdne_path}")
    _cpp_negate(_cdne_temp "${_cdne_temp}")
    _cpp_set_return(${_cdne_return} ${_cdne_temp})
endfunction()
