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

include(build_recipe/ctor)
include(build_recipe/ctor_add_kwargs)
include(utility/set_return)

## Class responsible for building a dependency using a build module
#
# :param handle: An identifier whose value will be the returned object
# :param modlue: The path to the build module
# :param kwargs: A ``Kwargs`` instance with the input kwargs
function(_cpp_BuildWithModule_ctor _cBc_handle _cBc_module _cBc_kwargs)
    _cpp_BuildRecipe_ctor_add_kwargs(${_cBc_kwargs})
    _cpp_Kwargs_parse_argn(${_cBc_kwargs} ${ARGN})
    _cpp_does_not_exist(_cBc_dne "${_cBc_module}")
    if(_cBc_dne)
        _cpp_error("Build module: ${_cBc_module} does not exist.")
    endif()

    _cpp_BuildRecipe_ctor(_cBc_temp ${_cBc_kwargs})
    _cpp_Object_set_type(${_cBc_temp} BuildWithModule)
    _cpp_Object_add_members(${_cBc_temp} module_path)
    _cpp_Object_set_value(${_cBc_temp} module_path ${_cBc_module})
    _cpp_set_return(${_cBc_handle} ${_cBc_temp})
endfunction()
