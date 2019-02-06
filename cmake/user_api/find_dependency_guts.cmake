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

include(find_recipe/find_recipe)
include(dependency/helper_target_made)
include(dependency/set_helper_target)
include(utility/set_return)
include(user_api/find_dependency_add_kwargs)

## The implementation of ``cpp_find_dependency``
#
# The API of the :ref:`cpp_find_dependency-label` function is designed to be 
# native CMake because it is user facing. However, we also want to be able to 
# pass a CPP ``Kwargs`` to it. Our solution is to wrap the guts of the function
# in an API that takes a ``Kwargs`` instance and have ``cpp_find_dependency``
# build the instance for the user.
#
# :param kwargs: The ``Kwargs`` instance to use.
function(_cpp_find_dependency_guts _cfdg_kwargs)
    _cpp_find_dependency_add_kwargs(${_cfdg_kwargs})
    _cpp_Kwargs_parse_argn(${_cfdg_kwargs} ${ARGN})
    _cpp_Kwargs_kwarg_value(${_cfdg_kwargs} _cfdg_paths PATHS)
    _cpp_Kwargs_kwarg_value(${_cfdg_kwargs} _cfdg_result RESULT)
    _cpp_Kwargs_kwarg_value(${_cfdg_kwargs} _cfdg_name NAME)
    _cpp_Kwargs_kwarg_value(${_cfdg_kwargs} _cfdg_optional OPTIONAL)


    _cpp_helper_target_made(_cfdg_been_found ${_cfdg_name})
    if(_cfdg_been_found)
        _cpp_set_return(${_cfdg_result} TRUE)
        return()
    endif()

    _cpp_FindRecipe_factory(_cfdg_find_recipe ${_cfdg_kwargs})
    _cpp_FindRecipe_find_dependency(${_cfdg_find_recipe} "${_cfdg_paths}")
    _cpp_Object_get_value(${_cfdg_find_recipe} _cfdg_found found)

    if("${_cfdg_found}")
        _cpp_set_helper_target(${_cfdg_name} ${_cfdg_find_recipe})
        _cpp_set_return(${_cfdg_result} TRUE)
        return()
    elseif("${_cfdg_optional}")
        _cpp_set_return(${_cfdg_result} FALSE)
        return()
    endif()

    _cpp_error(
            "Could not find ${_cfdg_name}. Make sure ${_cfdg_name}'s install path is "
            "either included in CMAKE_PREFIX_PATH or the value of "
            "${_cfdg_name}_ROOT. Current CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}."
    )
endfunction()
