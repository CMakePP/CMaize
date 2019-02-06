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

## Sets the member of a class to a given value
#
# This function will set the specified member to the provided value. The
# function will error if the specified handle is not an object or if the object
# does not have the specified member.
#
# :param handle: The handle of the object to set
# :param member: The name of the member to set
# :param value: The value to set the member to
function(_cpp_Object_set_value _cOsv_handle _cOsv_member _cOsv_value)
    _cpp_Object_has_member(${_cOsv_handle} _cOsv_present ${_cOsv_member})
    if(NOT ${_cOsv_present})
        _cpp_error("Object has no member ${_cOsv_member}")
    endif()
    _cpp_Object_mangle_member(_cOsv_member_name ${_cOsv_member})
    set_target_properties(
            ${_cOsv_handle} PROPERTIES ${_cOsv_member_name} "${_cOsv_value}"
    )
endfunction()
