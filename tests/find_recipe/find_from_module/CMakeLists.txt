set(TESTS find_from_module_ctor
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} find_from_module)
endforeach()
