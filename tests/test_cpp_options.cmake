include(UnitTestHelpers)
include(cpp_options)
set(CPP_DEBUG_MODE TRUE)
_cpp_option(UNSET_OPTION TRUE)
assert_true(UNSET_OPTION)

run_cmake_command(
        INCLUDES cpp_options
        CMAKE_ARGS CMAKE_MODULE_PATH CPP_DEBUG_MODE
        COMMAND "_cpp_option(UNSET_OPTION TRUE)"
        OUTPUT TEST1
)
#CMake inserts a newline character
assert_str_equal("${TEST1}" "UNSET_OPTION set to default: TRUE\n")

set(SET_OPTION FALSE)
_cpp_option(SET_OPTION TRUE)
assert_false(SET_OPTION)

run_cmake_command(
        INCLUDES cpp_options
        CMAKE_ARGS CMAKE_MODULE_PATH SET_OPTION CPP_DEBUG_MODE
        COMMAND "_cpp_option(SET_OPTION TRUE)"
        OUTPUT TEST2
)
#CMake inserts a newline character
assert_str_equal("${TEST2}" "SET_OPTION set by user to: FALSE\n")
