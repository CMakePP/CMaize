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

## Indicates whether a path points to a directory or not.
#
# This function will return true if the provided path points to a directory,
# otherwise it will return false.
#
# :param return: An identifier to hold the result.
# :param path: The path whose directory-ness is in question.
function(_cpp_is_directory _cid_return _cid_path)
    if(IS_DIRECTORY "${_cid_path}")
        _cpp_set_return(${_cid_return} 1)
    else()
        _cpp_set_return(${_cid_return} 0)
    endif()
endfunction()
