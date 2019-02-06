set(TESTS build_with_module_build_dependency
          build_with_module_ctor
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} build_with_module)
endforeach()
