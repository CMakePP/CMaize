include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_checks)

set(CPP_DEBUG_MODE FALSE)
_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        OUTPUT TEST1
)
_cpp_assert_str_equal("${TEST1}" "")

set(CPP_DEBUG_MODE TRUE)
_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE
        COMMAND "_cpp_debug_print(Hello)"
        OUTPUT TEST2
)
#CMake inserts a newline character
_cpp_assert_str_equal("${TEST2}" "CPP DEBUG: Hello\n")


