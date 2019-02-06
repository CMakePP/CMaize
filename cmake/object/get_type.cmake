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

## Returns the most derived type of the object
#
# :param handle: The handle of the object we want the type of.
# :param return: An identifier to store the object's type in.
function(_cpp_Object_get_type _cOgt_handle _cOgt_return)
    _cpp_Object_get_value(${_cOgt_handle} _cOgt_temp _cpp_type)
    list(LENGTH _cOgt_temp _cOgt_length)
    math(EXPR _cOgt_i "${_cOgt_length} - 1")
    list(GET _cOgt_temp ${_cOgt_i} _cOgt_rv)
    _cpp_set_return(${_cOgt_return} ${_cOgt_rv})
endfunction()
