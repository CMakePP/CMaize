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
include(find_recipe/factory_add_kwargs)
include(find_recipe/find_from_config/find_from_config)
include(find_recipe/find_from_module/find_from_module)
include(utility/set_return)

function(_cpp_FindRecipe_factory _cFf_handle _cFf_kwargs)
    _cpp_FindRecipe_factory_add_kwargs(${_cFf_kwargs})
    _cpp_Kwargs_parse_argn(${_cFf_kwargs} ${ARGN})
    _cpp_Kwargs_kwarg_value(${_cFf_kwargs} _cFf_find_module FIND_MODULE)

    _cpp_is_not_empty(_cFf_has_module _cFf_find_module)
    if(_cFf_has_module)
        _cpp_FindFromModule_ctor(_cFf_temp "${_cFf_find_module}" ${_cFf_kwargs})
    else()
        _cpp_FindFromConfig_ctor(_cFf_temp ${_cFf_kwargs})
    endif()
    _cpp_set_return(${_cFf_handle} ${_cFf_temp})
endfunction()
