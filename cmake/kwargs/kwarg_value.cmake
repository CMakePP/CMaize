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
include(object/object)
include(utility/set_return)

## Wraps the name mangling of the kwarg keys
#
# :param handle: The handle to the Kwargs instance
# :param return: An identifier to store the results
# :param key: The key we want the value for.
function(_cpp_Kwargs_kwarg_value _cKkv_handle _cKkv_return _cKkv_key)
    _cpp_Object_get_value(${_cKkv_handle} _cKkv_temp kwargs_${_cKkv_key})
    _cpp_set_return(${_cKkv_return} "${_cKkv_temp}")
endfunction()
