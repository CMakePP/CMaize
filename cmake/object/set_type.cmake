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
include(object/get_value)
include(object/set_value)

## Sets the type of the object
#
# This function should only be called by constructors and only after
# initializing the base class. Failure to do so will result in incorrect class
# hierarchies. Once called the class will be registered as being of the
# specified type.
#
# :param handle: The handle to the object that we are setting the type of.
# :param type: The type
function(_cpp_Object_set_type _cOst_handle _cOst_type)
    _cpp_Object_get_value(${_cOst_handle} _cOst_base _cpp_type)
    list(APPEND _cOst_base "${_cOst_type}")
    _cpp_Object_set_value(${_cOst_handle} _cpp_type "${_cOst_base}")
endfunction()
