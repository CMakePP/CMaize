list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(cpp_tests)
set(TEST_MOD_PATH ${PROJECT_SOURCE_DIR}/cmake ${PROJECT_SOURCE_DIR}/tests)

cpp_cmake_unit_test(cpp_checks "${TEST_MOD_PATH}")
cpp_cmake_unit_test(cpp_print "${TEST_MOD_PATH}")
