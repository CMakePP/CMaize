set(TESTS function_ctor
          function_run
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} function)
endforeach()
