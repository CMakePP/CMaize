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

include(cmaize/user_api/dependencies/impl_/get_package_manager)
include(cmaize/user_api/dependencies/impl_/parse_arguments)
include(cmaize/package_managers/package_manager)

#[[[
# Factorization from cmaize_find_dependency and cmaize_find_or_build_dependency.
#
# The first part of both cmaize_find_dependency and
# cmaize_find_or_build_dependency is the same. This function factors that common
# code out into one function.
#
# :param tgt: The variable to hold the target that was found. Will be empty if
#    no target was found.
# :type tgt: CMaizeTarget*
# :param pm: The variable to hold the package manager we looked inside of.
# :type pm: PackageManager*
# :param package_specs: The variable to hold the package specification we looked
#    for.
# :type package_specs: PackageSpecification*
# :param project: The CMaize project this find operation is associated with.
# :type project: CMaizeProject
# :param name: The name of the dependency we are looking for.
# :type name: desc
# :param **kwargs: The arguments to forward to _fob_parse_arguments. See
#    _fob_parse_arguments documentation for more details.
#
# :raises UNKNOWN_PM: When ``pm_name`` does not correspond to a known package
#     manager. Strong throw guarantee.
#
#]]
function(_cmaize_find_dependency _fd_tgt _fd_pm _fd_package_specs _fd_project _fd_name)

    _fob_parse_arguments(
        _fd_package_specs_tmp _fd_pm_name "${_fd_name}" ${ARGN}
    )

    _fob_get_package_manager(_fd_pm_tmp "${_fd_project}" "${_fd_pm_name}")

    message(STATUS "Attempting to find installed ${_fd_name}")

    # Check if the package is already installed
    PackageManager(find_installed
        "${_fd_pm_tmp}" _fd_tgt_tmp "${_fd_package_specs_tmp}" ${ARGN}
    )

    if(NOT "${_fd_tgt_tmp}" STREQUAL "")
        message(STATUS "${_fd_name} installation found")
        CMaizeProject(add_target
            "${_fd_project}" "${_fd_name}" "${_fd_tgt_tmp}" INSTALLED
        )
        CMaizeProject(check_target "${_fd_project}" was_found "${_fd_name}" INSTALLED)
    endif()

    set("${_fd_tgt}" "${_fd_tgt_tmp}" PARENT_SCOPE)
    set("${_fd_pm}" "${_fd_pm_tmp}" PARENT_SCOPE)
    set("${_fd_package_specs}" "${_fd_package_specs_tmp}" PARENT_SCOPE)

endfunction()
