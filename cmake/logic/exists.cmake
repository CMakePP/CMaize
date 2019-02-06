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
include(utility/set_return)

## Determines if a provided path points to a valid file or directory
#
# Given a filesystem path this function will return true if that path is a valid
# path for a file or a directory. It will return false otherwise.
#
# :param return: An identifier to hold the returned value.
function(_cpp_exists _ce_return _ce_path)
    if(EXISTS ${_ce_path})
        _cpp_set_return(${_ce_return} 1)
    else()
        _cpp_set_return(${_ce_return} 0)
    endif()
endfunction()
