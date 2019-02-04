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
include(find_recipe/find_from_config/ctor_add_kwargs)

## Class holding information for finding a dependency from a CMake config module
#
# Members:
# * config_path - The path to the directoy containing the config file.
#
# :param handle: The identifier that will contain the object.
# :param kwargs: A handle to the ``Kwargs`` instance
function(_cpp_FindFromConfig_ctor _cFc_handle _cFc_kwargs)
    _cpp_FindFromConfig_ctor_add_kwargs(${_cFc_kwargs})
    _cpp_Kwargs_parse_argn(${_cFc_kwargs} ${ARGN})
    _cpp_Kwargs_kwarg_value(${_cFc_kwargs} _cFc_name NAME)

    _cpp_FindRecipe_ctor(_cFc_temp ${_cFc_kwargs})
    _cpp_Object_set_type(${_cFc_temp} FindFromConfig)
    _cpp_Object_add_members(${_cFc_temp} config_path)

    #Look for xxx_DIR
    _cpp_string_cases(_cFc_cases "${_cFc_name}")
    foreach(_cFc_case_i ${_cFc_cases})
        _cpp_is_not_empty(_cFc_dir_set ${_cFc_case_i}_DIR)
        if(_cFc_dir_set)
            _cpp_Object_set_value(
                ${_cFc_temp} config_path ${${_cFc_case_i}_DIR}
            )
            break()
        endif()
    endforeach()

    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
