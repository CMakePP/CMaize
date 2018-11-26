set(
    OPTIONS_TESTS option
                  pack_list
                  parse_arguments
                  unpack_list
)

foreach(test_i ${OPTIONS_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
