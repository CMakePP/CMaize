include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_assert)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env(cpp_print)


set(CPP_DEBUG_MODE FALSE)
_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        BINARY_DIR ${test_prefix}/no_debug
        OUTPUT TEST1
)
_cpp_assert_equal("${TEST1}" "")

set(CPP_DEBUG_MODE TRUE)
_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        BINARY_DIR ${test_prefix}/debug
        OUTPUT TEST2
)
#CMake inserts a newline character
_cpp_assert_equal("${TEST2}" "CPP DEBUG: Hello\n")


