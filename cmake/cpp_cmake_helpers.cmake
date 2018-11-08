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

include(cpp_assert) #For _cpp_assert_false
include(cpp_print) #For _cpp_debug_print
include(cpp_options) #For _cpp_option

function(_cpp_write_list _cwl_directory)
    cpp_parse_arguments(
        _cwl "${ARGN}"
        OPTIONS NAME
        LISTS CONTENTS
        MUST_SET NAME
    )
    cpp_option(CMAKE_PROJECT_VERSION "0.0.0")
    #This is the boilerplate header
    set(_cwl_contents "cmake_minimum_required(VERSION ${CMAKE_VERSION})")
    list(
        APPEND _cwl_contents
        "project(${_cwl_NAME} VERSION ${CMAKE_PROJECT_VERSION})"
    )
    list(
        APPEND _cwl_contents
        "include(CPPMain)" "CPPMain()"
        "${_cwl_CONTENTS}"
    )
    foreach(_cwl_content_i ${_cwl_contents})
        set(_cwl_contents_temp "${_cwl_contents_temp}\n${_cwl_content_i}")
    endforeach()
    file(WRITE ${_cwl_directory}/CMakeLists.txt "${_cwl_contents_temp}")
endfunction()

function(_cpp_run_sub_make)
    cpp_parse_arguments(
        _crsm "${ARGN}"
        OPTIONS BINARY_DIR COMMAND OUTPUT RESULT TARGET
        MUST_SET BINARY_DIR
    )

    if(_crsm_TARGET)
        execute_process(
                COMMAND ${CMAKE_COMMAND}
                        --build ${_crsm_BINARY_DIR}
                        --target ${_crsm_TARGET}
                OUTPUT_VARIABLE _crsm_output
                ERROR_VARIABLE _crsm_output
                RESULT_VARIABLE _crsm_result
        )
    else()
        execute_process(
                COMMAND ${CMAKE_COMMAND} --build ${_crsm_BINARY_DIR}
                OUTPUT_VARIABLE _crsm_output
                ERROR_VARIABLE _crsm_output
                RESULT_VARIABLE _crsm_result
        )
    endif()
    if(_crsm_COMMAND)
        set(${_crsm_COMMAND} "${_crsm_command}" PARENT_SCOPE)
    endif()
    if(_crsc_OUTPUT)
        set(${_crsm_OUTPUT} "${_crsm_output}" PARENT_SCOPE)
    endif()
    if(_crsc_RESULT)
        set(${_crsm_RESULT} "${_crsm_result}" PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_run_sub_build _crsb_dir)
    cpp_parse_arguments(
        _crsb "${ARGN}"
        TOGGLES NO_BUILD NO_INSTALL CAN_FAIL
        OPTIONS NAME OUTPUT RESULT BINARY_DIR INSTALL_DIR TOOLCHAIN
        LISTS CONTENTS
        MUST_SET NAME
    )
    cpp_option(_crsb_BINARY_DIR "${_crsb_dir}/build")
    cpp_option(_crsb_INSTALL_DIR "${_crsb_dir}/install")
    cpp_option(_crsb_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    cpp_option(_crsb_OUTPUT "CPP_DEV_NULL")
    cpp_option(_crsb_RESULT "CPP_DEV_NULL")
    _cpp_is_not_empty(_crsb_has_content _crsb_CONTENTS)
    if(_crsb_has_content)
        _cpp_write_list(
            ${_crsb_dir}
            NAME ${_crsb_NAME}
            CONTENTS ${_crsb_CONTENTS}
        )
    endif()

    ############################### Configure ##################################

    execute_process(
       COMMAND ${CMAKE_COMMAND}
               -H.
               -B${_crsb_BINARY_DIR}
               -DCMAKE_INSTALL_PREFIX=${_crsb_INSTALL_DIR}
               -DCMAKE_TOOLCHAIN_FILE=${_crsb_TOOLCHAIN}
       WORKING_DIRECTORY ${_crsb_dir}
       OUTPUT_VARIABLE _crsb_configure_output
       ERROR_VARIABLE _crsb_configure_output
       RESULT_VARIABLE _crsb_configure_failed
    )

    set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_configure_output}")
    set(
        ${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_configure_output}"
        PARENT_SCOPE
    )
    set(${_crsb_RESULT} "${_crsb_configure_failed}" PARENT_SCOPE)
    if(${_crsb_configure_failed})
        if(_crsb_CAN_FAIL)
            return()
        else()
            message(
                FATAL_ERROR
                "Configure failed with output: ${_crsb_configure_output}"
            )
        endif()
    endif()

    ################################   Build   #################################

    if(_crsb_NO_BUILD)
        return()
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${_crsb_BINARY_DIR}
        OUTPUT_VARIABLE _crsb_build_output
        ERROR_VARIABLE _crsb_build_output
        RESULT_VARIABLE _crsb_build_failed
    )
    set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_build_output}")
    set(
        ${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_build_output}"
            PARENT_SCOPE
    )
    set(${_crsb_RESULT} "${_crsb_build_failed}" PARENT_SCOPE)
    if(${_crsb_configure_failed})
        if(_crsb_CAN_FAIL)
            return()
        else()
            message(
                FATAL_ERROR
                "Build failed with output: ${_crsb_build_output}"
            )
        endif()
    endif()


    ############################    Install     ################################
    if(_crsb_NO_INSTALL)
        return()
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${_crsb_BINARY_DIR} --target install
        OUTPUT_VARIABLE _crsb_install_output
        ERROR_VARIABLE _crsb_install_output
        RESULT_VARIABLE _crsb_install_failed
    )
    set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_install_output}")
    set(
            ${_crsb_OUTPUT} "${${_crsb_OUTPUT}}${_crsb_install_output}"
            PARENT_SCOPE
    )
    set(${_crsb_RESULT} "${_crsb_install_failed}" PARENT_SCOPE)

    if(${_crsb_install_failed})
        if(_crsb_CAN_FAIL)
            return()
        else()
            message(
                FATAL_ERROR
                "Install failed with output: ${_crsb_install_output}"
            )
        endif()
    endif()
endfunction()
