# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/project/cmaize_project)
include(cmaize/package_managers/get_package_manager)

#[[[
# User function to install a package.
#
# :param _cap_tgt_name: Name of the target to be installed.
# :type _cap_tgt_name: desc
#
# :Keyword Arguments:
#    * **PACKAGE_MANAGER** (*desc*) --
#      Package manager to add the package to. A list of supported package
#      manager keywords can be found in ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS``.
#]]
function(cmaize_add_package _cap_tgt_name)

    message(VERBOSE "Registering install package: ${_cap_tgt_name}")

    set(_cap_one_value_args PACKAGE_MANAGER)
    cmake_parse_arguments(_cap "" "${_cap_one_value_args}" "" ${ARGN})

    if("${_cap_PACKAGE_MANAGER}" STREQUAL "")
        set(_cap_PACKAGE_MANAGER "cmake")
    endif()

    string(TOLOWER "${_cap_PACKAGE_MANAGER}" _cap_pm_lower)
    if("${_cap_pm_lower}" STREQUAL "cmake")
        cmaize_add_package_cmake("${_cap_tgt_name}" ${_cap_UNPARSED_ARGUMENTS})
    else()
        cpp_raise(
            InvalidPackageManager
            "Invalid package manager: ${_cap_PACKAGE_MANAGER}"
        )
    endif()

endfunction()

#[[[
# User function to install a CMake package.
#
# :param _capc_pkg_name: Name of the package to be installed.
# :type _capc_pkg_name: desc
#]]
function(cmaize_add_package_cmake _capc_pkg_name)

    # Get the CMaize project
    cpp_get_global(_capc_proj CMAIZE_TOP_PROJECT)

    # Get the correct package manager
    CMaizeProject(get_package_manager
        "${_capc_proj}" _capc_pm_obj "cmake"
    )

    # TODO: This probably can be eliminated if CMaizeProject(get_package_manager
    #       uses get_package_manager_instance under the hood
    # Create new package manager if it doesn't exist
    if("${_capc_pm_obj}" STREQUAL "")
        get_package_manager_instance(_capc_pm_obj "cmake")
        CMaizeProject(add_package_manager "${_capc_proj}" "${_capc_pm_obj}")
    endif()

    PackageManager(install_package
        "${_capc_pm_obj}"
        "${_capc_pkg_name}"
        ${ARGN}
    )

endfunction()

#[[[
# Get an existing package manager from the current project.
#
# :param _gpm_return_pm: Return variable for the package manager
# :type _gpm_return_pm: PackageManager*
# :param _gpm_name: Name of the type of package manager to use. Supported
#                   package manager names can be found in
#                   ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS``.
# :type _gpm_name: desc
#
# :returns: Package manager of the requested type. Will be empty if one
#           was not found.
# :rtype: PackageManager
#]]
# function(get_package_manager _gpm_return_pm _gpm_type)

#     # Get the list of package managers from the current project
#     cpp_get_global(_gpm_proj CMAIZE_PROJECT_${PROJECT_NAME})

#     # Search for the package manager in the project
#     CMaizeProject(GET "${_gpm_proj}" _gpm_pm_list package_managers)
#     set(_gpm_return_pm "")
#     foreach(_gpm_pm_i ${_gpm_pm_list})
#         PackageManager(GET "${_gpm_pm_i}" _gpm_pm_i_type type)

#         # If found, return the package manager
#         if("${_gpm_pm_i_type}" STREQUAL "${_gpm_type}")
#             set(_gpm_return_pm "${_gpm_pm_i}")
#             cpp_return("${_gpm_return_pm}")
#         endif()
#     endforeach()

#     set(_gpm_return_pm "")
#     cpp_return("${_gpm_return_pm}")

# endfunction()
