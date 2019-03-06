set(
    TESTS mangle_function_name
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} object_guts)
endforeach()
