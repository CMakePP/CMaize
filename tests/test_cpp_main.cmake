include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_assert)
include(CPPMain)
include(../cmake/cpp_unit_test_helpers.cmake)

_cpp_setup_test_env(cpp_main)
set(PROJECT_NAME test_cpp_main)

################################################################################
# Test that toolchain.cmake is only made if variable is non-empty
################################################################################
set(CMAKE_BINARY_DIR ${test_prefix}/build)
CPPMain()
_cpp_assert_does_not_exist(${test_prefix}/build/toolchain.cmake)

set(CMAKE_TOOLCHAIN_FILE "")
CPPMain()
_cpp_assert_exists(${test_prefix}/build/toolchain.cmake)



