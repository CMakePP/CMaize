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

## Class storing the information required to build a dependency
#
# :Members:
#
#     * name - The name of the dependency
#     * version - The version of the dependency
#     * src - The path to the root of the source tree.
#     * args - A list of build options
#
# :param handle: An identifier to store the resulting object's handle in.
# :param src: The path to the root of the source tree.
# :param args: A list of build options for the dependency.
function(_cpp_BuildRecipe_ctor _cBc_handle _cBc_name _cBc_version _cBc_src
                               _cBc_toolchain _cBc_args)
    _cpp_does_not_exist(_cBc_dne "${_cBc_src}")
    if(_cBc_dne)
        _cpp_error("The source directory: ${_cBc_src} does not exist.")
    endif()
    _cpp_Object_ctor(_cBc_temp)
    _cpp_Object_set_type(${_cBc_temp} BuildRecipe)
    _cpp_Object_add_members(${_cBc_temp} name version src args toolchain)
    foreach(_cBc_mem_i name version src toolchain args)
        _cpp_Object_set_value(
            ${_cBc_temp} ${_cBc_mem_i} "${_cBc_${_cBc_mem_i}}"
        )
    endforeach()
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
