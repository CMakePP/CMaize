include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)

_cpp_setup_build_env(cpp_cmake_helpers)


################################################################################
# Test _cpp_write_top_list
################################################################################

#Basic usage
_cpp_write_top_list(
    PATH ${test_prefix}/top_list
    NAME top_list_test
    CONTENTS "Hi"
)
_cpp_assert_exists(${test_prefix}/top_list/CMakeLists.txt)
file(READ ${test_prefix}/top_list/CMakeLists.txt test1_contents)
set(test1_corr
"cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(top_list_test VERSION 0.0.0)
include(CPPMain)
CPPMain()
Hi
"
)
_cpp_assert_equal("${test1_contents}" "${test1_corr}")


