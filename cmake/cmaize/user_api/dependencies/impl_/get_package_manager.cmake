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

#[[[
# Wraps the process of retrieving a package manager from a project.
#
# At the moment it is somewhat non-trivial to go from a package maanger name,
# e.g., ``cmake`` or ``pip`` to an actual ``ProjectManager`` object which has
# been registered with a project. This function wraps that process.
#
# :param pm: The variable the package manager will be assigned to.
# :type pm: PackageManager*
# :param project: The project that the package manager will be registered with.
# :type project: CMaizeProject
# :param pm_name: The name of the package manager to retrieve.
# :type pm_name: desc
#
# :raises UNKNOWN_PM: When ``pm_name`` does not correspond to a known package
#     manager. Strong throw guarantee.
#
#]]
function(_fob_get_package_manager _gpm_pm _gpm_project _gpm_pm_name)

    if("${_gpm_pm_name}" STREQUAL "cmake")
        # Enabled by default, no enable function
    elseif("${_gpm_pm_name}" STREQUAL "pip")
        enable_pip_package_manager()
    else()
        cpp_raise(
            UNKNOWN_PM "Package manager ${_gpm_pm_name} was not registered."
        )
    endif()

    CMaizeProject(
        get_package_manager "${_gpm_project}" _gpm_pm_tmp "${_gpm_pm_name}"
    )

    # TODO: This probably can be eliminated if
    # CMaizeProject(get_package_manager uses get_package_manager_instance
    # under the hood
    if("${_gpm_pm_tmp}" STREQUAL "")
        get_package_manager_instance(_gpm_pm_tmp "${_gpm_pm_name}")
        CMaizeProject(add_package_manager "${_gpm_project}" "${_gpm_pm_tmp}")
    endif()

    set("${_gpm_pm}" "${_gpm_pm_tmp}" PARENT_SCOPE)

endfunction()
