set(TESTS  string_cases
           string_count
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} string)
endforeach()
