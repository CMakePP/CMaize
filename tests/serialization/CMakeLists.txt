set(
    CEREAL_TESTS  deserialize_object
                  deserialize_string
                  deserialize_value
                  serialize_list
                  serialize_object
                  serialize_string
                  serialize_value
)

foreach(test_i ${CEREAL_TESTS})
    cpp_cmake_unit_test(${test_i} serialization)
endforeach()
