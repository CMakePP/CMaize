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
include(object/are_not_equal)
include(object/get_members)
include(object/get_value)
include(object/is_object)
include(utility/set_return)

## Determines if two objects have the same state.
#
# We define two CPP objects as equal if they have the same members and if each
# of those members is set to the same state.
#
# :param return: An identifier to hold whether or not the two objects are the
#                same.
# :param lhs: The handle for the object that goes on the left of ``==``
# :param rhs: The handle for the object that goes on the right of ``==``
function(_cpp_Object_are_equal _cOae_return _cOae_lhs _cOae_rhs)
    _cpp_Object_get_members(_cOae_lmembers ${_cOae_lhs})
    _cpp_Object_get_members(_cOae_rmembers ${_cOae_rhs})
    _cpp_are_not_equal(_cOae_diff "${_cOae_lmembers}" "${_cOae_rmembers}")
    if(_cOae_diff)
        _cpp_set_return(${_cOae_return} 0)
        return()
    endif()
    foreach(_cOae_member_i ${_cOae_lmembers})
        _cpp_Object_get_value(_cOae_lvalue ${_cOae_lhs} ${_cOae_member_i})
        _cpp_Object_get_value(_cOae_rvalue ${_cOae_rhs} ${_cOae_member_i})
        _cpp_is_object(_cOae_lobject "${_cOae_lvalue}")
        _cpp_is_object(_cOae_robject "${_cOae_rvalue}")
        _cpp_are_not_equal(
            _cOae_one_object "${_cOae_lobject}" "${_cOae_robject}"
        )
        if(_cOae_one_object)
            _cpp_set_return(${_cOae_return} 0)
            return()
        elseif(_cOae_lobject)
            _cpp_Object_are_not_equal(
                _cOae_diff "${_cOae_lvalue}" "${_cOae_rvalue}"
            )
        else()
            _cpp_are_not_equal(_cOae_diff "${_cOae_lvalue}" "${_cOae_rvalue}")
        endif()
        if(_cOae_diff)
            _cpp_set_return(${_cOae_return} 0)
            return()
        endif()
    endforeach()
    _cpp_set_return(${_cOae_return} 1)
endfunction()
