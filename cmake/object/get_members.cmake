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

## Returns the list of all members an object possess
#
# This function is largely intended for use by other Object functions. It is
# used to retrieve the names of an object's members. It does not retrieve those
# members' values. The resulting set of names is demangled so that they can be
# used through the public API of the object.
#
# :param result: The instance to hold the resulting list.
# :param handle: The object whose members we want.
#
function(_cpp_Object_get_members _cOgm_result _cOgm_handle)
    get_target_property(_cOgm_value ${_cOgm_handle} _cpp_Object_member_list)
    if("${_cOgm_value}" STREQUAL "_cOgm_value-NOTFOUND")
        set(${_cOgm_result} "" PARENT_SCOPE)
    else()
        set(${_cOgm_result} "${_cOgm_value}" PARENT_SCOPE)
    endif()
endfunction()
