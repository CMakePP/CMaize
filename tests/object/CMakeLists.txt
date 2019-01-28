set(
    OBJECT_TESTS add_members
                 are_equal
                 are_not_equal
                 get_members
                 get_type
                 get_value
                 has_member
                 is_not_object
                 is_object
                 mangle_member
                 new_handle
                 set_type
                 set_value
)

foreach(test_i ${OBJECT_TESTS})
    cpp_cmake_unit_test(${test_i} object)
endforeach()
