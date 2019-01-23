set(
    CEREAL_TESTS  serialize_list
                  serialize_object
                  serialize_string
                  serialize_value
)

foreach(test_i ${CEREAL_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
