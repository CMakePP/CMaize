include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/target)
include(cmaize/project/project_specification)

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
    # Virtual member to check if the package exists in the package manager.
    #
    # :param self: CMakePackageManager object
    # :type self: CMakePackageManager
    # :param _hp_result: Whether the package was found (TRUE) or not (FALSE)
    # :type _hp_result: bool*
    # :param _hp_project_specs: Specifications for the package to build.
    # :type _hp_project_specs: ProjectSpecification
    #]]
    cpp_member(has_package CMakePackageManager desc ProjectSpecification)
    function("${has_package}" self _hp_result _hp_project_specs)

        ProjectSpecification(GET "${_hp_project_specs}" _hp_pkg_name name)
        ProjectSpecification(GET "${_hp_project_specs}" _hp_pkg_version version)

        CMakePackageManager(GET "${self}" _hp_search_paths search_paths)
        list(LENGTH _hp_search_paths _hp_search_paths_n)

        # Build the argument list for ``find_package()``
        list(APPEND _hp_arg_list "${_hp_pkg_name}")
        if(_hp_pkg_version)
            list(APPEND _hp_arg_list "${_hp_pkg_version}")
            list(APPEND _hp_arg_list "EXACT")
        endif()
        if(_hp_search_paths_n GREATER 0)
            list(APPEND _hp_arg_list "PATHS" "${_hp_search_paths}")
            # Disables the default paths so there are no surprises
            list(APPEND _hp_arg_list "NO_DEFAULT_PATH")
        endif()

        # Join the list with spaces so separate arguments are parsed properly
        list(JOIN _hp_arg_list " " _hp_arg_list)

        # Effectively ``find_package("${_hp_arg_list}")``
        cmake_language(EVAL CODE "find_package(${_hp_arg_list})")

        # The bool result can be based on <PackageName>_FOUND result from
        # ``find_package``
        set("${_hp_result}" "${${_hp_pkg_name}_FOUND}")
        cpp_return("${_hp_result}")

    endfunction()

    #[[[
    # Virtual member function to get the package using the package manager.
    #]]
    cpp_member(get_package CMakePackageManager InstalledTarget ProjectSpecification)
    function("${get_package}" self _gp_result_target _gp_proj_specs)

        CMakePackageManager(has_package _gp_has_package "${_gp_proj_specs}")

        # No package, exit early
        if (NOT _gp_has_package)
            set("${gp_result_target}" "")
            cpp_return("${gp_result_target}")
        endif()

        # TODO: Handle when the package actually exists...
    endfunction()

    #[[[
    # Virtual member to install a package.
    #]]
    cpp_member(install_package CMakePackageManager BuildTarget args)
    function("${install_package}" self _ip_target)

        set(_ip_options NAMESPACE)
        cmake_parse_arguments(_ip "" "${_ip_options}" "" ${ARGN})

        Target(target "${_ip_target}" _ip_tgt_name)

        if("${_ip_NAMESPACE}" STREQUAL "")
            set(_ip_NAMESPACE "${_ip_tgt_name}::")
        endif()

        # Generate <target>Config.cmake

        install(
            TARGETS "${_ip_tgt_name}"
            EXPORT "${_ip_tgt_name}_targets"
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}/${PROJECT_NAME}"
            LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}"
            ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}"
            # PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}"
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

    # NOTE: https://www.f-ax.de/dev/2020/10/07/cmake-config-package.html
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
