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
include(find_recipe/handle_found_var)
include(find_recipe/handle_target_vars)
include(find_recipe/find_from_config/handle_dir)

function(_cpp_FindFromConfig_find_dependency _cFfd_handle _cFfd_version
                                             _cFfd_comps _cFfd_paths)
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_name name)
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_dir config_path)
    _cpp_is_not_empty(_cFfd_has_dir _cFfd_dir)
    if(_cFfd_has_dir) #Prepend the dir so it gets used first
        set(CMAKE_PREFIX_PATH "${_cFfd_dir}" "${CMAKE_PREFIX_PATH}")
    endif()

        #CMake doesn't append the additional search path onto prefix path so
    #dependencies relying on prefix_path to find their dependencies won't find
    #them without this next line
    list(APPEND CMAKE_PREFIX_PATH ${_cFfd_paths})
    find_package(
        ${_cFfd_name}
        ${_cFfd_version}
        ${_cFfd_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
    _cpp_FindFromConfig_handle_dir(${_cFfd_handle})
    _cpp_FindRecipe_handle_found_var(${_cFfd_handle})
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_found found)
    message("${_cFfd_name}_FOUND: ${_cFfd_found}")
    if("${_cFfd_found}")
        _cpp_handle_target_vars(${_cFfd_name})
        _cpp_Object_set_value(${_cFfd_handle} paths "${CMAKE_PREFIX_PATH}")
    elseif(_cFfd_has_dir)
        _cpp_error("${_cFfd_name}_DIR was set to ${_cFfd_dir}, "
                   "but ${_CFfd_name} was not found.")
    endif()
endfunction()
