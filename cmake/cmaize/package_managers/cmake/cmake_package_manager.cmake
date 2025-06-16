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

include(cmaize/package_managers/package_manager)
include(cmaize/package_managers/get_package_manager)
include(cmaize/package_managers/cmake/dependency/dependency)
include(cmaize/package_managers/cmake/impl_/impl_)
include(cmaize/project/package_specification)
include(cmaize/targets/cmaize_target)
include(cmaize/utilities/fetch_and_available)
include(cmaize/utilities/generated_by_cmaize)

include(CMakePackageConfigHelpers)

#[[[
# CMake package manager going through ``find_package`` and ``FetchContent``.
#]]
cpp_class(CMakePackageManager PackageManager)

    #[[[
    # :type: cpp_map[desc, Dependency]
    #
    # Search paths for ``find_package``. Default paths are used if this
    # is empty.
    #]]
    cpp_attr(CMakePackageManager dependencies)

    #[[[
    # :type: List[path]
    #
    # Search paths for ``find_package``. Default paths are used if this
    # is empty.
    #]]
    cpp_attr(CMakePackageManager search_paths)

    #[[[
    # :type: path
    #
    # Prefix for libraries. Will default to ``lib`` if no language is specified
    # otherwise the value will be obtained from GNUInstallDirs.
    #]]
    cpp_attr(CMakePackageManager library_prefix)

    #[[[
    # :type: path
    #
    # Prefix for executables. Will default to ``bin`` if no language is
    # specified otherwise the value will be otbtained from GNUInstallDirs.
    #]]
    cpp_attr(CMakePackageManager binary_prefix)

    #[[[
    # Default constructor of CMakePackageManager.
    #
    # :param self: The constructed object.
    # :type self: CMakePackageManager
    #]]
    cpp_constructor(CTOR CMakePackageManager)
    function("${CTOR}" self)
        _cpm_ctor_impl("${self}")
    endfunction()

    #[[[
    # Adds new search paths for the package manager.
    #
    # These paths are stored in the ``search_paths`` attribute. Duplicate
    # paths will be ignored.
    #
    # :param *args: Path or paths to add to the search path.
    # :type *args: path or List[path]
    #]]
    cpp_member(add_paths CMakePackageManager args)
    function("${add_paths}" self)

        CMakePackageManager(GET "${self}" _ap_search_paths search_paths)

        foreach(_ap_path_i ${ARGN})

            list(FIND _ap_search_paths "${_ap_path_i}" found_result)

            # Only add the new path to the search path list if it does not
            # already exist in the search path
            if (found_result EQUAL -1)
                list(APPEND _ap_search_paths "${_ap_path_i}")
            endif()
        endforeach()

        CMakePackageManager(SET "${self}" search_paths "${_ap_search_paths}")

    endfunction()

    #[[[
    # Register the dependency with the package manager. This does not search
    # for or build the dependency, but makes it known to the package manager
    # for future searching and building.
    #
    # :param _rd_result: Returned dependency.
    # :type _rd_result: Dependency*
    # :param _rd_name: Name of the dependency.
    # :type _rd_name: desc
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :returns: Dependency object created and initialized.
    # :rtype: Dependency
    #]]
    cpp_member(register_dependency
        CMakePackageManager desc PackageSpecification args
    )
    function("${register_dependency}" self _rd_result _rd_proj_specs)

        PackageSpecification(GET "${_rd_proj_specs}" _rd_pkg_name name)
        PackageSpecification(GET "${_rd_proj_specs}" _rd_pkg_version version)

        CMakePackageManager(GET "${self}" _rd_dependencies dependencies)
        cpp_map(GET "${_rd_dependencies}" _rd_depend "${_rd_pkg_name}")
        cpp_map(KEYS "${_rd_dependencies}" _rd_keys)
        foreach(_rd_key ${_rd_keys})
            cpp_map(GET "${_rd_dependencies}" _rd_temp "${_rd_key}")
        endforeach()

        if("${_rd_depend}" STREQUAL "")
            message(DEBUG "Registering dependency to package manager: ${_rd_pkg_name}")

            set(_rd_depend "")
            if("${ARGN}" MATCHES "github")
                message("Creating a GitHub dependency")
                GitHubDependency(CTOR _rd_depend)
            else()
                message("Creating a Git dependency")
                GitDependency(CTOR _rd_depend)
            endif()

            Dependency(init "${_rd_depend}" NAME "${_rd_pkg_name}" ${ARGN})

            cpp_map(SET "${_rd_dependencies}" "${_rd_pkg_name}" "${_rd_depend}")
        endif()

        set("${_rd_result}" "${_rd_depend}")
        cpp_return("${_rd_result}")

    endfunction()

    #[[[
    # Finds an installed package.
    #
    # This function uses CMake's ``find_package`` in config mode to search for
    # the packages on your system.
    #
    # :param _fi_result: Return value for the installed target.
    # :type _fi_result: InstalledTarget*
    # :param _fi_package_specs: Specifications for the package to build.
    # :type _fi_package_specs: PackageSpecification
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **BUILD_TARGET** (*desc*) --
    #      Name of the target when it is being built.
    #    * **FIND_TARGET** (*desc*) --
    #      Name of the target when it is found with find_package.
    #
    # :returns: CMaizeTarget object representing the found dependency, or a blank
    #           string ("") if it was not found.
    # :rtype: InstalledTarget
    #]]
    cpp_member(find_installed
        CMakePackageManager desc PackageSpecification args
    )
    function("${find_installed}" self _fi_result _fi_package_specs)

        # set(_fi_one_value_args BUILD_TARGET FIND_TARGET NAME URL VERSION)
        set(_fi_one_value_args BUILD_TARGET FIND_TARGET)
        cmake_parse_arguments(
            _fi "" "${_fi_one_value_args}" "" ${ARGN}
        )

        PackageSpecification(GET "${_fi_package_specs}" _fi_pkg_name name)

        message("Looking for ${_fi_pkg_name}")

        CMakePackageManager(register_dependency
            "${self}"
            _fi_depend
            "${_fi_package_specs}"
            ${ARGN}
        )

        Dependency(find_dependency "${_fi_depend}" _fi_found)
        if(
            NOT "${_fi_found}" OR
            "${${_fi_pkg_name}_DIR}" STREQUAL "${_fi_pkg_name}_DIR-NOTFOUND"
        )
            cpp_return("")
        endif()

        # Make sure that FIND_TARGET is populated with a name
        if("${_fi_FIND_TARGET}" STREQUAL "")
            if("${_fi_BUILD_TARGET}" STREQUAL "")
                set(_fi_FIND_TARGET "${_fi_pkg_name}")
            else()
                set(_fi_FIND_TARGET "${_fi_BUILD_TARGET}")
            endif()
        endif()

        # Create an installed target
        set(_fi_depend_root_path "${${_fi_pkg_name}_DIR}")
        InstalledTarget(ctor
            _fi_tgt "${_fi_FIND_TARGET}" "${_fi_depend_root_path}"
        )

        set("${_fi_result}" "${_fi_tgt}")
        cpp_return("${_fi_result}")

    endfunction()

    #[[[
    # Get the requested package if it is installed. This is currently mostly
    # unimplemented and should not yet be used.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _gp_result: Resulting target object return variable
    # :type _gp_result: InstalledTarget*
    # :param _gp_proj_specs: Specifications for the package to build.
    # :type _gp_proj_specs: PackageSpecification
    #
    # :returns: Resulting target from the package manager
    # :rtype: InstalledTarget
    #]]
    cpp_member(get_package CMakePackageManager str PackageSpecification args)
    function("${get_package}" self _gp_result _gp_proj_specs)

        CMakePackageManager(register_dependency
            "${self}"
            _gp_depend
            "${_gp_proj_specs}"
            ${ARGN}
        )

        Dependency(BUILD_DEPENDENCY "${_gp_depend}")

        Dependency(GET "${_gp_depend}" _gp_find_target "find_target")
        Dependency(GET "${_gp_depend}" _gp_build_target "build_target")

        # Create a build target
        BuildTarget(CTOR "${_gp_result}" "${_gp_build_target}")

        # Alias the build target as the find_target to unify the API
        if(NOT TARGET "${_gp_find_target}")
            if(NOT "${_gp_find_target}" STREQUAL "${_gp_build_target}")
                add_library("${_gp_find_target}" ALIAS "${_gp_build_target}")
            endif()
        endif()

        cpp_return("${_gp_result}")

    endfunction()

    #[[[
    # Install a given target in the project.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _ip_target: CMaizeTarget to install
    # :type _ip_target: BuildTarget*
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :Keyword Arguments:
    #    * **NAMESPACE** (*desc*) --
    #      Namespace to prepend to the target name. Include the delimiter when
    #      providing a namespace (for example, give "MyNamespace::", not just
    #      "MyNamespace"). If no namespace is given, "${PROJECT_NAME}::" is
    #      used.
    #    * **VERSION** (*desc*) --
    #      Version of the package. This sets the VERSION and SOVERSION
    #      properties of the target to the full version and major version,
    #      respectively. Currently, only semantic versioning
    #      (https://semver.org) is supported. Defaults to the value of
    #      ``${PROJECT_VERSION}`` or "0.1.0" if PROJECT_VERSION is also emtpy.
    #]]
    cpp_member(install_package CMakePackageManager str args)
    function("${install_package}" self _ip_pkg_name)
        _cpm_install_package_impl("${self}" "${_ip_pkg_name}" ${ARGN})
    endfunction()

    #[[[
    # Generates a package config file for the provided package. This file
    # will also attempt to find dependencies for the package.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param __gpc_output_file: Identifying name of target to install.
    # :type __gpc_output_file: str
    # :param __gpc_pkg_name: Name of the package this Config file is for.
    # :type __gpc_pkg_name: str
    # :param *args: List of targets to include in this package. Only provide
    #               targets that are created by this project.
    # :type *args: List[target]
    #]]
    cpp_member(_generate_package_config CMakePackageManager desc str args)
    function("${_generate_package_config}" self __gpc_output_file __gpc_pkg_name)
        _cpm_generate_package_config_impl(
            "${self}" "${__gpc_output_file}" "${__gpc_pkg_name}" ${ARGN}
        )
    endfunction()

    #[[[
    # Generate a target config file for the given target at the provided
    # location.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param __gtc_target_name: Identifying name of target to install.
    # :type __gtc_target_name: str
    # :param __gtc_namespace: Namespace for the target.
    # :type __gtc_namespace: str
    # :param __gtc_config_file: Path to the config file.
    # :type __gtc_config_file: path
    # :param __gtc_install_dest: Path to the installation destination.
    # :type __gtc_install_dest: path
    #]]
    cpp_member(_generate_target_config
        CMakePackageManager BuildTarget str str path str
    )
    function("${_generate_target_config}"
        self
        __gtc_tgt_obj
        __gtc_target_name
        __gtc_namespace
        __gtc_config_file
        __gtc_install_dest
    )
        _cpm_generate_target_config_impl(
            "${self}"
            "${__gtc_tgt_obj}"
            "${__gtc_target_name}"
            "${__gtc_namespace}"
            "${__gtc_config_file}"
            "${__gtc_install_dest}"
        )
    endfunction()

cpp_end_class()

#[[[
# Registers a CMakePackageManager instance. This should only be called at the
# end of the file defining the PackageManager class.
#]]
function(_register_package_manager_cmake)

    CMakePackageManager(CTOR __package_manager)
    register_package_manager("cmake" "${__package_manager}")

endfunction()

_register_package_manager_cmake()
