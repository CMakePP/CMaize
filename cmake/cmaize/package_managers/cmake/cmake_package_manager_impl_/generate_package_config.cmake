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

macro(
    _cpm_generate_package_config_impl
    self
    __gpc_output_file
    __gpc_pkg_name
)


    set(__gpc_targets ${ARGN})

    _cmaize_generated_by_cmaize(__gpc_file_contents)
    string(APPEND __gpc_file_contents "\n\n")

    string(APPEND
        __gpc_file_contents
        "include(CMakeFindDependencyMacro)\n\n"
    )

    # Get the current CMaize project
    cpp_get_global(__gpc_proj CMAIZE_TOP_PROJECT)
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
                __gpc_file_contents
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

            CMakePackageManager(GET "${self}" __gpc_dependencies dependencies)
            cpp_map(GET "${__gpc_dependencies}" __gpc_dep_obj "${__gpc_tgt_deps_i}")

            Dependency(GET
                "${__gpc_dep_obj}" __gpc_dep_build_tgt_name build_target
            )

            # This determines how the find_dependency call in the config
            # file should be formatted, based on whether the dependency is
            # a component of a package or not
            if("${__gpc_tgt_deps_i}" STREQUAL "${__gpc_dep_build_tgt_name}")
                string(APPEND
                    __gpc_file_contents
                    "find_dependency(${__gpc_tgt_deps_i})\n"
                )
            else()
                string(APPEND
                    __gpc_file_contents
                    "find_dependency(${__gpc_tgt_deps_i} COMPONENTS ${__gpc_dep_build_tgt_name})\n"
                )
            endif()
        endforeach()
    endforeach()

    # Add a space between the dependency imports and component imports
    string(APPEND __gpc_file_contents "\n" )

    # Start to generate full list of components if no specific components
    # are given
    string(APPEND
        __gpc_file_contents
        "list(LENGTH @PROJECT_NAME@_FIND_COMPONENTS "
        "@PROJECT_NAME@_FIND_COMPONENTS_len)\n"
        "if(@PROJECT_NAME@_FIND_COMPONENTS_len LESS_EQUAL 0)\n"
    )

    # Append all target names to the component list
    foreach(__gpc_targets_i ${__gpc_targets})

        string(APPEND
            __gpc_file_contents
            "    list(APPEND @PROJECT_NAME@_FIND_COMPONENTS "
            "${__gpc_targets_i})\n"
        )
    endforeach()

    # End handling no components given
    string(APPEND __gpc_file_contents "endif()\n\n")

    # Write the loop that includes all specified components
    string(APPEND
        __gpc_file_contents
        "foreach(component \${@PROJECT_NAME@_FIND_COMPONENTS})\n"
        "    include(\${CMAKE_CURRENT_LIST_DIR}/\${component}-target.cmake)\n"
        "endforeach()\n\n"
    )

    # Potentially add an additional check for imported target names
    # From: https://gist.github.com/mbinna/c61dbb39bca0e4fb7d1f73b0d66a4fd1?permalink_comment_id=3200539#gistcomment-3200539
    # pkg_check_modules(libname REQUIRED IMPORTED_TARGET libname)

    string(APPEND "check_required_components(${__gpc_pkg_name})\n")

    # Write to a file to be configured
    file(WRITE
        "${CMAKE_CURRENT_BINARY_DIR}/${__gpc_pkg_name}Config.cmake.in"
        "${__gpc_file_contents}"
    )

    set(
        "${__gpc_output_file}"
        "${CMAKE_CURRENT_BINARY_DIR}/${__gpc_pkg_name}Config.cmake.in"
    )

    cpp_return("${__gpc_output_file}")

endmacro()
