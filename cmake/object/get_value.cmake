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

## Reads the value of an instance's member
#
# :param value: An identifier to save the value to
# :param handle: The handle to the object we are reading
# :param member: The member whose value we are reading
function(_cpp_Object_get_value _cOgv_value _cOgv_handle _cOgv_member)
    _cpp_Object_has_member(_cOgv_present ${_cOgv_handle} ${_cOgv_member})
    if(NOT ${_cOgv_present})
        _cpp_error("Object has no member ${_cOgv_member}")
    endif()
    _cpp_Object_mangle_member(_cOgv_member_name ${_cOgv_member})
    get_target_property(_cOgv_temp ${_cOgv_handle} ${_cOgv_member_name})
    set(${_cOgv_value} ${_cOgv_temp} PARENT_SCOPE)
endfunction()
