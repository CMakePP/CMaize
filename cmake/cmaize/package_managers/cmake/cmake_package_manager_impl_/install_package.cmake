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

function(_cpm_install_package_impl self _ip_pkg_name)
    set(_ip_one_value_args NAMESPACE VERSION)
    set(_ip_multi_value_args TARGETS)
    cmake_parse_arguments(
        _ip "" "${_ip_one_value_args}" "${_ip_multi_value_args}" ${ARGN}
    )

    message(DEBUG "Preparing installation for ${_ip_pkg_name}")

    # Get the current CMaize project
    cpp_get_global(_ip_proj CMAIZE_PROJECT_${PROJECT_NAME})
    cpp_get_global(_ip_top_proj CMAIZE_TOP_PROJECT)
    CMaizeProject(GET "${_ip_proj}" _ip_proj_name name)
    CMaizeProject(GET "${_ip_top_proj}" _ip_top_proj_name name)

    # Establish prefixes
    set(_ip_destination_prefix ".")
    CMakePackageManager(GET "${self}" _ip_lib_prefix library_prefix)
    CMakePackageManager(GET "${self}" _ip_bin_prefix binary_prefix)

    if("${_ip_proj_name}" STREQUAL "${_ip_top_proj_name}")
        set(
            CMAKE_INSTALL_PREFIX
            "${CMAKE_INSTALL_PREFIX}/${_ip_lib_prefix}/${_ip_pkg_name}/external"
            CACHE PATH "" FORCE
        )

        set(_ip_destination_prefix "../../..")
    endif()

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
            "${_ip_top_proj}" _ip_tgt_obj_i "${_ip_TARGETS_i}"
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
        CMaizeProject(
            get_target "${_ip_top_proj}" _ip_tgt_obj_i "${_ip_TARGETS_i}"
        )

        set(
            _ip_tgt_config
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_TARGETS_i}-target.cmake"
        )
        set(
            _ip_tgt_config_install_dest
            "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}/cmake"
        )

        install(
            TARGETS "${_ip_TARGETS_i}"
            EXPORT "${_ip_TARGETS_i}-target"
            RUNTIME DESTINATION
                "${_ip_destination_prefix}/${_ip_bin_prefix}/${_ip_pkg_name}"
            LIBRARY DESTINATION
                "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}"
            ARCHIVE DESTINATION
                "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}"
            # PUBLIC_HEADER DESTINATION
            #     "${_ip_destination_prefix}/${CMAKE_INSTALL_INCLUDEDIR}/${_ip_pkg_name}"
        )

        # Set each package target's installation path(s). Currently this
        # sets both the bin and lib directories but realistically only
        # one or the other would actually contain the target binary
        set(_ip_destination_prefix_tmp "${_ip_destination_prefix}")
        if(NOT "${_ip_proj_name}" STREQUAL "${_ip_top_proj_name}")
            # We store a temporary destination prefix since it is only
            # going to be used to determine install paths and we don't
            # want to affect the _ip_destination_prefix used elsewhere
            set(
                _ip_destination_prefix_tmp
                "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_top_proj_name}/external"
            )
        endif()

        # Get the absolute path of the temporary destination prefix
        file(REAL_PATH
            "${_ip_destination_prefix_tmp}"
            _ip_destination_prefix_abs_path
            BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
        )

        # Generate the install paths
        set(
            _ip_install_paths
            "${_ip_destination_prefix_abs_path}/${_ip_bin_prefix}/${_ip_pkg_name}"
            "${_ip_destination_prefix_abs_path}/${_ip_lib_prefix}/${_ip_pkg_name}"
        )
        CMaizeTarget(SET "${_ip_tgt_obj_i}" install_path "${_ip_install_paths}")
        CMaizeTarget(SET_PROPERTY "${_ip_tgt_obj_i}" INSTALL_PATH "${_ip_install_paths}")

        # Writes config file to build directory
        CMakePackageManager(_generate_target_config
            "${self}"
            "${_ip_tgt_obj_i}"
            "${_ip_TARGETS_i}"
            "${_ip_NAMESPACE}"
            "${_ip_tgt_config}"
            "${_ip_tgt_config_install_dest}"
        )

        # Install the include directories, preserving the include directory
        # structure
        BuildTarget(GET "${_ip_tgt_obj_i}" _ip_inc_dir_list include_dirs)
        foreach(_ip_inc_dir_i ${_ip_inc_dir_list})
            install(
                DIRECTORY "${_ip_inc_dir_i}"
                DESTINATION
                    "${_ip_destination_prefix}/${CMAKE_INSTALL_INCLUDEDIR}"
                USE_SOURCE_PERMISSIONS
            )
        endforeach()
    endforeach()

    # Set INSTALL_RPATH to install paths of dependencies to ensure they
    # can be found
    foreach(_ip_TARGETS_i ${_ip_TARGETS})
        CMaizeProject(get_target
            "${_ip_top_proj}" _ip_tgt_obj_i "${_ip_TARGETS_i}"
        )

        # Loop over each dependency. This is currently done by looking
        # up the dependencies by name from the CMaizeProject, but later
        # we should make each CMaize target hold references to its
        # dependencies
        BuildTarget(GET "${_ip_tgt_obj_i}" _dep_list depends)
        foreach(dependency ${_dep_list})
            # Fetch the dependency's target object
            CMaizeProject(get_target
                "${_ip_top_proj}" _dep_tgt_obj "${dependency}"
            )

            # Skip the dependency if it is not managed by CMaize, since
            # those won't have install path information
            if("${_dep_tgt_obj}" STREQUAL "")
                continue()
            endif()

            # Get the install path for the dependency
            CMaizeTarget(GET "${_dep_tgt_obj}" _dep_install_path install_path)

            # Turn the dependency paths into absolute paths
            file(REAL_PATH
                "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}"
                _ip_lib_path
                BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
            )
            # Replace install prefix with $ORIGIN
            # We currently don't do this since we couldn't get it to work
            # string(REPLACE "${_ip_lib_path}" "$ORIGIN" _dep_install_path "${_dep_install_path}")

            # While not a great way to do it, this will check if the dependency
            # has any INSTALL_RPATH data. If it does, we add that data to the
            # current target as well. In theory, each target should manage its
            # own INSTALL_RPATH set, but for now that does not seem to be working.
            CMaizeTarget(has_property "${_dep_tgt_obj}" _dep_has_install_rpath INSTALL_RPATH)
            if(_dep_has_install_rpath)
                CMaizeTarget(get_property "${_dep_tgt_obj}" _dep_install_rpath INSTALL_RPATH)
            endif()

            # Actually append the aggregated paths to the current target's
            # INSTALL_RPATH
            CMaizeTarget(get_property "${_ip_tgt_obj_i}" _install_rpath INSTALL_RPATH)
            list(APPEND _install_rpath ${_dep_install_path})
            list(APPEND _install_rpath ${_dep_install_rpath})
            CMaizeTarget(set_property "${_ip_tgt_obj_i}" INSTALL_RPATH "${_install_rpath}")
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
            "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}/cmake"
    )
    # Create package version file
    write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}ConfigVersion.cmake"
        VERSION "${_ip_VERSION}"
        COMPATIBILITY SameMajorVersion
    )

    install(
        FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}Config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${_ip_pkg_name}ConfigVersion.cmake"
        DESTINATION
            "${_ip_destination_prefix}/${_ip_lib_prefix}/${_ip_pkg_name}/cmake"
    )

endfunction()
