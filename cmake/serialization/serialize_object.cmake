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
include(serialization/serialize_value)
include(object/object)

## Serializes a CPP object into JSON format
#
# This function ultimately loops over every member of the object and then passes
# that element to :ref:`cpp_serialize_value-label`.
#
# :param return: An identifier to hold the returned object
# :param handle: A handle to an object
function(_cpp_serialize_object _cso_return _cso_handle)
    set(_cso_rv "{")
    set(_cso_not_1st FALSE)
    _cpp_Object_get_members(${_cso_handle} _cso_members)
    foreach(_cso_i ${_cso_members})
        if(_cso_not_1st)
            set(_cso_rv "${_cso_rv} ,")
        endif()
        _cpp_Object_get_value(${_cso_handle} _cso_value ${_cso_i})
        _cpp_serialize_value(_cso_str "${_cso_value}")
        set(_cso_rv "${_cso_rv} \"${_cso_i}\" : ${_cso_str}")
        set(_cso_not_1st TRUE)
    endforeach()
    set(${_cso_return} "${_cso_rv} }" PARENT_SCOPE)
endfunction()
