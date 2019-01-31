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
include(utility/set_return)

## Checks for the helper target that will exist if dependency was already found
#
#  The helper target allows us to grab the FindRecipe object during
#  ``cpp_install``. This function wraps the logic required to see if it exists
#  so that other functions can remain decoupled from the target.
#
# :param return: An identifier to store the result of whether the target exists.
function(_cpp_helper_target_made _chtm_return _chtm_name)
    _cpp_is_target(_chtm_been_found _cpp_${_chtm_name}_helper)
    _cpp_set_return(${_chtm_return} ${_chtm_been_found})
endfunction()
