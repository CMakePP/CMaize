include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_toolchain)
include(cpp_assert)
include(cpp_unit_test_helpers.cmake)
set(CPP_DEBUG_MODE ON)
#We're testing our ability to generate it so unset the variable now that we
#loaded it (we need CMAKE_MODULE_PATH from it otherwise we'd just not include
#it)
set(CMAKE_TOOLCHAIN_FILE)

_cpp_setup_build_env("cpp_toolchain")

#We don't actually use the toolchain values so we can make sure they're easy to
#test.  To that end, we're going to set the values to the variable name with
#the prefix and suffix TEST, e.g., TESTCMAKE_C_COMPILERTEST.
_cpp_get_toolchain_vars(tc_vars)
foreach(var_i ${tc_vars})
    set(${var_i} "TEST${var_i}TEST")
endforeach()

#We loop over all variables in the toolchain often
function(_cpp_check_toolchain _cct_file)
    foreach(var_i ${tc_vars})
        _cpp_assert_file_contains(
            "set(${var_i} \"TEST${var_i}TEST\")"
            ${_cct_file}
        )
    endforeach()
endfunction()

#################################################################################
## Test _cpp_write_toolchain_file
#################################################################################
set(CMAKE_BINARY_DIR ${test_prefix}/write_file/test1)

_cpp_write_toolchain_file()
#Check sets the toolchain variable
_cpp_assert_equal(
    "${CMAKE_TOOLCHAIN_FILE}"
    "${CMAKE_BINARY_DIR}/toolchain.cmake"
)

#Check contents
_cpp_check_toolchain(${CMAKE_TOOLCHAIN_FILE})

#Check can pass directory
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/write_file/test2)
_cpp_assert_exists(${test_prefix}/write_file/test2/toolchain.cmake)
_cpp_check_toolchain(${CMAKE_TOOLCHAIN_FILE})

#Check it does not write empty variables
set(CMAKE_C_COMPILER "")
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/write_file/test3)
_cpp_assert_exists(${test_prefix}/write_file/test3/toolchain.cmake)
_cpp_assert_file_does_not_contain(
    "set(CMAKE_C_COMPILER"
    ${CMAKE_TOOLCHAIN_FILE}
)
#Reset C Compiler
set(CMAKE_C_COMPILER "TESTCMAKE_C_COMPILERTEST")

################################################################################
# Test _cpp_change_toolchain
################################################################################

#Basic usage
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/change_toolchain/test1)
_cpp_change_toolchain(VARIABLES CMAKE_CXX_COMPILER "new_CXX_value")
foreach(var_i ${tc_vars})
    cmake_policy(SET CMP0054 NEW)
    if("${var_i}" STREQUAL "CMAKE_CXX_COMPILER")
        _cpp_assert_file_contains(
            "set(CMAKE_CXX_COMPILER \"new_CXX_value\")"
            ${CMAKE_TOOLCHAIN_FILE}
        )
    else()
        _cpp_assert_file_contains(
            "set(${var_i} \"TEST${var_i}TEST\")"
            ${CMAKE_TOOLCHAIN_FILE}
        )
    endif()
endforeach()

#Change non-existing variable
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/change_toolchain/test2)
_cpp_change_toolchain(VARIABLES NOT_A_VARIABLE "not_a_value")
_cpp_check_toolchain(${CMAKE_TOOLCHAIN_FILE})
_cpp_assert_file_contains(
    "set(NOT_A_VARIABLE \"not_a_value\")"
    ${CMAKE_TOOLCHAIN_FILE}
)

#Null usage
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/change_toolchain/test3)
_cpp_change_toolchain()
_cpp_check_toolchain(${CMAKE_TOOLCHAIN_FILE})

#Can specify the toolchain
set(test4_toolchain ${test_prefix}/change_toolchain/test4)
_cpp_write_toolchain_file(DESTINATION ${test4_toolchain})
set(test4_toolchain "${test4_toolchain}/toolchain.cmake")
set(CMAKE_TOOLCHAIN_FILE "")
_cpp_change_toolchain(
        TOOLCHAIN ${test4_toolchain}
        VARIABLES NOT_A_VARIABLE "not_a_value"
)
_cpp_check_toolchain(${test4_toolchain})
_cpp_assert_file_contains(
        "set(NOT_A_VARIABLE \"not_a_value\")"
        ${test4_toolchain}
)

#Modify multiple variables
_cpp_write_toolchain_file(DESTINATION ${test_prefix}/change_toolchain/test5)
_cpp_change_toolchain(
    VARIABLES CMAKE_CXX_COMPILER "new_CXX_value"
              CMAKE_C_COMPILER "new_C_value"
)
foreach(var_i ${tc_vars})
    cmake_policy(SET CMP0054 NEW)
    if("${var_i}" STREQUAL "CMAKE_CXX_COMPILER")
        _cpp_assert_file_contains(
            "set(CMAKE_CXX_COMPILER \"new_CXX_value\")"
            ${CMAKE_TOOLCHAIN_FILE}
        )
    elseif("${var_i}" STREQUAL "CMAKE_C_COMPILER")
        _cpp_assert_file_contains(
            "set(CMAKE_C_COMPILER \"new_C_value\")"
            ${CMAKE_TOOLCHAIN_FILE}
        )
    else()
        _cpp_assert_file_contains(
            "set(${var_i} \"TEST${var_i}TEST\")"
            ${CMAKE_TOOLCHAIN_FILE}
        )
    endif()
endforeach()
