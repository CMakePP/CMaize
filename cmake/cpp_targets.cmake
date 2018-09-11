################################################################################
# Functions for creating various types of targets #
################################################################################
include(cpp_print) #For debug printing
include(cpp_checks)

function(cpp_add_library _cal_name)
    _cpp_assert_cpp_main_called()

    #Setup the target
    set(_cal_T_KWARGS NO_INSTALL)
    set(_cal_M_KWARGS SOURCES INCLUDES DEPENDS)
    cmake_parse_arguments(
            _cal
            "${_cal_T_KWARGS}"
            "${_cal_O_KWARGS}"
            "${_cal_M_KWARGS}"
            ${ARGN}
    )
    add_library(${_cal_name} ${_cal_SOURCES})
    target_include_directories(
            ${_cal_name} PUBLIC
            $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
            $<INSTALL_INTERFACE:include>
    )
    target_compile_features(${_cal_name} PUBLIC cxx_std_17)
    if(NOT "${_cal_INCLUDES}" STREQUAL "")
        set_target_properties(
                ${_cal_name}
                PROPERTIES PUBLIC_HEADER
                "${_cal_INCLUDES}"
        )
    endif()

    if(NOT "${_cal_DEPENDS}" STREQUAL "")
        target_link_libraries(${_cal_name} ${_cal_DEPENDS})
    endif()

    if(_cal_NO_INSTALL)
        return()
    endif()

    #Now set up the installation for the target

    # Directory where the generated files will be stored.
    set(_cal_generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
    set(
        _cal_version_file
        "${_cal_generated_dir}/${CPP_project_name}-config-version.cmake"
    )
    set(
        _cal_config_file
        "${_cal_generated_dir}/${CPP_project_name}-config.cmake"
    )
    set(_cal_targets_file "${CPP_project_name}-targets")
    set(_cal_namespace "${CPP_project_name}::")

    # Allows us to call the next two functions
    include(CMakePackageConfigHelpers)

    # Configure '<PROJECT-NAME>ConfigVersion.cmake'
    # Use:
    #   * PROJECT_VERSION
    write_basic_package_version_file(
            ${_cal_version_file} COMPATIBILITY SameMajorVersion
    )

    #   * PROJECT_NAME
    configure_package_config_file(
        "${CPP_SRC_DIR}/Config.cmake.in"
        "${_cal_config_file}"
        INSTALL_DESTINATION "${CPP_SHAREDIR}"
    )

    # Install targets
    install(
            TARGETS ${_cal_name}
            EXPORT "${_cal_targets_file}"
            LIBRARY DESTINATION "${CPP_LIBDIR}"
            ARCHIVE DESTINATION "${CPP_LIBDIR}"
            RUNTIME DESTINATION "${CPP_BINDIR}"
            PUBLIC_HEADER DESTINATION "${CPP_INCDIR}"
    )

    # Signal the need to install the config files we just made
    install(
            FILES "${_cal_config_file}" "${_cal_version_file}"
            DESTINATION "${CPP_SHAREDIR}"
    )
    install(
            EXPORT "${_cal_targets_file}"
            NAMESPACE "${_cal_namespace}"
            DESTINATION "${CPP_SHAREDIR}"
    )
endfunction()
