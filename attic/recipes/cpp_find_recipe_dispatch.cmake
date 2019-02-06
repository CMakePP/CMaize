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
include(recipes/cpp_find_from_module)
include(recipes/cpp_find_from_config)

## Function which starts the find process
#
# At the moment we only support two mechanisms for finding a dependency: using a
# CMake find module or by using config files. The config file variant is the
# preferred mechanism; however, it is not a viable path for projects that do not
# use CMake. This function is responsible for dispatching to the appropriate
# handler.
#
# :param name: The name of the dependency we are attempting to find.
# :param version: The minimum required version of the dependency.
# :param comps: A list of required components.
# :param path: A hint for where to look.
# :param optional: Set to true if failing to find the package is an error.
# :param module: The CMake find module to use. Set to empty string if you want
#     CPP to try to find the dependency using config files.
#
# :CMake Variables:
#
#     * *CMAKE_PREFIX_PATH* - Used to provide ``find_package`` a list of end-
#       user provided paths.
function(_cpp_find_recipe_dispatch _cfrd_found _cfrd_name _cfrd_version
                                   _cfrd_comps _cfrd_path _cfrd_module)
    _cpp_is_not_empty(_cfrd_have_module _cfrd_module)
    if(_cfrd_have_module)
        _cpp_find_from_module(
            _cfrd_was_found
            ${_cfrd_name}
            "${_cfrd_version}"
            "${_cfrd_comps}"
            "${_cfrd_path}"
            "${_cfrd_module}"
        )
    else()
        _cpp_find_from_config(
            _cfrd_was_found
            ${_cfrd_name}
            "${_cfrd_version}"
            "${_cfrd_comps}"
            "${_cfrd_path}"
        )
    endif()
    set(${_cfrd_found} ${_cfrd_was_found} PARENT_SCOPE)
endfunction()
