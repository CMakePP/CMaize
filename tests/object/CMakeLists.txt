set(
    OBJECT_TESTS add_members
                 get_members
                 get_type
                 get_value
                 has_member
                 is_object
                 is_not_object
                 object
                 mangle_member
                 new_handle
                 serialize
                 set_value
)

foreach(test_i ${OBJECT_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
