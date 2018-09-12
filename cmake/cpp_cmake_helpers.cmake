include(cpp_assert) #For _cpp_assert_false
include(cpp_print) #For _cpp_debug_print
include(cpp_options) #For _cpp_option

function(_cpp_write_top_list)
    set(_cwtl_O_kwargs PATH NAME CONTENTS)
    cmake_parse_arguments(_cwtl "" "${_cwtl_O_kwargs}" "" ${ARGN})
    _cpp_assert_not_equal(_cwtl_PATH "")
    _cpp_assert_not_equal(_cwtl_NAME "")
    # I guess we don't rigrorously need contents

    file(
        WRITE ${_cwtl_PATH}/CMakeLists.txt
"cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(${_cwtl_NAME} VERSION 0.0.0)
include(CPPMain)
CPPMain()
${_cwtl_CONTENTS}
"
    )
endfunction()


function(_cpp_run_cmake_command)
    set(_rcc_O_kwargs COMMAND OUTPUT BINARY_DIR RESULT)
    set(_rcc_M_kwargs INCLUDES CMAKE_ARGS)
    cmake_parse_arguments(_rcc "" "${_rcc_O_kwargs}" "${_rcc_M_kwargs}" ${ARGN})

    set(_rcc_contents "include(\${CMAKE_TOOLCHAIN_FILE})")
    #Piece file contents together
    foreach(_rcc_arg ${_rcc_CMAKE_ARGS})
        set(_rcc_set "${_rcc_arg} \"${${_rcc_arg}}\"")
        set(_rcc_contents "${_rcc_contents}\nset(${_rcc_set})")
    endforeach()
    foreach(_rcc_inc ${_rcc_INCLUDES})
        set(_rcc_contents "${_rcc_contents}\ninclude(${_rcc_inc})")
    endforeach()
    set(_rcc_contents "${_rcc_contents}\n${_rcc_COMMAND}")

    #Write to a random file
    string(RANDOM _rcc_prefix)
    cpp_option(_rcc_BINARY_DIR ${CMAKE_BINARY_DIR})
    set(_rcc_file ${_rcc_BINARY_DIR}/${_rcc_prefix}.cmake)
    file(WRITE ${_rcc_file} "${_rcc_contents}")
    execute_process(
        COMMAND ${CMAKE_COMMAND}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -P ${_rcc_file}
        OUTPUT_VARIABLE _rcc_out
        ERROR_VARIABLE _rcc_out
        RESULT_VARIABLE _rcc_var
    )
    set(${_rcc_RESULT} ${_rcc_var} PARENT_SCOPE)
    set(${_rcc_OUTPUT} "${_rcc_out}" PARENT_SCOPE)
endfunction()

function(_cpp_run_sub_build _crsb_dir)
    set(_crsb_T_kwargs NO_INSTALL)
    set(_crsb_O_kwargs INSTALL_PREFIX)
    set(_crsb_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
        _crsb
        "${_crsb_T_kwargs}"
        "${_crsb_O_kwargs}"
        "${_crsb_M_kwargs}"
        ${ARGN}
    )

    if("${_crsb_NO_INSTALL}" STREQUAL "TRUE")
        set(_crsb_install_prefix "")
    else()
        _cpp_valid(_crsb_install_set _crsb_INSTALL_PREFIX)
        _cpp_assert_true(_crsb_install_set)
        set(
            _crsb_install_prefix
            "-DCMAKE_INSTALL_PREFIX=${_crsb_INSTALL_PREFIX}"
        )
    endif()
    set(_crsb_add_args)
    foreach(_crsb_arg ${_crsb_CMAKE_ARGS})
        list(APPEND _crsb_add_args "-D${_crsb_arg}")
    endforeach()

    _cpp_debug_print(
    "CMake command: ${CMAKE_COMMAND}
    -H${_crsb_dir}
    -Bbuild
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${_crsb_INSTALL_PREFIX}
    ${_crsb_add_args}"
    )

    execute_process(
        COMMAND ${CMAKE_COMMAND}
                -H${_crsb_dir}
                -Bbuild
                -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                ${_crsb_install_prefix}
                ${_crsb_add_args}
        WORKING_DIRECTORY ${_crsb_dir}
        RESULT_VARIABLE _crsb_cmake
    )
    #0 is a successful return
    _cpp_assert_false(_crsb_cmake)
    execute_process(
        COMMAND make
        WORKING_DIRECTORY ${_crsb_dir}/build
        RESULT_VARIABLE _crsb_make
    )
    _cpp_assert_false(_crsb_make)
    if(_crsb_NO_INSTALL)
        return()
    endif()
    execute_process(
        COMMAND make install
        WORKING_DIRECTORY ${_crsb_dir}/build
        RESULT_VARIABLE _crsb_install
    )
    _cpp_assert_false(_crsb_install)

endfunction()
