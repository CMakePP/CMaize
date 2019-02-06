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
include(object/has_member)
include(object/mangle_member)
include(utility/set_return)

## Reads the value of an object's member
#
# This function returns the value an object's member is currently set to. It
# will crash if the provdied handle is not a target or if the object does not
# possess the requested member.
#
# :param handle: The handle to the object we are reading
# :param value: An identifier to save the value to
# :param member: The member whose value we are reading
function(_cpp_Object_get_value _cOgv_handle _cOgv_value _cOgv_member)
    _cpp_Object_has_member(${_cOgv_handle} _cOgv_present ${_cOgv_member})
    if(NOT ${_cOgv_present})
        _cpp_error("Object has no member ${_cOgv_member}")
    endif()
    _cpp_Object_mangle_member(_cOgv_member_name ${_cOgv_member})
    get_target_property(_cOgv_temp ${_cOgv_handle} ${_cOgv_member_name})
    _cpp_set_return(${_cOgv_value} "${_cOgv_temp}")
endfunction()
