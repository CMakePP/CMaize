set(
    TARGET_TESTS target_has_property
)

foreach(test_i ${TARGET_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
