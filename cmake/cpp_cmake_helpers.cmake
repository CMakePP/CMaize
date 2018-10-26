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

function(_cpp_run_cmake_command)
    set(_crcc_O_kwargs COMMAND OUTPUT BINARY_DIR RESULT)
    set(_crcc_M_kwargs INCLUDES CMAKE_ARGS)
    cmake_parse_arguments(
        _crcc
        ""
        "${_crcc_O_kwargs}"
        "${_crcc_M_kwargs}"
        ${ARGN}
    )

    _cpp_non_empty(_crcc_cmd_set _crcc_COMMAND)
    _cpp_assert_true(_crcc_cmd_set)
    cpp_option(_crcc_BINARY_DIR ${CMAKE_BINARY_DIR})

    foreach(_crcc_arg ${_crcc_CMAKE_ARGS})
        list(APPEND _crcc_args "-D${_crcc_arg}")
    endforeach()

    #Piece file contents together
    set(_crcc_contents "include(\${CMAKE_TOOLCHAIN_FILE})")
    foreach(_crcc_inc ${_crcc_INCLUDES})
        set(_crcc_contents "${_crcc_contents}\ninclude(${_crcc_inc})")
    endforeach()
    set(_crcc_contents "${_crcc_contents}\n${_crcc_COMMAND}")

    #TODO: Call _cpp_run_sub_build????

    #Write to a random file in scratch dir
    string(RANDOM _crcc_prefix)
    set(_crcc_file ${_crcc_BINARY_DIR}/${_crcc_prefix}.cmake)
    file(WRITE ${_crcc_file} "${_crcc_contents}")
    execute_process(
        COMMAND ${CMAKE_COMMAND}
                -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                -DCPP_DEBUG_MODE=ON
                ${_crcc_args}
                -P ${_crcc_file}

        OUTPUT_VARIABLE _crcc_out
        ERROR_VARIABLE  _crcc_out
        RESULT_VARIABLE _crcc_var
    )
    #Don't assert success as we may be checking for failure
    set(${_crcc_RESULT} ${_crcc_var} PARENT_SCOPE)
    set(${_crcc_OUTPUT} "${_crcc_out}" PARENT_SCOPE)
endfunction()

function(_cpp_write_top_list _cwtl_dir _cwtl_name _cwtl_contents)
    file(
        WRITE ${_cwtl_dir}/CMakeLists.txt
"cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(${_cwtl_name} VERSION 0.0.0)
include(CPPMain)
CPPMain()
${_cwtl_contents}"
    )
endfunction()

function(_cpp_run_sub_build _crsb_dir)
    set(_crsb_T_kwargs NO_BUILD NO_INSTALL)
    set(_crsb_O_kwargs INSTALL_PREFIX OUTPUT CONTENTS NAME)
    set(_crsb_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
        _crsb
        "${_crsb_T_kwargs}"
        "${_crsb_O_kwargs}"
        "${_crsb_M_kwargs}"
        ${ARGN}
    )
    _cpp_non_empty(_crsb_output_set _crsb_OUTPUT)
    _cpp_write_top_list("${_crsb_dir}" "${_crsb_NAME}" "${_crsb_CONTENTS}")

    if(_crsb_NO_INSTALL)
        set(_crsb_install_prefix "")
    else()
        _cpp_non_empty(_crsb_install_set _crsb_INSTALL_PREFIX)
        _cpp_assert_true(_crsb_install_set)
        set(
            _crsb_install_prefix
            "-DCMAKE_INSTALL_PREFIX=${_crsb_INSTALL_PREFIX}"
        )
    endif()

    set(_crsb_add_args "${_crsb_install_prefix}")
    foreach(_crsb_arg ${_crsb_CMAKE_ARGS})
        list(APPEND _crsb_add_args "-D${_crsb_arg}")
    endforeach()

    _cpp_debug_print(
        "CMake command: ${CMAKE_COMMAND}
        -H${_crsb_dir}
        -Bbuild
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_CPP_DEBUG_MODE=ON
        ${_crsb_add_args}"
    )

    execute_process(
        COMMAND ${CMAKE_COMMAND}
                -H${_crsb_dir}
                -Bbuild
                -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                -DCPP_DEBUG_MODE=ON
                ${_crsb_add_args}
        WORKING_DIRECTORY ${_crsb_dir}
        OUTPUT_VARIABLE _crsb_cmake_out
        ERROR_VARIABLE _crsb_cmake_out
        RESULT_VARIABLE _crsb_cmake
    )
    _cpp_debug_print("Result of configuring ${_crsb_NAME}:\n${_crsb_cmake_out}")
    if(_crsb_output_set)
        set(${_crsb_OUTPUT} "${_crsb_cmake_out}")
    endif()
    _cpp_assert_false(_crsb_cmake)

    if(_crsb_NO_BUILD)
        if(_crsb_output_set)
            set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}" PARENT_SCOPE)
        endif()
        return()
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${_crsb_dir}/build
        RESULT_VARIABLE _crsb_build
        OUTPUT_VARIABLE _crsb_build_out
        ERROR_VARIABLE _crsb_build_out
    )

    _cpp_debug_print("Result of building ${_crsb_NAME}:\n${_crsb_build_out}")
    if(_crsb_output_set)
        list(APPEND ${_crsb_OUTPUT} "${_crsb_build_out}")
    endif()
    _cpp_assert_false(_crsb_make)

    if(_crsb_NO_INSTALL)
        if(_crsb_output_set)
            set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}" PARENT_SCOPE)
        endif()
        return()
    endif()
    execute_process(
        COMMAND ${CMAKE_COMMAND}
                --build ${_crsb_dir}/build
                --target install
        RESULT_VARIABLE _crsb_install
        OUTPUT_VARIABLE _crsb_install_out
        ERROR_VARIABLE _crsb_install_out
    )
    _cpp_debug_print(
        "Result of installing ${_crsb_NAME}:\n${_crsb_install_out}"
    )
    if(_crsb_output_set)
        list(APPEND ${_crsb_OUTPUT} "${_crsb_install_out}")
        set(${_crsb_OUTPUT} "${${_crsb_OUTPUT}}" PARENT_SCOPE)
    endif()
    _cpp_assert_false(_crsb_install)

endfunction()
