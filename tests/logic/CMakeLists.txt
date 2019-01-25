set(
    CHECKS_TESTS contains
                 does_not_contain
                 has_property
                 is_defined
                 is_empty
                 is_list
                 is_not_defined
                 is_not_empty
                 is_not_list
                 is_not_target
                 is_target
                 negate
                 xor
)

foreach(test_i ${CHECKS_TESTS})
    cpp_cmake_unit_test(${test_i} logic)
endforeach()
