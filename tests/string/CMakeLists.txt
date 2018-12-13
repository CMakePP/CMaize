set(
    STRING_TESTS string_count
)

foreach(test_i ${STRING_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
