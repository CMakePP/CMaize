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

macro(_cpp_find_from_config _cffc_name _cffc_version _cffc_comps _cffc_path)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
    _cpp_sanitize_version(_cffc_temp "${_cffc_version}")
    _cpp_debug_print(
        "Attempting to find ${_cffc_name} version ${_cffc_temp} via config."
    )
    _cpp_debug_print("CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH}")
    _cpp_debug_print("Additional search path: ${_cffc_path}")
    find_package(
        ${_cffc_name}
        ${_cffc_temp}
        ${_cffc_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
endmacro()
