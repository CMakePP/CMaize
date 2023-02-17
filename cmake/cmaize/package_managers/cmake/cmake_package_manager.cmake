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

        # This didn't work
        # set(_rd_lists CMAKE_ARGS)
        # cmake_parse_arguments(_rd "" "" "${_rd_lists}" ${ARGN})

        # cpp_contains(_rd_contains_cmake_args "CMAKE_INSTALL_PREFIX" "${_rd_CMAKE_ARGS}")
        # if(NOT _rd_contains_cmake_args)
        #     list(APPEND _rd_CMAKE_ARGS "CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/lib/test/external")
        # endif()

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

        set(_fi_one_value_args BUILD_TARGET FIND_TARGET NAME URL VERSION)
        cmake_parse_arguments(
            _fi "" "${_fi_one_value_args}" "" ${ARGN}
        )

        ProjectSpecification(GET "${_fi_project_specs}" _fi_pkg_name name)

        CMakePackageManager(register_dependency
            "${self}"
            _fi_depend
            "${_fi_project_specs}"
            ${ARGN}
        )

        Dependency(find_dependency "${_fi_depend}" _fi_found)
        message(DEBUG "${_fi_pkg_name}_DIR: ${${_fi_pkg_name}_DIR}")
        if(NOT "${_fi_found}" OR "${${_fi_pkg_name}_DIR}" STREQUAL "${_fi_pkg_name}_DIR-NOTFOUND")
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

        message(DEBUG "Creating InstalledTarget object for ${_fi_FIND_TARGET}")
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

        Dependency(GET "${_gp_depend}" _gp_find_target "find_target")
        Dependency(GET "${_gp_depend}" _gp_build_target "build_target")

        # Create a build target
        BuildTarget(CTOR "${_gp_result}" "${_gp_build_target}")

        # Alias the build target as the find_target to unify the API
        if(NOT TARGET "${_gp_find_target}")
            if(NOT "${_gp_find_target}" STREQUAL "${_gp_build_target}")
                # if(TARGET "${_gp_find_target}")
                #     return()
                # endif()
                add_library("${_gp_find_target}" ALIAS "${_gp_build_target}")
            endif()
        endif()

        # Create a build target
        # BuildTarget(CTOR "${_gp_result}" "${_gp_find_target}")

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

        # Doesn't work to set rpaths
        # # Set up some default RPATH information
        # file(RELATIVE_PATH
        #     _ip_rel_dir
        #     "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}/${_ip_pkg_name}"
        #     "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}"
        # )
        # set(CMAKE_INSTALL_RPATH $ORIGIN $ORIGIN/external/tmp)

        # Get the current CMaize project
        cpp_get_global(_ip_proj CMAIZE_PROJECT_${PROJECT_NAME})
        cpp_get_global(_ip_top_proj CMAIZE_TOP_PROJECT)
        CMaizeProject(GET "${_ip_proj}" _ip_proj_name name)
        CMaizeProject(GET "${_ip_top_proj}" _ip_top_proj_name name)

        set(_ip_destination_prefix ".")

        if("${_ip_proj_name}" STREQUAL "${_ip_top_proj_name}")
            # set(old_CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
            set(
                CMAKE_INSTALL_PREFIX
                "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/external"
                CACHE PATH "" FORCE
            )

            set(_ip_destination_prefix "../../..")
        endif()

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

            set(
                _ip_tgt_config
                "${CMAKE_CURRENT_BINARY_DIR}/${_ip_TARGETS_i}-target.cmake"
            )
            set(
                _ip_tgt_config_install_dest
                "${_ip_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
            )

            install(
                TARGETS "${_ip_TARGETS_i}"
                EXPORT "${_ip_TARGETS_i}-target"
                RUNTIME DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_BINDIR}/${_ip_pkg_name}"
                LIBRARY DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}"
                ARCHIVE DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}"
                # PUBLIC_HEADER DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_INCLUDEDIR}/${_ip_pkg_name}"
            )
            # install(
            #     EXPORT ${_ip_TARGETS_i}-target
            #     FILE ${_ip_TARGETS_i}-target.cmake
            #     DESTINATION "${_ip_tgt_config_install_dest}"
            #     NAMESPACE "${_ip_NAMESPACE}"
            #     COMPONENT ${_ip_TARGETS_i}-target
            # )

            # Writes config file to build directory
            CMakePackageManager(_generate_target_config
                "${self}"
                "${_ip_tgt_obj_i}"
                "${_ip_TARGETS_i}"
                "${_ip_NAMESPACE}"
                "${_ip_tgt_config}"
                "${_ip_tgt_config_install_dest}"
            )

            # Install the include directories, preserving the directory structure
            BuildTarget(GET "${_ip_tgt_obj_i}" _ip_inc_dir_list include_dirs)
            foreach(_ip_inc_dir_i ${_ip_inc_dir_list})
                install(
                    DIRECTORY "${_ip_inc_dir_i}"
                    DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_INCLUDEDIR}"
                    USE_SOURCE_PERMISSIONS
                )
            endforeach()
        endforeach()

        # Writes config file to build directory
        CMakePackageManager(_generate_package_config
            "${self}" _ip_pkg_config_in "${_ip_pkg_name}" ${_ip_TARGETS}
        )

        # Install config file
        configure_package_config_file(
            "${_ip_pkg_config_in}"
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}Config.cmake"
            INSTALL_DESTINATION
                "${_ip_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
        )
        # Create package version file
        write_basic_package_version_file(
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}ConfigVersion.cmake"
            VERSION "${_ip_VERSION}"
            COMPATIBILITY SameMajorVersion
        )

        install(
            FILES "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}Config.cmake"
                  "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}ConfigVersion.cmake"
            DESTINATION "${_ip_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_ip_pkg_name}/cmake"
        )

        # set(
        #     CMAKE_INSTALL_PREFIX 
        #     "${old_CMAKE_INSTALL_PREFIX}"
        #     CACHE PATH "" FORCE
        # )

    endfunction()

    cpp_member(_generate_package_config CMakePackageManager desc str args)
    function("${_generate_package_config}"
        self __gpc_output_file __gpc_pkg_name
    )

        set(__gpc_targets ${ARGN})

        set(_gpc_file_contents "")

        string(APPEND
            _gpc_file_contents
            "include(CMakeFindDependencyMacro)\n\n"
        )

        # Get the current CMaize project
        cpp_get_global(__gpc_proj CMAIZE_PROJECT_${PROJECT_NAME})
        foreach(__gpc_targets_i ${__gpc_targets})
            CMaizeProject(get_target
                "${__gpc_proj}" __gpc_tgt_obj "${__gpc_targets_i}"
            )
            BuildTarget(GET "${__gpc_tgt_obj}" __gpc_tgt_deps depends)

            list(LENGTH __gpc_tgt_deps __gpc_tgt_deps_len)

            # Appends the 'external/' directory to the CMAKE_PREFIX_PATH
            # if there are dependencies that were built under the package
            if(__gpc_tgt_deps_len GREATER 0)
                string(APPEND
                    _gpc_file_contents
                    "set(\n"
                    "    CMAKE_PREFIX_PATH\n"
                    "    \"\${CMAKE_PREFIX_PATH}\" \"\${CMAKE_CURRENT_LIST_DIR}/../external\"\n"
                    "    CACHE STRING \"\" FORCE\n"
                    ")\n\n"
                )
            endif()

            foreach(__gpc_tgt_deps_i ${__gpc_tgt_deps})
                message(DEBUG "Processing dependency: ${__gpc_tgt_deps_i}")

                # Skip dependency processing if this is not a target managed
                # by the CMaize project
                CMaizeProject(check_target
                    "${__gpc_proj}"
                    __gpc_is_cmaize_tgt
                    "${__gpc_tgt_deps_i}"
                    ALL
                )
                if(NOT __gpc_is_cmaize_tgt)
                    message(
                        DEBUG
                        "Skipping ${__gpc_tgt_deps_i}. It is not target "
                        "managed by CMaize."
                    )
                    continue()
                endif()

                # Skip dependency processing if it is a target defined as a
                # part of this package
                cpp_contains(_gpc_dep_is_proj_tgt "${__gpc_tgt_deps_i}" "${__gpc_targets}")
                if(_gpc_dep_is_proj_tgt)
                    message(
                        DEBUG
                        "Skipping ${__gpc_tgt_deps_i}. It is a target defined "
                        "by this project."
                    )
                    continue()
                endif()

                # Check if it is a dependency to be built and redirect the
                # installation to the ``external`` directory
                CMaizeProject(get_target
                    "${__gpc_proj}" __gpc_tgt_deps_i_obj "${__gpc_tgt_deps_i}"
                )
                
                cpp_type_of(__gpc_dep_type "${__gpc_tgt_deps_i_obj}")
                if("${__gpc_dep_type}" STREQUAL "buildtarget")
                    cpp_get_global(
                        __gpc_dep_obj "__CMAIZE_DEPENDENCY_${__gpc_tgt_deps_i}__"
                    )
                    Dependency(GET
                        "${__gpc_dep_obj}" __gpc_dep_build_tgt_name build_target
                    )

                    install(
                        TARGETS "${__gpc_dep_build_tgt_name}"
                        RUNTIME DESTINATION "tmp"
                        LIBRARY DESTINATION "tmp"
                    )
                endif()

                cpp_get_global(
                    __gpc_dep_obj "__CMAIZE_DEPENDENCY_${__gpc_tgt_deps_i}__"
                )
                Dependency(GET
                    "${__gpc_dep_obj}" __gpc_dep_build_tgt_name build_target
                )

                if("${__gpc_tgt_deps_i}" STREQUAL "${__gpc_dep_build_tgt_name}")
                    string(APPEND
                        _gpc_file_contents
                        "find_dependency(${__gpc_tgt_deps_i})\n"
                    )
                else()
                    string(APPEND
                        _gpc_file_contents
                        "find_dependency(${__gpc_tgt_deps_i} COMPONENTS ${__gpc_dep_build_tgt_name})\n"
                    )
                endif()
            endforeach()
        endforeach()

        # Add a space between the dependency imports and component imports
        string(APPEND _gpc_file_contents "\n" )

        # Start to generate full list of components if no specific components
        # are given
        string(APPEND
            _gpc_file_contents
            "list(LENGTH @PROJECT_NAME@_FIND_COMPONENTS " 
            "@PROJECT_NAME@_FIND_COMPONENTS_len)\n"
            "if(@PROJECT_NAME@_FIND_COMPONENTS_len LESS_EQUAL 0)\n"
        )

        # Append all target names to the component list
        foreach(__gpc_targets_i ${__gpc_targets})

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
            "endforeach()\n\n"
        )

        string(APPEND "check_required_components(${__gpc_pkg_name})\n")

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
    # :param __gtc_target_name: Identifying name of target to install.
    # :type __gtc_target_name: desc or target
    # :param __gtc_config_file: Path to the config file.
    # :type __gtc_config_file: path
    # :param __gtc_install_dest: Path to the installation destination.
    # :type __gtc_install_dest: path
    #]]
    cpp_member(_generate_target_config CMakePackageManager BuildTarget str str path str)
    function("${_generate_target_config}"
        self __gtc_tgt_obj __gtc_target_name __gtc_namespace __gtc_config_file __gtc_install_dest
    )

        # # Get the current CMaize project
        # cpp_get_global(__gtc_proj CMAIZE_PROJECT_${PROJECT_NAME})

        # set(
        #     __gtc_file_contents 
        #     "@PACKAGE_INIT@\n\n"
        # )
        set(
            __gtc_file_contents 
            "##### Generated by CMaize\n\n"
        )
        string(APPEND
            __gtc_file_contents 
            "get_filename_component(PACKAGE_PREFIX_DIR "
            "\"\${CMAKE_CURRENT_LIST_DIR}/../../..\" ABSOLUTE)\n"
        )

        BuildTarget(GET "${__gtc_tgt_obj}" __gtc_dep_list depends)
        CXXTarget(GET "${__gtc_tgt_obj}" __gtc_cxx_std cxx_standard)
        CMaizeTarget(get_property "${__gtc_tgt_obj}" __gtc_version VERSION)
        CMaizeTarget(get_property "${__gtc_tgt_obj}" __gtc_so_version SOVERSION)

        string(APPEND
            __gtc_file_contents
            "
# Create imported target ${__gtc_namespace}${__gtc_target_name}
add_library(${__gtc_namespace}${__gtc_target_name} SHARED IMPORTED)

set_target_properties(${__gtc_namespace}${__gtc_target_name} PROPERTIES
    INTERFACE_COMPILE_FEATURES \"cxx_std_${__gtc_cxx_std}\"
    INTERFACE_INCLUDE_DIRECTORIES \"\${PACKAGE_PREFIX_DIR}/include\"
    INTERFACE_LINK_LIBRARIES "
        )

        set(__gtc_interface_link_libraries)
        foreach(__gtc_dep_i ${__gtc_dep_list})
            # Get the current CMaize project
            # cpp_get_global(__gtc_proj CMAIZE_PROJECT_${PROJECT_NAME})

            # CMaizeProject(get_target
            #     "${__gtc_proj}" __gtc_tgt_deps_i_obj "${__gtc_dep_i}"
            # )
            cpp_get_global(
                __gtc_dep_obj "__CMAIZE_DEPENDENCY_${__gtc_dep_i}__"
            )
            if("${__gtc_dep_obj}" STREQUAL "")
                continue()
            endif()
            Dependency(GET
                "${__gtc_dep_obj}" __gtc_dep_find_tgt_name find_target
            )
            
            # CMaizeTarget(target "${__gtc_tgt_deps_i_obj}" __gtc_dep_name)

            list(APPEND __gtc_interface_link_libraries ${__gtc_dep_find_tgt_name})
        endforeach()

        string(APPEND
            __gtc_file_contents
            "\"${__gtc_interface_link_libraries}\"
)\n"
        )

        string(APPEND
            __gtc_file_contents
            "
set(_CMAIZE_IMPORT_LOCATION \"\${PACKAGE_PREFIX_DIR}/lib/${__gtc_target_name}/lib${__gtc_target_name}.so.${__gtc_version}\")

# Import target \"${__gtc_namespace}${__gtc_target_name}\" for configuration \"???\"
set_property(TARGET ${__gtc_namespace}${__gtc_target_name} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(${__gtc_namespace}${__gtc_target_name} PROPERTIES
    IMPORTED_LOCATION_RELEASE \"\${_CMAIZE_IMPORT_LOCATION}\"
    IMPORTED_SONAME_RELEASE \"lib${__gtc_target_name}.so.${__gtc_so_version}\"
)\n"
        )

        string(APPEND
            __gtc_file_contents 
            "
# Unset variables used
set(PACKAGE_PREFIX_DIR)
set(_CMAIZE_IMPORT_LOCATION)"
        )

        # CMaizeProject(get_target
        #     "${__gtc_proj}" __gtc_tgt_obj "${__gtc_target_name}"
        # )
        # BuildTarget(GET "${__gtc_tgt_obj}" __gtc_dep_list depends)

        # foreach(__gtc_dep_i ${__gtc_dep_list})
        #     # CMaizeProject(get_target
        #     #     "${__gtc_proj}" __gtc_dep_obj "${__gtc_dep_i}" ALL
        #     # )
        #     # CMaizeTarget(target "${__gtc_dep_obj}" __gtc_dep_name)
            
        #     if("${__gtc_dep_name}" STREQUAL "${__gtc_dep_i}")
        #         string(APPEND
        #             __gtc_file_contents "find_dependency(${__gtc_dep_i})\n"
        #         )
        #     else()
        #         string(APPEND
        #             __gtc_file_contents
        #             "find_dependency(${__gtc_dep_i} COMPONENT ${__gtc_dep_name})\n"
        #         )
        #     endif()
        # endforeach()
        
        # # string(APPEND
        # #     __gtc_file_contents
        # #     "include(\${CMAKE_CURRENT_LIST_DIR}/${__gtc_target_name}-target.cmake)\n"
        # # )
        
        # # string(APPEND
        # #     __gtc_file_contents
        # #     "check_required_components(${__gtc_target_name})"
        # # )

        # Write the config file *.in variant
        set(__gtc_config_file_in "${__gtc_config_file}.in")
        file(WRITE "${__gtc_config_file_in}" "${__gtc_file_contents}")

        # Configure the file so it is ready for installation
        configure_package_config_file(
            "${__gtc_config_file_in}"
            "${__gtc_config_file}"
            INSTALL_DESTINATION
                "${__gtc_install_dest}"
        )

        # Install config file
        install(FILES "${__gtc_config_file}" DESTINATION "${__gtc_install_dest}")

    endfunction()

cpp_end_class()
