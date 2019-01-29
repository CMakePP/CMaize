set(TESTS find_from_module_ctor
          find_from_module_find_dependency
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} find_from_module)
endforeach()
