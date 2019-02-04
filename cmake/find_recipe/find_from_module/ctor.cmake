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

include(find_recipe/ctor)
include(find_recipe/find_from_module/ctor_add_kwargs)
include(utility/set_return)

##
# :param handle: An identifier whose value will be the resulting object
# :param module: The path to the module file
# :param kwargs: A handle to the ``Kwargs`` object to use
function(_cpp_FindFromModule_ctor _cFc_handle _cFc_module _cFc_kwargs)
    _cpp_FindFromModule_ctor_add_kwargs(${_cFc_kwargs})
    _cpp_Kwargs_parse_argn(${_cFc_kwargs} ${ARGN})

    _cpp_is_empty(_cFc_module_not_set _cFc_module)
    if(_cFc_module_not_set)
        _cpp_error("Module path must be set.")
    endif()
    _cpp_FindRecipe_ctor(_cFc_temp ${_cFc_kwargs})
    _cpp_Object_set_type(${_cFc_temp} FindFromModule)
    _cpp_Object_add_members(${_cFc_temp} module_path)
    _cpp_Object_set_value(${_cFc_temp} module_path ${_cFc_module})
    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
