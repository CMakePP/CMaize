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
include(get_recipe/ctor)
include(utility/set_return)

## A GetRecipe capable of retreiving source code from disk
#
# This class extends the GetRecipe class by adding a member ``dir`` that stores
# the path to the source code.
#
# :param handle: An identifier to store the handle for the created object.
# :param path: The path to the source code
# :param name: The name of the dependency.
# :param version: The version of the source code the path points to.
function(_cpp_GetFromDisk_ctor _cGc_handle _cGc_path _cGc_name _cGc_version)
    _cpp_is_empty(_cGc_path_not_set _cGc_path)
    if(_cGc_path_not_set)
        _cpp_error("Path can not be empty.")
    endif()

    _cpp_GetRecipe_ctor(_cGc_temp "${_cGc_name}" "${_cGc_version}")
    _cpp_Object_set_type(${_cGc_temp} GetFromDisk)
    _cpp_Object_add_members(${_cGc_temp} dir)
    _cpp_Object_set_value(${_cGc_temp} dir "${_cGc_path}")
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
