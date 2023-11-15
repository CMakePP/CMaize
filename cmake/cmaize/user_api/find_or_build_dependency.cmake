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
include(cmaize/package_managers/package_managers)

#[[[
# Add a dependency to the project.
#
# .. warning::
# 
#    ``cpp_find_or_build_dependency()`` is depricated.
#    ``cmaize_find_or_build_dependency()`` should be used to add a dependency
#    to the project.
#
# :param _fobd_name: Name of the dependency.
# :type _fobd_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#]]
function(cpp_find_or_build_dependency _fobd_name)

    # Forward all arguments to the new API call
    cmaize_find_or_build_dependency("${_fobd_name}" ${ARGN})

endfunction()

#[[[
# Add a dependency to the project.
#
# TODO: Add more versioning options, such as an ``EXACT`` keyword to allow
#       the user to specify that only the given version should be found.
#       As it stands, it finds any version or the exact version if ``VERSION`` is given.
#       I propose providing the following options: 1) any available version if no version
#       keyword is given; 2) the provided version, or greater; or 3) the exact
#       version if both ``VERSION`` and ``EXACT`` are provided.
#
# :param _fobdc_name: Name of the dependency.
# :type _fobdc_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#
# :Keyword Arguments:
#    * **VERSION** (*desc*) --
#      Version of the package to find. Defaults to no version ("").
#    * **PACKAGE_MANAGER** (*desc*) --
#      Package manager to use. Must be a valid package listed in the
#      ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS`` variable. Defaults to "CMake".
#]]
function(cmaize_find_or_build_dependency _fobd_name)

    set(_fobd_one_value_args PACKAGE_MANAGER)
    cmake_parse_arguments(_fobd "" "${_fobd_one_value_args}" "" ${ARGN})

    # Default to CMake package manager if none were given
    if("${_fobd_PACKAGE_MANAGER}" STREQUAL "")
        set(_fobd_PACKAGE_MANAGER "CMake")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_fobd_PACKAGE_MANAGER}" _fobd_PACKAGE_MANAGER_lower)
    if("${_fobd_PACKAGE_MANAGER_lower}" STREQUAL "cmake")
        cmaize_find_or_build_dependency_cmake(
            "${_fobd_name}"
            ${ARGN}
        )
    elseif()
        set(msg "Invalid Package Manager: ${_fobd_PACKAGE_MANAGER}. See ")
        string(APPEND msg "CMAIZE_SUPPORTED_PACKAGE_MANAGERS for a list of")
        string(APPEND msg "supported package manager strings.")
        cpp_raise(
            InvalidPackageManager 
            "${msg}"
        )
    endif()

endfunction()

#[[[
# User function to find an installed package or fetch and build the package
# using CMake as the package management system.
#
# This means that tools such as ``find_package`` and ``FetchContent`` built
# into CMake will be used to manage packages while using this method.
#
# :param _fobdc_name: Name of the dependency to find or build.
# :type _fobdc_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#]]
function(cmaize_find_or_build_dependency_cmake _fobdc_name)

    set(_fobdc_one_value_args VERSION)
    cmake_parse_arguments(_fobdc "" "${_fobdc_one_value_args}" "" ${ARGN})

    cpp_get_global(_fobdc_project CMAIZE_TOP_PROJECT)

    # Create the package specification
    PackageSpecification(ctor _fobdc_package_specs)
    PackageSpecification(SET "${_fobdc_package_specs}" name "${_fobdc_name}")
    PackageSpecification(set_version "${_fobdc_package_specs}" "${_fobdc_VERSION}")

    # Add a CMakePackageManager to the project if it does not exist yet
    CMaizeProject(get_package_manager "${_fobdc_project}" _fobdc_pm "CMake")
    # TODO: This probably can be eliminated if CMaizeProject(get_package_manager
    # uses get_package_manager_instance under the hood
    if("${_fobdc_pm}" STREQUAL "")
        get_package_manager_instance(_fobdc_pm "CMake")
        CMaizeProject(add_package_manager "${_fobdc_project}" "${_fobdc_pm}")
    endif()

    message(STATUS "Attempting to find installed ${_fobdc_name}")

    # Check if the package is already installed
    CMakePackageManager(find_installed
        "${_fobdc_pm}"
        _fobdc_tgt
        "${_fobdc_package_specs}"
        ${ARGN}
    )
    if(NOT "${_fobdc_tgt}" STREQUAL "")
        message(STATUS "${_fobdc_name} installation found")
        CMaizeProject(add_target
            "${_fobdc_project}" "${_fobdc_name}" "${_fobdc_tgt}" INSTALLED
        )
        cpp_return("")
    endif()

    message(STATUS "Attempting to fetch and build ${_fobdc_name}")

    # Prepare to build the package
    CMakePackageManager(get_package
        "${_fobdc_pm}"
        _fobdc_tgt
        "${_fobdc_package_specs}"
        ${ARGN}
    )
    if(NOT "${_fobdc_tgt}" STREQUAL "")
        CMaizeProject(add_target
            "${_fobdc_project}" "${_fobdc_name}" "${_fobdc_tgt}"
        )
    endif()

    # The command above will throw build errors from inside FetchContent
    # if the fetch and build fails, so we can assume at this point that
    # it completed successfully
    message(STATUS "${_fobdc_name} build complete")

endfunction()
