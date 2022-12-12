include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/package_managers/package_manager)
include(cmaize/fetch/fetch_and_available)
include(cmaize/targets/target)
include(cmaize/project/project_specification)
include(cmaize/targets/target)

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

    endfunction()

    #[[[
    # Adds new search paths for the package manager.
    #
    # These paths are stored in the ``search_paths`` attribute. Duplicate
    # paths will be ignored.
    #
    # :param args: Paths to add to the search path.
    # :type args: path or List[path]
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
    # Checks if the package can be found on the system using CMake's
    # ``find_package``.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _hp_found: Return value for if the package was found.
    # :type _hp_found: bool*
    # :param _hp_project_specs: Specifications for the package to build.
    # :type _hp_project_specs: ProjectSpecification
    #
    # :returns: Whether the package was found (TRUE) or not (FALSE)
    # :rtype: bool
    #]]
    cpp_member(has_package CMakePackageManager desc ProjectSpecification)
    function("${has_package}" self _hp_found _hp_project_specs)

        ProjectSpecification(GET "${_hp_project_specs}" _hp_pkg_name name)
        ProjectSpecification(GET "${_hp_project_specs}" _hp_pkg_version version)

        # Check if the package was already found beforehand
        message("-- DEBUG: ${_hp_pkg_name}_FOUND: ${${_hp_pkg_name}_FOUND}")
        if (${_hp_pkg_name}_FOUND)
            message("-- DEBUG: Package already found, exitting early")
            set("${_hp_found}" "${${_hp_pkg_name}_FOUND}")
            cpp_return("${_hp_found}")
        endif()

        # Build the argument list for ``find_package()``
        list(APPEND _hp_arg_list "${_hp_pkg_name}")

        # Add version arguments
        if(NOT "${_hp_pkg_version}" STREQUAL "")
            list(APPEND _hp_arg_list "${_hp_pkg_version}")

            # Was an exact version specified? If so, find_package will
            # request an exact version. This is not always honored by the
            # package, though.
            string(FIND "${_hp_pkg_version}" "..." _hp_is_pkg_ver_range)
            if(NOT _hp_is_pkg_ver_range)
                list(APPEND _hp_arg_list "EXACT")
            endif()
        endif()

        CMakePackageManager(GET "${self}" _hp_search_paths search_paths)
        list(LENGTH _hp_search_paths _hp_search_paths_n)

        # If there are custom search paths, limit find_package to only those
        # search paths
        if(_hp_search_paths_n GREATER 0)
            list(APPEND _hp_arg_list "PATHS" "${_hp_search_paths}")
            
            # Disables the default paths so there are no surprises
            list(APPEND _hp_arg_list "NO_PACKAGE_ROOT_PATH")
            list(APPEND _hp_arg_list "NO_SYSTEM_ENVIRONMENT_PATH")
            list(APPEND _hp_arg_list "NO_CMAKE_PACKAGE_REGISTRY")
            list(APPEND _hp_arg_list "NO_CMAKE_SYSTEM_PATH")
            list(APPEND _hp_arg_list "NO_CMAKE_SYSTEM_PACKAGE_REGISTRY")
        endif()

        # Join the list with spaces so separate arguments are parsed properly
        list(JOIN _hp_arg_list " " _hp_args)
        message("-- DEBUG: arg_list: ${_hp_arg_list}")

        # Effectively ``find_package("${_hp_args}")``.
        # ``cmake_language(EVAL CODE`` allows ``${_hp_args}`` to be
        # expanded and used as separate arguments to ``find_package``,
        # instead of being parsed as a single, string argument
        cmake_language(EVAL CODE "find_package(${_hp_args})")

        # The bool result can be based on <PackageName>_FOUND result from
        # ``find_package``
        set(${_hp_pkg_name}_FOUND ${${_hp_pkg_name}_FOUND} PARENT_SCOPE)
        set("${_hp_found}" "${${_hp_pkg_name}_FOUND}")
        cpp_return("${_hp_found}")

    endfunction()

    #[[[
    # Get the requested package if it is installed. This is currently mostly
    # unimplemented and should not yet be used.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _gp_result_target: Resulting target object return variable
    # :type _gp_result_target: InstalledTarget*
    # :param _gp_proj_specs: Specifications for the package to build.
    # :type _gp_proj_specs: ProjectSpecification
    #
    # :returns: Resulting target from the package manager
    # :rtype: InstalledTarget
    #]]
    cpp_member(get_package CMakePackageManager str ProjectSpecification)
    function("${get_package}" self _gp_result_target _gp_proj_specs)

        # It's possible GitHub URLs link to an "asset" (i.e., a tarball)
        string(FIND "${_fp_url}" ".tgz" _fp_is_tarball)

        if("${_fp_is_tarball}" STREQUAL "-1")
            cmaize_fetch_and_available(
                "${_fp_name}"
                GIT_REPOSITORY "${_fp_url}"
                GIT_TAG "${_fp_version}"
            )
        else()
            cmaize_fetch_and_available("${_fp_name}" URL "${_fp_url}")
        endif()

        foreach(_fp_pair ${_fp_old_cmake_args})
            string(REPLACE "=" [[;]] _fp_split_pair "${_fp_pair}")
            list(GET _fp_split_pair 0 _fp_var)
            list(GET _fp_split_pair 1 _fp_val)
            set("${_fp_var}" "${_fp_val}" CACHE BOOL "" FORCE)
        endforeach()

    endfunction()

    #[[[
    # Install a given target in the project.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _ip_target: Target to install
    # :type _ip_target: BuildTarget*
    #
    # :Keyword Arguments:
    #    * **NAMESPACE** (*desc*) --
    #      Namespace to prepend to the target name. Include the delimiter when
    #      providing a namespace (for example, give "MyNamespace::", not just
    #      "MyNamespace"). If no namespace is given, "${PROJECT_NAME}::" is
    #      used.
    #]]
    cpp_member(install_package CMakePackageManager BuildTarget args)
    function("${install_package}" self _ip_target)

        set(_ip_options NAMESPACE)
        cmake_parse_arguments(_ip "" "${_ip_options}" "" ${ARGN})

        Target(target "${_ip_target}" _ip_tgt_name)

        if("${_ip_NAMESPACE}" STREQUAL "")
            set(_ip_NAMESPACE "${PROJECT_NAME}::")
        endif()

        # Generate <target>Config.cmake

        install(
            TARGETS "${_ip_tgt_name}"
            EXPORT "${_ip_tgt_name}_targets"
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}/${_ip_tgt_name}"
            LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_tgt_name}"
            ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/${_ip_tgt_name}"
            # PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${_ip_tgt_name}"
        )
        install(
            EXPORT ${_ip_tgt_name}_targets
            FILE ${_ip_tgt_name}_targets.cmake
            DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/${_ip_tgt_name}"
            NAMESPACE "${_ip_NAMESPACE}"
        )

        # Install the include directories, preserving the directory structure
        BuildTarget(GET "${_ip_target}" inc_dir_list include_dirs)
        foreach(inc_dir_i ${inc_dir_list})
            install(
                DIRECTORY "${inc_dir_i}"
                DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
                USE_SOURCE_PERMISSIONS
            )
        endforeach()

        # install(
        #     DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/_deps"
        #     DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}"
        # )

        # Writes config file to build directory
        CMakePackageManager(_generate_config "${self}" "${_ip_target}")

        # Install config file
        configure_package_config_file(
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_tgt_name}Config.cmake.in"
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_tgt_name}Config.cmake"
            INSTALL_DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/${_ip_tgt_name}"
        )

        install(
            FILES "${CMAKE_CURRENT_BINARY_DIR}/${_ip_tgt_name}Config.cmake"
            DESTINATION "${CMAKE_INSTALL_DATADIR}/cmake/${_ip_tgt_name}"
        )

    endfunction()

    #[[[
    # Generate a package config file for the given target. This function
    # writes the package config file into the ``CMAKE_CURRENT_BINARY_DIR``.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _gc_target: Target to install
    # :type _gc_target: BuildTarget*
    #]]
    cpp_member(_generate_config CMakePackageManager BuildTarget)
    function("${_generate_config}" self _gc_target)

        set(
            file_contents 
            "@PACKAGE_INIT@\n\ninclude(CMakeFindDependencyMacro)\n"
        )
        
        BuildTarget(GET "${_gc_target}" _gc_dep_list depends)
        foreach(_gc_dep_i ${_gc_dep_list})
            string(APPEND file_contents "find_dependency(${_gc_dep_i})\n")
        endforeach()
        
        BuildTarget(target "${_gc_target}" _gc_tgt_name)
        string(APPEND
            file_contents
            "include(\${CMAKE_CURRENT_LIST_DIR}/${_gc_tgt_name}_targets.cmake)\n"
        )
        
        string(APPEND
            file_contents
            "check_required_components(${_gc_tgt_name})"
        )

        file(WRITE
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_tgt_name}Config.cmake.in"
            "${file_contents}"
        )

    endfunction()

cpp_end_class()
