include(UnitTestHelpers)

set(CPP_DEBUG_MODE FALSE)
run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CMAKE_MODULE_PATH CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        OUTPUT TEST1
)
assert_str_equal("${TEST1}" "")

set(CPP_DEBUG_MODE TRUE)
run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CMAKE_MODULE_PATH CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        OUTPUT TEST2
)
#CMake inserts a newline character
assert_str_equal("${TEST2}" "Hello\n")


