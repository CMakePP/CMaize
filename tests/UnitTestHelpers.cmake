function(assert_true _at_variable)
    if(NOT ${${_at_variable}})
        message(FATAL_ERROR "${_at_variable} is FALSE")
    endif()
endfunction()

function(assert_false _at_variable)
    if(${_at_variable})
        message(FATAL_ERROR "${_at_variable} is TRUE")
    endif()
endfunction()


function(assert_str_equal _lhs _rhs)
    if(NOT "${_lhs}" STREQUAL "${_rhs}")
        message(FATAL_ERROR "\"${_lhs}\" != \"${_rhs}\"")
    endif()
endfunction()


function(run_cmake_command)
    set(_rcc_O_kwargs COMMAND OUTPUT)
    set(_rcc_M_kwargs INCLUDES CMAKE_ARGS)
    cmake_parse_arguments(_rcc "" "${_rcc_O_kwargs}" "${_rcc_M_kwargs}" ${ARGN})

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
    set(_rcc_file ${CMAKE_BINARY_DIR}/${_rcc_prefix}.cmake)
    file(WRITE ${_rcc_file} "${_rcc_contents}")
    execute_process(
        COMMAND ${CMAKE_COMMAND} -P ${_rcc_file}
        OUTPUT_VARIABLE _rcc_out
        ERROR_VARIABLE _rcc_out
    )
    set(${_rcc_OUTPUT} "${_rcc_out}" PARENT_SCOPE)
endfunction()

function(assert_prints _incs _cmd _value)
    string(RANDOM _ap_prefix)
    set(_ap_file ${CMAKE_BINARY_DIR}/${ap_prefix}.cmake)
    set(_ap_contents "
    ${_incs}
    ${_cmd}
    "
    )
    file(WRITE ${_ap_file} "${_ap_contents}")
    execute_process(
        COMMAND ${CMAKE_COMMAND}
                -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
                -P ${_ap_file}
        OUTPUT_VARIABLE _ap_output
    )
    message("Output: ${_ap_output}")
endfunction()
