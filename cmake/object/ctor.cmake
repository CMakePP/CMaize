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
include(object/new_handle)
include(object/mangle_member)
include(object/add_members)
include(object/set_type)

## Constructor for the Object base class common to all objects
#
#  The Object class gives each object some bare bones intraspection members.
#  These members include:
#
#  * _cpp_member_list     - A list of all members added after the Object base class.
#  * _cpp_member_fxn_list - List of all member functions
#  * _cpp_type            - The class hierachy going from Object to most derived.
#
#  :param result: The handle to the newly created object
#
# .. warning::
#
#     This class is the base class of every class and can not use any of those
#     classes in its ctor or else infinite recursion will occur. The result is
#     that member functions of this class require special dispatch.
function(_cpp_Object_ctor _cOc_handle)
    _cpp_Object_new_handle(_cOc_temp)

    #We need to manually add the member list b/c add_member assumes it exists
    _cpp_Object_mangle_member(_cOc_member _cpp_member_list)
    set_target_properties(${_cOc_temp} PROPERTIES ${_cOc_member} "")

    #Can add the remaining members in the usual way
    _cpp_Object_add_members(${_cOc_temp} _cpp_type _cpp_member_fxn_list)

    _cpp_Object_set_type(${_cOc_temp} Object)

    set(${_cOc_handle} ${_cOc_temp} PARENT_SCOPE)
endfunction()
