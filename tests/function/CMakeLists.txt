set(TESTS function_ctor
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} function)
endforeach()
