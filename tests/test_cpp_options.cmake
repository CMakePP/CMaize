include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_options)

set(CPP_DEBUG_MODE TRUE)
cpp_option(UNSET_OPTION TRUE)
_cpp_assert_true(UNSET_OPTION)

_cpp_run_cmake_command(
        INCLUDES cpp_options
        CMAKE_ARGS CPP_DEBUG_MODE
        COMMAND "cpp_option(UNSET_OPTION TRUE)"
        OUTPUT TEST1
)
#CMake inserts a newline character
_cpp_assert_str_equal(
    "${TEST1}"
    "CPP DEBUG: UNSET_OPTION set to default: TRUE\n"
)

set(SET_OPTION FALSE)
cpp_option(SET_OPTION TRUE)
_cpp_assert_false(SET_OPTION)

_cpp_run_cmake_command(
        INCLUDES cpp_options
        CMAKE_ARGS SET_OPTION CPP_DEBUG_MODE
        COMMAND "cpp_option(SET_OPTION TRUE)"
        OUTPUT TEST2
)
#CMake inserts a newline character
_cpp_assert_str_equal(
    "${TEST2}"
    "CPP DEBUG: SET_OPTION set by user to: FALSE\n"
)
