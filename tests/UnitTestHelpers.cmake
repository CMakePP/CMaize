function(assert_true _at_variable)
    if("${${_at_variable}}" STREQUAL "TRUE")
    elseif(NOT ${${_at_variable}})
        message(FATAL_ERROR "${_at_variable} is FALSE")
    endif()
endfunction()

function(assert_false _at_variable)
    if("${${_at_variable}}" STREQUAL "FALSE")
    elseif(${_at_variable})
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

function(write_top_list _wtl_file _wtl_contents)
    file(
        WRITE ${_wtl_file}

"cmake_minimum_required(VERSION 3.6)
project(ATest VERSION 0.0.0)
set(CMAKE_MODULE_PATH \"${CMAKE_MODULE_PATH}\")
${_wtl_contents}
"

    )
endfunction()

function(run_sub_build _rsb_dir)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -H${_rsb_dir} -Bbuild
        WORKING_DIRECTORY ${_rsb_dir}

    )
    execute_process(
        COMMAND make
        WORKING_DIRECTORY ${_rsb_dir}/build
    )
endfunction()
