list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(cpp_tests)

file(COPY cpp_unit_test_helpers.cmake DESTINATION ${CMAKE_BINARY_DIR}/tests)

cpp_cmake_unit_test(cpp_checks)
cpp_cmake_unit_test(cpp_dependency)
cpp_cmake_unit_test(cpp_options)
cpp_cmake_unit_test(cpp_print)
cpp_cmake_unit_test(cpp_targets)
