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

## Serializes a CMake list into JSON format
#
# This function ultimately loops over every element of the list and then passes
# that element to :ref:`cpp_serialize_value-label`.
#
# :param return: An identifier to hold the returned list
function(_cpp_serialize_list _csl_return _csl_value)
    set(_csl_list "[")
    set(_csl_not_1st FALSE)
    foreach(_csl_i ${_csl_value})
        if(_csl_not_1st)
            set(_csl_list "${_csl_list} ,")
        endif()
        _cpp_serialize_value(_csl_str "${_csl_i}")
        set(_csl_list "${_csl_list} ${_csl_str}")
        set(_csl_not_1st TRUE)
    endforeach()
    set(${_csl_return} "${_csl_list} ]" PARENT_SCOPE)
endfunction()
