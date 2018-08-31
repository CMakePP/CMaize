################################################################################
# Functions for creating various types of targets #
################################################################################

function(cpp_add_library _cal_name)
    set(_cal_T_KWARGS)
    set(_cal_M_KWARGS SOURCES DEPENDS)
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
    if(NOT "${_cal_DEPENDS}" STREQUAL "")
        target_link_libraries(${_cal_name} ${__cal_DEPENDS})
    endif()
endfunction()
