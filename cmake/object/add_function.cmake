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
include(function/ctor)
include(object/impl/mangle_function_name)
include(object/add_members)
include(object/get_type)
include(object/has_member)
include(object/set_value)

## Adds a member function to a class.
#
# To store a member function we use double dispatch. First we store the mangled
# name without the type. The value of this member is a list of mangled names
# that implement/override the function. Then for each of these mangled names we
# create a new ``Function`` instance and save it under the mangled name.
#
# :param handle: The handle of the object we are adding the function to.
# :param name: The name of the function.
# :param path: The path to the implementation of the function
function(_cpp_Object_add_function _cOaf_handle _cOaf_name _cOaf_path)
    #---------------------------------------------------------------------------
    #----------------------------Error Checking---------------------------------
    #---------------------------------------------------------------------------
    _cpp_is_empty(_cOaf_empty _cOaf_name)
    if(_cOaf_empty)
        _cpp_error("Name shouldn't be empty")
    endif()
    _cpp_is_empty(_cOaf_empty _cOaf_path)
    if(_cOaf_empty)
        _cpp_error("Path shouldn't be empty")
    endif()
    _cpp_does_not_exist(_cOaf_dne ${_cOaf_path})
    if(_cOaf_dne)
        _cpp_error("Path ${_cOaf_path} does not exist")
    endif()
    _cpp_Object_get_type(${_cOaf_handle} _cOaf_type)
    _cpp_mangle_function_name(_cOaf_mn ${_cOaf_type} ${_cOaf_name})
    _cpp_Object_has_member(${_cOaf_handle} _cOaf_has_overload ${_cOaf_mn})
    if(_cOaf_has_overload)
        _cpp_error("Overload already exists")
    endif()

    #---------------------------------------------------------------------------
    #--------------------Make/Update the V-table--------------------------------
    #---------------------------------------------------------------------------
    _cpp_mangle_function_name(_cOaf_base "" ${_cOaf_name})
    _cpp_Object_has_member(${_cOaf_handle} _cOaf_has_fxn ${_cOaf_base})
    if(_cOaf_has_fxn)
        _cpp_Object_get_value(${_cOaf_handle} _cOaf_list ${_cOaf_base})
        list(APPEND _cOaf_list ${_cOaf_mn})
        _cpp_Object_set_value(${_cOaf_handle} ${_cOaf_base} "${_cOaf_list}")
    else()
        _cpp_Object_add_members(${_cOaf_handle} ${_cOaf_base})
        _cpp_Object_set_value(${_cOaf_handle} ${_cOaf_base} ${_cOaf_mn})
        _cpp_Object_get_value(${_cOaf_handle} _cOaf_list _cpp_member_fxn_list)
        list(APPEND ${_cOaf_list} ${_cOaf_name})
        _cpp_Object_set_value(
            ${_cOaf_handle} _cpp_member_fxn_list "${_cOaf_list}"
        )
    endif()

    #---------------------------------------------------------------------------
    #---------------------Make the new function---------------------------------
    #---------------------------------------------------------------------------
    _cpp_Object_add_members(${_cOaf_handle} ${_cOaf_mn})
    _cpp_Function_ctor(_cOaf_fxn ${_cOaf_path} THIS ${_cOaf_handle} ${ARGN})
    _cpp_Object_set_value(${_cOaf_handle} ${_cOaf_mn} ${_cOaf_fxn})
endfunction()
