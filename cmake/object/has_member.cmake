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
include(object/mangle_member)

## Determines if an object has a particular member
#
# :param result: True if the object has the member and false otherwise
# :param handle: The object to search for the member
# :param member: The member to look for
#
function(_cpp_Object_has_member _cOhm_result _cOhm_handle _cOhm_member)
    _cpp_Object_get_members(_cOhm_members ${_cOhm_handle})
    list(FIND _cOhm_members ${_cOhm_member} _cOhm_position)
    _cpp_are_not_equal(_cOhm_present "${_cOhm_position}" "-1")
    set(${_cOhm_result} ${_cOhm_present} PARENT_SCOPE)
endfunction()
