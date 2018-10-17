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

################################################################################
# Functions for creating various types of targets #
################################################################################
include(cpp_print) #For debug printing
include(cpp_checks)

function(cpp_add_library _cal_name)
    set(_cal_T_KWARGS STATIC)
    set(_cal_O_KWARGS CXX_STANDARD INCLUDE_DIR)
    set(_cal_M_KWARGS SOURCES INCLUDES DEPENDS)
    cmake_parse_arguments(
        _cal
        "${_cal_T_KWARGS}"
        "${_cal_O_KWARGS}"
        "${_cal_M_KWARGS}"
        ${ARGN}
    )

    _cpp_non_empty(_cal_has_src _cal_SOURCES)
    _cpp_non_empty(_cal_has_incs _cal_INCLUDES)
    _cpp_non_empty(_cal_has_deps _cal_DEPENDS)
    cpp_option(_cal_CXX_STANDARD 17)
    cpp_option(_cal_INCLUDE_DIR ${PROJECT_SOURCE_DIR})
    if(_cal_STATIC)
        if(_cal_has_src)
            #Static library has to have sources
            add_library(${_cal_name} STATIC ${_cal_SOURCES})
        else()
            message(FATAL_ERROR "Static libraries need source files...")
        endif()
    else()
        if(_cal_has_src) #Non-interface library
            add_library(${_cal_name} ${_cal_SOURCES})
            if(_cal_has_incs)
                set_target_properties(
                        ${_cal_name}
                        PROPERTIES PUBLIC_HEADER
                        "${_cal_INCLUDES}"
                )
                target_include_directories(
                        ${_cal_name}
                        PUBLIC
                        $<BUILD_INTERFACE:${_cal_INCLUDE_DIR}>
                        $<INSTALL_INTERFACE:include>
                )
            endif()
            target_compile_features(
                ${_cal_name} PUBLIC "cxx_std_${_cal_CXX_STANDARD}"
            )
            if(_cal_has_deps)
                target_link_libraries(${_cal_name} ${_cal_DEPENDS})
            endif()
        else() #interface library
            add_library(${_cal_name} INTERFACE)
            target_include_directories(
                    ${_cal_name}
                    INTERFACE
                    $<BUILD_INTERFACE:${_cal_INCLUDE_DIR}>
                    $<INSTALL_INTERFACE:include>
            )
            target_compile_features(
                    ${_cal_name} INTERFACE "cxx_std_${_cal_CXX_STANDARD}"
            )
            if(_cal_has_deps)
                target_link_libraries(${_cal_name} INTERFACE ${_cal_DEPENDS})
            endif()
        endif()
    endif()
endfunction()

function(cpp_add_executable _cae_name)
    set(_cae_T_KWARGS STATIC)
    set(_cae_O_KWARGS CXX_STANDARD INCLUDE_DIR)
    set(_cae_M_KWARGS SOURCES DEPENDS)
    cmake_parse_arguments(
            _cae
            "${_cae_T_KWARGS}"
            "${_cae_O_KWARGS}"
            "${_cae_M_KWARGS}"
            ${ARGN}
    )
    _cpp_non_empty(_cae_has_src _cae_SOURCES)
    _cpp_assert_true(_cae_has_src)
    add_executable(${_cae_name} ${_cae_SOURCES})
    cpp_option(_cae_CXX_STANDARD 17)
    cpp_option(_cae_INCLUDE_DIR ${PROJECT_SOURCE_DIR})
    target_include_directories(
        ${_cae_name}
        PRIVATE $<BUILD_INTERFACE:${_cae_INCLUDE_DIR}>
                $<INSTALL_INTERFACE:include>
    )
    target_compile_features(
        ${_cae_name} PUBLIC "cxx_std_${_cae_CXX_STANDARD}"
    )
    _cpp_non_empty(_cae_has_deps _cae_DEPENDS)
    if(_cae_has_deps)
        target_link_libraries(${_cae_name} ${_cae_DEPENDS})
    endif()
endfunction()

function(cpp_install)
    set(_ci_T_KWARGS)
    set(_ci_O_KWARGS)
    set(_ci_M_KWARGS TARGETS)
    cmake_parse_arguments(
            _ci "${_ci_T_KWARGS}" "${_ci_O_KWARGS}" "${_ci_M_KWARGS}" ${ARGN}
    )

    #Skim the dependencies off each target
    foreach(_ci_target ${_ci_TARGETS})
        get_property(
                _ci_depends
                TARGET ${_ci_target}
                PROPERTY INTERFACE_LINK_LIBRARIES
        )
        foreach(_ci_dependi ${_ci_depends})
            if(TARGET ${_ci_dependi})
                set(_ci_is_good TRUE)
                #Make sure it's not one of the targets
                foreach(_ci_dependj ${_ci_TARGETS})
                    if("${_ci_dependi}" STREQUAL "${_ci_dependj}")
                        set(_ci_is_good FALSE)
                        break()
                    endif()
                endforeach()
                if(_ci_is_good)
                    list(APPEND _ci_DEPENDS ${_ci_dependi})
                endif()
            else()
                message(FATAL_ERROR "${_ci_dependi} is not a target")
            endif()
        endforeach()
    endforeach()

    # Directory where the generated files will be stored.
    set(_ci_generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
    # Path to the version file
    set(
        _ci_version_file
        "${_ci_generated_dir}/${CPP_project_name}-config-version.cmake"
    )
        # Path to the config file
    set(
        _ci_config_file "${_ci_generated_dir}/${CPP_project_name}-config.cmake"
    )
    set(_ci_exports ${CPP_project_name}-targets)
    set(_ci_namespace "${CPP_project_name}::")

    include(CMakePackageConfigHelpers)# For the next two functions

    write_basic_package_version_file(
            ${_ci_version_file} COMPATIBILITY SameMajorVersion
    )

    configure_package_config_file(
        "${CPP_SRC_DIR}/Config.cmake.in"
        "${_ci_config_file}"
        INSTALL_DESTINATION "${CPP_SHAREDIR}"
    )

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
