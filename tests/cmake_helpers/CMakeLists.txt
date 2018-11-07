set(
    HELPERS_TESTS run_sub_build write_lists
)

foreach(test_i ${HELPERS_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
