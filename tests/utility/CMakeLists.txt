set(
    UTILITY_TESTS set_return
)

foreach(test_i ${UTILITY_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
