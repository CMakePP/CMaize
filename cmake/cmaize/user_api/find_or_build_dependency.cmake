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

    set(_fobd_one_value_args PACKAGE_MANAGER VERSION)
    cmake_parse_arguments(_fobd "" "${_fobd_one_value_args}" "" ${ARGN})

    cpp_get_global(_fobd_project CMAIZE_TOP_PROJECT)

    # Create the package specification
    PackageSpecification(ctor _fobd_package_specs)
    PackageSpecification(SET "${_fobd_package_specs}" name "${_fobd_name}")
    PackageSpecification(
        set_version "${_fobd_package_specs}" "${_fobd_VERSION}"
    )

    # Default to CMake package manager if none were given
    if("${_fobd_PACKAGE_MANAGER}" STREQUAL "")
        set(_fobd_PACKAGE_MANAGER "CMake")
        # Enabled by default, no enable function
    elseif("${_fobd_PACKAGE_MANAGER}" STREQUAL "CMake")
        # Enabled by default, no enable function
        set(foo "bar")
    elseif("${_fobd_PACKAGE_MANAGER}" STREQUAL "pip")
        enable_pip_package_manager()
    endif()

    CMaizeProject(get_package_manager
        "${_fobd_project}" _fobd_pm "${_fobd_PACKAGE_MANAGER}"
    )

    # TODO: This probably can be eliminated if
    # CMaizeProject(get_package_manager uses get_package_manager_instance
    # under the hood
    if("${_fobd_pm}" STREQUAL "")
        get_package_manager_instance(_fobd_pm "${_fobd_PACKAGE_MANAGER}")
        CMaizeProject(add_package_manager "${_fobd_project}" "${_fobd_pm}")
    endif()

    message(STATUS "Attempting to find installed ${_fobd_name}")

    # Check if the package is already installed
    PackageManager(find_installed
        "${_fobd_pm}" _fobd_tgt "${_fobd_package_specs}" ${ARGN}
    )
    if(NOT "${_fobd_tgt}" STREQUAL "")
        message(STATUS "${_fobd_name} installation found")
        CMaizeProject(add_target
            "${_fobd_project}" "${_fobd_name}" "${_fobd_tgt}" INSTALLED
        )
        cpp_return("")
    endif()

    message(STATUS "Attempting to fetch and build ${_fobd_name}")

    # TODO: CMakePackageManager needs refactored to match the others
    if("${_fobd_PACKAGE_MANAGER}" STREQUAL "CMake")
        PackageManager(get_package
            "${_fobd_pm}" _fobd_tgt "${_fobd_package_specs}" ${ARGN}
        )

        # This creates the suspected install prefix for this dependency
        cpp_get_global(_fobd_top_proj CMAIZE_TOP_PROJECT)
        CMaizeProject(GET "${_fobd_top_proj}" _fobd_top_proj_name name)
        file(REAL_PATH
            "${CMAKE_INSTALL_LIBDIR}/${_fobd_top_proj_name}/external"
            _fobd_external_prefix
            BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
        )

        # Get the build target name for the dependency, since it is not
        # necessarily the same as the name of the CMaize target
        CMaizeTarget(target "${_fobd_tgt}" _fobdc_build_tgt)

        # Create some possible paths where the dependency library will be
        # installed
        set(
            _fobd_install_paths
            "${_fobd_external_prefix}/lib"
            "${_fobd_external_prefix}/lib/${_fobd_name}"
            "${_fobd_external_prefix}/lib/${_fobd_build_tgt}"
        )
        list(REMOVE_DUPLICATES _fobd_install_paths)
        CMaizeTarget(SET "${_fobd_tgt}" install_path "${_fobd_install_paths}")

    else()
        PackageManager(install_package "${_fobd_pm}" "${_fobd_package_specs}")
        PackageManager(
            get_package "${_fobd_pm}" _fobd_tgt "${_fobd_package_specs}"
        )
    endif()

    # The command above will throw build errors from inside FetchContent
    # if the fetch and build fails, so we can assume at this point that
    # it completed successfully
    CMaizeProject(add_target
        "${_fobd_project}" "${_fobd_name}" "${_fobd_tgt}"
    )

    message(STATUS "${_fobd_name} build complete")

endfunction()
