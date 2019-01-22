set(
    OBJECT_TESTS get_type
                 is_object
                 object
                 mangle_member
                 new_handle
                 serialize
)

foreach(test_i ${OBJECT_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
