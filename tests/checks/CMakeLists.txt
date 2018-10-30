set(
    CHECKS_TESTS contains
                 does_not_contain
                 is_defined
                 is_empty
                 is_not_defined
                 is_not_empty
                 xor
)

foreach(test_i ${CHECKS_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
