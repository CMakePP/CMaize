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
include(logic/has_property)
include(logic/negate)

## Determines if a target has a property set to a non-empty value
#
# This function works by negating :ref:`cpp_has_property-label`.
#
# :param return: The identifier to hold the returned value.
# :param target: The target we are checking.
# :param member: The member we are looking for
function(_cpp_does_not_have_property _cdnhp_return _cdnhp_target _cdnhp_member)
    _cpp_has(_cdnhp_temp "${_cdnhp_target}" "${_cdnhp_member}")
    _cpp_negate(_cdnhp_temp ${_cdnhp_temp})
    set(${_cdnhp_return} ${_cdnhp_temp} PARENT_SCOPE)
endfunction()
