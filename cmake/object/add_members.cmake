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
include(object/get_members)
include(object/has_member)
include(object/mangle_member)

## Adds a list of members to an object
#
#  This function takes a handle to an object and arbitrary number of member
#  names (passed via ``ARGN``) and creates fields on the object for each of the
#  members.
#
# :param handle: The object to add the members to
#
function(_cpp_Object_add_members _cOam_handle)
    _cpp_Object_get_members(_cOam_members ${_cOam_handle})
    foreach(_cOam_member_i ${ARGN})
        _cpp_Object_has_member(_cOam_present ${_cOam_handle} ${_cOam_member_i})
        if(_cOam_present)
            _cpp_error(
                    "Failed to add member ${_cOam_member_i}. Already present."
            )
        endif()
        list(APPEND _cOam_members ${_cOam_member_i})
        _cpp_Object_mangle_member(_cOam_member_name "${_cOam_member_i}")
        set_target_properties(
            ${_cOam_handle}
            PROPERTIES _cpp_Object_member_list "${_cOam_members}"
        )
        set_target_properties(
                ${_cOam_handle} PROPERTIES ${_cOam_member_name} NULL
        )
    endforeach()
endfunction()
