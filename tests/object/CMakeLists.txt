set(
    OBJECT_TESTS new_target
)

foreach(test_i ${OBJECT_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
