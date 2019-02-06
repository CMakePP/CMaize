################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(dependency/read_helper_targets)
include(object/object)
include(CMakePackageConfigHelpers)

function(cpp_install)
    set(_ci_T_KWARGS)
    set(_ci_O_KWARGS PREFIX_TO_STRIP)
    set(_ci_M_KWARGS TARGETS)
    cmake_parse_arguments(
            _ci "${_ci_T_KWARGS}" "${_ci_O_KWARGS}" "${_ci_M_KWARGS}" ${ARGN}
    )
    _cpp_option(_ci_PREFIX_TO_STRIP ${PROJECT_SOURCE_DIR}/${CPP_NAMESPACE})

    #Skim the dependencies off each target
    foreach(_ci_target ${_ci_TARGETS})
        get_property(
            _ci_depends TARGET ${_ci_target} PROPERTY INTERFACE_LINK_LIBRARIES
        )
        list(APPEND _ci_depend_list "${_ci_depends}")
    endforeach()

    _cpp_read_helper_targets(_ci_find_recipes "${_ci_depend_list}")

    if(_ci_find_recipes)
        list(REMOVE_DUPLICATES _ci_find_recipes)
    endif()

    foreach(_ci_fr_i ${_ci_find_recipes})
        _cpp_Object_get_value(${_ci_fr_i} _ci_paths paths)
        _cpp_Object_get_value(${_ci_fr_i} _ci_name name)
        _cpp_Object_has_member(${_ci_fr_i} _ci_has_fm module_path)
        set(_ci_line "cpp_find_dependency(\n")
        set(_ci_line "${_ci_line}    NAME \"${_ci_name}\"\n")
        set(_ci_line "${_ci_line}    PATHS \"${_ci_paths}\"\n")
        if(_ci_has_fm)
            _cpp_Object_get_value(${_ci_fr_i} _ci_fm module_path)
            set(_ci_line "${_ci_line}    FIND_MODULE ${_ci_fm}\n")
        endif()
        set(_ci_line "${_ci_line})\n")
        set(_ci_find_depends "${_ci_find_depends}${_ci_line}")
    endforeach()

    # Set the paths for the config files
    set(_ci_generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
    set(_ci_prefix "${_ci_generated_dir}/${CPP_project_name}-config")
    set(_ci_version_file "${_ci_prefix}-version.cmake")
    set(_ci_config_file "${_ci_prefix}.cmake")

    set(_ci_exports ${CPP_project_name}-targets)
    set(_ci_namespace "${CPP_project_name}::")

    write_basic_package_version_file(
            ${_ci_version_file} COMPATIBILITY SameMajorVersion
    )

    configure_package_config_file(
            "${CPP_SRC_DIR}/Config.cmake.in"
            "${_ci_config_file}"
            INSTALL_DESTINATION "${CPP_SHAREDIR}"
    )

    #CMake doesn't preserve the header hierarchy of PUBLIC_HEADER so we get to
    #do it manually
    foreach(_ci_target ${_ci_TARGETS})
        get_property(
            _ci_includes
            TARGET ${_ci_target} PROPERTY PUBLIC_HEADER
        )
        foreach(_ci_include_file ${_ci_includes})
            get_filename_component(
                _ci_relative_dir ${_ci_include_file} DIRECTORY
            )
            install(
                FILES ${_ci_include_file}
                DESTINATION ${CPP_INCDIR}/${_ci_relative_dir}
            )
        endforeach()
        set_target_properties(${_ci_target} PROPERTIES PUBLIC_HEADER "")
    endforeach()

    install(
        TARGETS ${_ci_TARGETS}
        EXPORT ${_ci_exports}
        LIBRARY DESTINATION "${CPP_LIBDIR}"
        ARCHIVE DESTINATION "${CPP_LIBDIR}"
        RUNTIME DESTINATION "${CPP_BINDIR}"
        PUBLIC_HEADER DESTINATION "${CPP_INCDIR}"
    )

    # Signal the need to install the config files we just made
    install(
        FILES "${_ci_config_file}" "${_ci_version_file}"
        DESTINATION "${CPP_SHAREDIR}"
    )
    install(
        EXPORT ${_ci_exports}
        NAMESPACE "${_ci_namespace}"
        DESTINATION "${CPP_SHAREDIR}"
    )
endfunction()
