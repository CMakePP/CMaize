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
include(object/is_not_object)
include(object/mangle_member)
include(utility/set_return)

## Returns the list of all members an object possess
#
# This function is largely intended for use by other Object functions. It is
# used to retrieve a list of an object's members. It does not retrieve those
# members' values. The resulting set of names is demangled so that they can be
# used through the public API of the object and will not include the internal
# members used by the Object class. This function will error if the provided
# handle is not a handle to a valid object.
#
# :param handle: The object whose members we want.
# :param result: The instance to hold the resulting list.
#
function(_cpp_Object_get_members _cOgm_handle _cOgm_result)
    _cpp_is_not_object(_cOgm_not_object ${_cOgm_handle})
    if(_cOgm_not_object)
        _cpp_error("${_cOgm_handle} is not a handle to an object")
    endif()
    #Is object so guaranteed to have a member list
    _cpp_Object_mangle_member(_cOgm_member _cpp_member_list)
    get_target_property(_cOgm_value ${_cOgm_handle} ${_cOgm_member})
    _cpp_set_return(${_cOgm_result} "${_cOgm_value}")
endfunction()
