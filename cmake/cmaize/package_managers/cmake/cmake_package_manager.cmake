include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/package_managers/package_manager)
include(cmaize/package_managers/cmake/dependency/dependency)
include(cmaize/project/project_specification)
include(cmaize/targets/cmaize_target)
include(cmaize/utilities/fetch_and_available)


include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

#[[[
# CMake package manager going through ``find_package`` and ``FetchContent``.
#]]
cpp_class(CMakePackageManager PackageManager)

    #[[[
    # :type: List[path]
    #
    # Search paths for ``find_package``. Default paths are used if this
    # is empty.
    #]]
    cpp_attr(CMakePackageManager search_paths)

    #[[[
    # Default constructor of CMakePackageManager.
    #
    # :param self: The constructed object.
    # :type self: CMakePackageManager
    #]]
    cpp_constructor(CTOR CMakePackageManager)
    function("${CTOR}" self)

        PackageManager(SET "${self}" type "CMake")

        CMakePackageManager(add_paths "${self}" ${CMAKE_PREFIX_PATH})

        # TODO: Add paths from Dependency(_search_paths if there are any
        #       generalizable ones

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
        CMakePackageManager desc ProjectSpecification args
    )
    function("${register_dependency}" self _rd_result _rd_proj_specs)

        ProjectSpecification(GET "${_rd_proj_specs}" _rd_pkg_name name)
        ProjectSpecification(GET "${_rd_proj_specs}" _rd_pkg_version version)

        # TODO: Move this to a local variable in the package manager
        cpp_get_global(_rd_depend "__CMAIZE_DEPENDENCY_${_rd_pkg_name}__")
        if("${_rd_depend}" STREQUAL "")
            # TODO: Actually make sure it's from GitHub
            GitHubDependency(CTOR _rd_depend)

            Dependency(INIT "${_rd_depend}"
                NAME "${_rd_pkg_name}"
                ${ARGN}
            )
            cpp_set_global("__CMAIZE_DEPENDENCY_${_rd_pkg_name}__" "${_rd_depend}")
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
    # :param _fi_project_specs: Specifications for the package to build.
    # :type _fi_project_specs: ProjectSpecification
    # :param **kwargs: Additional keyword arguments may be necessary.
    #
    # :returns: CMaizeTarget object representing the found dependency, or a blank
    #           string ("") if it was not found.
    # :rtype: InstalledTarget
    #]]
    cpp_member(find_installed
        CMakePackageManager desc ProjectSpecification args
    )
    function("${find_installed}" self _fi_result _fi_project_specs)

        ProjectSpecification(GET "${_fi_project_specs}" _fi_pkg_name name)

        CMakePackageManager(register_dependency
            "${self}"
            _fi_depend
            "${_fi_project_specs}"
            ${ARGN}
        )

        Dependency(find_dependency "${_fi_depend}" _fi_found)
        if(NOT "${_fi_found}")
            cpp_return("")
        endif()

        # Create an installed target
        set(_fi_depend_root_path "${${_fi_pkg_name}_DIR}")
        InstalledTarget(ctor
            _fi_tgt "${_fi_pkg_name}" "${_fi_depend_root_path}"
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
    # :type _gp_proj_specs: ProjectSpecification
    #
    # :returns: Resulting target from the package manager
    # :rtype: InstalledTarget
    #]]
    cpp_member(get_package CMakePackageManager str ProjectSpecification args)
    function("${get_package}" self _gp_result _gp_proj_specs)

        CMakePackageManager(register_dependency
            "${self}"
            _gp_depend
            "${_gp_proj_specs}"
            ${ARGN}    
        )

        Dependency(BUILD_DEPENDENCY "${_gp_depend}")

        # Alias the build target as the find_target to unify the API
        Dependency(GET "${_gp_depend}" _gp_find_target "find_target")
        Dependency(GET "${_gp_depend}" _gp_build_target "build_target")
        if(NOT "${_gp_find_target}" STREQUAL "${_gp_build_target}")
            if(TARGET "${_gp_find_target}")
                return()
            endif()
            add_library("${_gp_find_target}" ALIAS "${_gp_build_target}")
        endif()

        # Create a build target
        BuildTarget(CTOR "${_gp_result}" "${_gp_find_target}")

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
        
        # Get the current CMaize project
        cpp_get_global(_ip_proj CMAIZE_PROJECT_${PROJECT_NAME})

        set(_ip_one_value_args NAMESPACE VERSION)
        set(_ip_multi_value_args TARGETS)
        cmake_parse_arguments(
            _ip "" "${_ip_one_value_args}" "${_ip_multi_value_args}" ${ARGN}
        )

        # Default to the only target exported in the package being one of the
        # same name as the package
        list(LENGTH _ip_TARGETS _ip_TARGETS_len)
        if(_ip_TARGETS_len LESS_EQUAL 0)
            set(_ip_TARGETS "${_ip_pkg_name}")
        endif()

        # Default to the namespace being the same as the package name if
        # nothing else is given
        if("${_ip_NAMESPACE}" STREQUAL "")
            set(_ip_NAMESPACE "${_ip_pkg_name}::")
        endif()

        # Default to the project version if no explicit version is given,
        # or 0.1.0 if no project version is given
        if("${_ip_VERSION}" STREQUAL "")
            if(NOT "${PROJECT_VERSION}" STREQUAL "")
                set(_ip_VERSION ${PROJECT_VERSION})
            else()
                set(_ip_VERSION "0.1.0")
            endif()
        endif()

        # Set VERSION and SOVERSION properties on the targets
        foreach(_ip_TARGETS_i ${_ip_TARGETS})
            CMaizeProject(get_target
                "${_ip_proj}" _ip_tgt_obj_i "${_ip_TARGETS_i}"
            )

            # Set package version
            CMaizeTarget(set_property "${_ip_tgt_obj_i}" VERSION "${_ip_VERSION}")

            cmaize_split_version(
                _ip_major _ip_minor _ip_patch _ip_tweak "${_ip_VERSION}"
            )
            CMaizeTarget(set_property "${_ip_tgt_obj_i}" SOVERSION "${_ip_major}")
        endforeach()

        # Generate individual <target>Config.cmake components for
        # find_package(package COMPONENT target)
        foreach(_ip_TARGETS_i ${_ip_TARGETS})
            CMaizeProject(get_target "${_ip_proj}" _ip_tgt_obj_i "${_ip_TARGETS_i}")

            # doesn't work; "install TARGETS given target "utilities_target" which does not exist."
            # if("${_ip_pkg_name}" STREQUAL "${_ip_TARGETS_i}")
            #     set(_ip_TARGETS_i "${_ip_TARGETS_i}_target")
            # endif()

            install(
                TARGETS "${_ip_TARGETS_i}"
                EXPORT "${_ip_TARGETS_i}-target"
                RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}/${_ip_pkg_name}"
                LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}"
                ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}"
                # PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${_ip_pkg_name}"
            )
            install(
                EXPORT ${_ip_TARGETS_i}-target
                FILE ${_ip_TARGETS_i}-target.cmake
                DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
                NAMESPACE "${_ip_NAMESPACE}"
                COMPONENT ${_ip_TARGETS_i}-target
            )

            # Install the include directories, preserving the directory structure
            BuildTarget(GET "${_ip_tgt_obj_i}" _ip_inc_dir_list include_dirs)
            foreach(_ip_inc_dir_i ${_ip_inc_dir_list})
                install(
                    DIRECTORY "${_ip_inc_dir_i}"
                    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
                    USE_SOURCE_PERMISSIONS
                )
            endforeach()
        endforeach()

        # Writes config file to build directory
        message("-- DEBUG: _ip_TARGETS: ${_ip_TARGETS}")
        CMakePackageManager(_generate_package_config
            "${self}" _ip_pkg_config_in "${_ip_pkg_name}" ${_ip_TARGETS}
        )

        # Install config file
        configure_package_config_file(
            "${_ip_pkg_config_in}"
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}Config.cmake"
            INSTALL_DESTINATION
                "${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
        )

        install(
            FILES "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}Config.cmake"
            DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
        )

    endfunction()

    cpp_member(_generate_package_config CMakePackageManager desc str args)
    function("${_generate_package_config}"
        self __gpc_output_file __gpc_pkg_name
    )

        set(__gpc_targets ${ARGN})

        # Start to generate full list of components if no specific components
        # are given
        set(_gpc_file_contents "")
        string(APPEND
            _gpc_file_contents
            "list(LENGTH @PROJECT_NAME@_FIND_COMPONENTS " 
            "@PROJECT_NAME@_FIND_COMPONENTS_len)\n"
            "if(@PROJECT_NAME@_FIND_COMPONENTS_len LESS_EQUAL 0)\n"
        )

        # Append all target names to the component list
        foreach(__gpc_targets_i ${__gpc_targets})
            # if("${__gpc_pkg_name}" STREQUAL "${__gpc_targets_i}")
            #     set(__gpc_targets_i "${__gpc_targets_i}_target")
            # endif()

            string(APPEND
                _gpc_file_contents
                "    list(APPEND @PROJECT_NAME@_FIND_COMPONENTS "
                "${__gpc_targets_i})\n"
            )
        endforeach()

        # End handling no components given
        string(APPEND _gpc_file_contents "endif()\n\n")

        # Write the loop that includes all specified components
        string(APPEND
            _gpc_file_contents
            "foreach(component \${@PROJECT_NAME@_FIND_COMPONENTS})\n"
            "    include(\${CMAKE_CURRENT_LIST_DIR}/\${component}-target.cmake)\n"
            "endforeach()\n"
        )

        # Write to a file to be configured
        file(WRITE
            "${CMAKE_CURRENT_BINARY_DIR}/${__gpc_pkg_name}Config.cmake.in"
            "${_gpc_file_contents}"
        )

        set(
            "${__gpc_output_file}"
            "${CMAKE_CURRENT_BINARY_DIR}/${__gpc_pkg_name}Config.cmake.in"
        )

        cpp_return("${__gpc_output_file}")

    endfunction()

    #[[[
    # Generate a package config file for the given target. This function
    # writes the package config file into the ``CMAKE_CURRENT_BINARY_DIR``.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param __gc_target: Targets to install.
    # :type __gc_target: list
    #]]
    cpp_member(_generate_target_config CMakePackageManager desc)
    function("${_generate_target_config}" self __gc_target_name)

        # Get the current CMaize project
        cpp_get_global(__gc_proj CMAIZE_PROJECT_${PROJECT_NAME})

        set(
            file_contents 
            "@PACKAGE_INIT@\n\ninclude(CMakeFindDependencyMacro)\n"
        )
        
        CMaizeProject(get_target
            "${__gc_proj}" __gc_tgt_obj "${__gc_targets_i}"
        )
        BuildTarget(GET "${__gc_tgt_obj}" __gc_dep_list depends)

        foreach(__gc_dep_i ${__gc_dep_list})
            CMaizeProject(get_target
                "${__gc_proj}" __gc_dep_obj "${__gc_dep_i}" ALL
            )
            CMaizeTarget(target "${__gc_dep_obj}" __gc_dep_name)
            
            if("${__gc_dep_name}" STREQUAL "${__gc_dep_i}")
                string(APPEND
                    file_contents "find_dependency(${__gc_dep_i})\n"
                )
            else()
                string(APPEND
                    file_contents
                    "find_dependency(${__gc_dep_i} COMPONENT ${__gc_dep_name})\n"
                )
            endif()
        endforeach()
        
        BuildTarget(target "${__gc_target}" __gc_tgt_name)
        string(APPEND
            file_contents
            "include(\${CMAKE_CURRENT_LIST_DIR}/${__gc_tgt_name}_targets.cmake)\n"
        )
        
        string(APPEND
            file_contents
            "check_required_components(${__gc_tgt_name})"
        )

        file(WRITE
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_tgt_name}Config.cmake.in"
            "${file_contents}"
        )

    endfunction()

cpp_end_class()
