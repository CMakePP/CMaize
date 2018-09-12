include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_assert)
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env(cpp_assert)

################################################################################
# Tests of _cpp_assert_true/_cpp_assert_false
################################################################################

foreach(truthy_var TRUE ON 1 YES Y)
    _cpp_assert_true(truthy_var)

    #Test that truthy values trigger asserts for _cpp_assert_false
    _cpp_run_cmake_command(
        COMMAND "set(truthy_var ${truthy_var})\n_cpp_assert_false(truthy_var)"
        RESULT the_result
        BINARY_DIR ${test_prefix}/truth_${truthy_var}
        INCLUDES cpp_assert
    )
    #A failed run returns 1, which is a truthy-value
    _cpp_assert_true(the_result)
endforeach()

foreach(falsy_var FALSE 0 OFF NO N IGNORE NOTFOUND ALIBRARY-NOTFOUND)
    _cpp_assert_false(falsy_var)

    #Test that falsy values trigger asserts for _cpp_assert_true
    _cpp_run_cmake_command(
        COMMAND "set(falsy_var ${falsy_var})\n_cpp_assert_true(falsy_var)"
        RESULT the_result
        BINARY_DIR ${test_prefix}/false_${falsy_var}
        INCLUDES cpp_assert
    )
    _cpp_assert_true(the_result)
endforeach()

################################################################################
# Tests of _cpp_assert_equal/_cpp_assert_not_equal
################################################################################


#Empty string
_cpp_assert_equal("" "")
foreach(non_empty 102 "Hi" TRUE CMAKE_C_COMPILER)
    _cpp_assert_not_equal("" ${non_empty})
    _cpp_run_cmake_command(
        COMMAND "_cpp_assert_equal(\"\" ${non_empty})"
        RESULT the_result
        BINARY_DIR ${test_prefix}/empty_equal_${non_empty}
        INCLUDES cpp_assert
    )
    _cpp_assert_true(the_result)
endforeach()

#Numbers
_cpp_assert_equal(102 102)
foreach(non_102 104 "Hi" TRUE CMAKE_C_COMPILER)
    _cpp_assert_not_equal(102 ${non_102})
    _cpp_run_cmake_command(
            COMMAND "_cpp_assert_equal(102 ${non_102})"
            RESULT the_result
            BINARY_DIR ${test_prefix}/102_equal_${non_102}
            INCLUDES cpp_assert
    )
    _cpp_assert_true(the_result)
endforeach()


#String
_cpp_assert_equal("Hi" "Hi")
foreach(non_hi "bye" TRUE CMAKE_C_COMPILER)
    _cpp_assert_not_equal("Hi" ${non_hi})
    _cpp_run_cmake_command(
            COMMAND "_cpp_assert_equal(\"Hi\" ${non_hi})"
            RESULT the_result
            BINARY_DIR ${test_prefix}/hi_equal_${non_hi}
            INCLUDES cpp_assert
    )
    _cpp_assert_true(the_result)
endforeach()

#Bool
_cpp_assert_equal(TRUE TRUE)
foreach(non_true FALSE CMAKE_C_COMPILER)
    _cpp_assert_not_equal(TRUE ${non_true})
    _cpp_run_cmake_command(
            COMMAND "_cpp_assert_equal(TRUE ${non_true})"
            RESULT the_result
            BINARY_DIR ${test_prefix}/true_equal_${non_true}
            INCLUDES cpp_assert
    )
    _cpp_assert_true(the_result)
endforeach()

#Identifier
_cpp_assert_equal(CMAKE_C_COMPILER CMAKE_C_COMPILER)
_cpp_assert_not_equal(CMAKE_C_COMPILER CMAKE_BINARY_DIR)
_cpp_run_cmake_command(
        COMMAND "_cpp_assert_equal(CMAKE_C_COMPILER CMAKE_BINARY_DIR)"
        RESULT the_result
        BINARY_DIR ${test_prefix}/identifier_equal
        INCLUDES cpp_assert
)
_cpp_assert_true(the_result)

################################################################################
# Test _cpp_assert_exists/_cpp_assert_does_not_exist
################################################################################

_cpp_assert_exists(${CMAKE_CURRENT_SOURCE_DIR})
_cpp_run_cmake_command(
        COMMAND "_cpp_assert_does_not_exist(${CMAKE_CURRENT_SOURCE_DIR})"
        RESULT the_result
        BINARY_DIR ${test_prefix}/exists
        INCLUDES cpp_assert
)
_cpp_assert_true(the_result)

_cpp_assert_does_not_exist(NOT_A_DIRECTORY)
_cpp_run_cmake_command(
    COMMAND "_cpp_assert_exists(NOT_A_DIRECTORY)"
    RESULT the_result
    BINARY_DIR ${test_prefix}/dne
    INCLUDES cpp_assert
)
_cpp_assert_true(the_result)
