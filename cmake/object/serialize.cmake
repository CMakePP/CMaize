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
include(object/get_type)
include(object/get_members)
include(object/get_value)

## Serializes an object
#
# The current function will return a string that contains a JSON representation
# of the object.
#
# :param result: A string containing a JSON representation of the object
# :param handle: The object to serialize
function(_cpp_Object_serialize _cOs_result _cOs_handle)
    _cpp_Object_get_type(_cOs_type ${_cOs_handle})
    set(_cOs_str "{ \"_CPP_TYPE\" : \"${_cOs_type}\"")
    _cpp_Object_get_members(_cOs_members ${_cOs_handle})
    set(_cOs_not_itr1 FALSE)
    set(_cOs_mem_names "")
    set(_cOs_mem_vals "")
    foreach(_cOs_member_i ${_cOs_members})
        if(_cOs_not_itr1) #Only prefix with commas after first iteration
            set(_cOs_mem_names "${_cOs_mem_names} ,")
            set(_cOs_mem_vals  "${_cOs_mem_vals})
        endif()
        set(_cOs_mem_names "${_cOs_mem_names} \"${_cOs_member_i}\"")
        _cpp_Object_get_value(_cOs_val ${_cOs_handle} ${_cOs_member_i})
        set(
            _cOs_mem_vals
            "${_cOs_mem_vals} , \"${_cOs_member_i}\" : \"${_cOs_val}\""
        )
        set(_cOs_not_itr1 TRUE)
    endforeach()
    set(_cOs_str "${_cOs_str} , \"_CPP_MEMBERS\" : [${_cOs_mem_names} ]")
    set(_cOs_str "${_cOs_str} ,${_cOs_mem_vals} }")
    set(${_cOs_result} ${_cOs_str} PARENT_SCOPE)
endfunction()
