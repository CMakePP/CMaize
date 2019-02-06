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

include(dependency/cpp_sanitize_version)
include(dependency/cpp_handle_find_module_vars)
include(recipes/cpp_handle_found_var)

## Function that attempts to locate a dependency using a CMake find module.
#
# This function wraps CMake's ``find_package`` function in "module" mode. This
# function is specifically designed so that CMake will use the provided find
# module and **NOT** any of the find modules CMake ships with. This is done by
# setting ``CMAKE_MODULE_PATH`` to the directory containing the find module and
# then relying on CMake to use modules found in that path first. We avoid using
# the find modules provided with CMake because, bluntly, they suck. If the
# package is found this function will create a target for it (the target's name
# will be the same as the package's name) if the find module does not do so.
# Finally, this function will return the result using the ``<name>_FOUND``
# variable, where ``<name>`` is the same as the input case.
#
# :param found: Set to True if the dependency was found and false otherwise.
# :param name: The name of the dependency we are attempting to locate.
# :param version: The minimum version of the dependency we are trying to find.
# :param comps: A list of the components the dependency must have.
# :param path: A hint for where ``find_package`` should look.
#
# :CMake Variables:
#
#     * *CMAKE_PREFIX_PATH* - Used to provide ``find_package`` a list of end-
#       user provided paths.
function(_cpp_find_from_module _cffm_found _cffm_name _cffm_version _cffm_comps
                               _cffm_path _cffm_module)
    _cpp_assert_exists(${_cffm_module})
    get_filename_component(_cffm_dir ${_cffm_module} DIRECTORY)
    list(APPEND CMAKE_MODULE_PATH ${_cffm_dir})
    list(APPEND CMAKE_PREFIX_PATH ${_cffm_path})
    _cpp_sanitize_version(_cffm_temp "${_ccfm_version}")
    find_package(${_cffm_name} ${_cffm_temp} ${_cffm_comps} MODULE QUIET)
    _cpp_handle_found_var(_cffm_was_found ${_cffm_name})
    if(_cffm_was_found)
        _cpp_handle_find_module_vars(${_cffm_name})
        set(_cffm_helper_target _cpp_${_cffm_name}_External)
        _cpp_is_target(_cffm_is_target ${_cffm_helper_target})
        if(_cffm_is_target)
            set_target_properties(
                ${_cffm_helper_target}
                PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                "${_cffm_name}_ROOT \"${CMAKE_PREFIX_PATH}\""
            )
        endif()
    endif()
    set(${_cffm_found} ${_cffm_was_found} PARENT_SCOPE)
endfunction()
