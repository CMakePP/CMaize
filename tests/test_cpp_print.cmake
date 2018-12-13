include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_assert)
include(../cmake/cpp_unit_test_helpers.cmake)

_cpp_setup_test_env(cpp_print)

################################################################################
# Test _cpp_debug_print
################################################################################

_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE=False
        COMMAND "_cpp_debug_print(Hello)"
        BINARY_DIR ${test_prefix}/no_debug
        OUTPUT TEST1
)
_cpp_assert_equal("${TEST1}" "")

_cpp_run_cmake_command(
        INCLUDES cpp_print
        CMAKE_ARGS CPP_DEBUG_MODE=True
        COMMAND "_cpp_debug_print(Hello)"
        BINARY_DIR ${test_prefix}/debug
        OUTPUT TEST2
)
#CMake inserts a newline character
_cpp_assert_equal("${TEST2}" "CPP DEBUG: Hello\n")

#
# Note that _cpp_print_target and _cpp_print_interface are tightly coupled to
# the testing of cpp_add_library.  Therefore the tests would be nearly identical
# and we opt to only test cpp_add_library, knowing that both prints will also be
# tested along the way
#

################################################################################
# Test _cpp_print_target
################################################################################

set(dummy_root ${test_prefix}/print_target)
_cpp_dummy_cxx_library(${dummy_root}/dummy)

#Print a simple target
set(dummy1_root ${test_prefix}/print_target/test1)
file(COPY ${dummy_root}/dummy DESTINATION ${dummy1_root})

set(
    include_corr
    "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:${dummy1_root}/dummy>"
)
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(
        ${dummy1_root}/dummy
        NO_BUILD NO_INSTALL
        NAME dummy
        CONTENTS "include(cpp_targets)
                  include(cpp_print)
                  cpp_add_library(
                      dummy
                      SOURCES ${dummy1_root}/dummy/a.cpp
                      INCLUDES ${dummy1_root}/dummy/a.hpp
                  )
                  _cpp_print_target(dummy)"
        OUTPUT test1_output)
_cpp_assert_contains("Target : dummy" "${test1_output}")
_cpp_assert_contains("SOURCES : ${dummy1_root}/dummy/a.cpp" "${test1_output}")
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_17" "${test1_output}")
_cpp_assert_contains(
    "PUBLIC_HEADER : ${dummy1_root}/dummy/a.hpp"
    "${test1_output}"
)
_cpp_assert_contains("${include_corr}" "${test1_output}")



