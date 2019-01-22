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
include(serialization/serialize_string)
include(serialization/serialize_list)

## Dispatches to the appropriate serialization function
#
# This function dispatches
function(_cpp_serialize_value _csv_return _csv_value)
    _cpp_is_list(_csv_is_list "${_csv_value}")
    if(_csv_is_list)
        _cpp_serialize_list(_csv_val "${_csv_value}")
    else()
        _cpp_serialize_string(_csv_val "${_csv_value}")
    endif()
    set(${_csv_return} "${_csv_val}" PARENT_SCOPE)
endfunction()

