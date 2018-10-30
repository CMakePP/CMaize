set(
    USE_CASE_TESTS provided_toolchain
)

foreach(test_i ${USE_CASE_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
