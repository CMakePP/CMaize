set(
    OPTIONS_TESTS option
                  pack_list
                  unpack_list
)

foreach(test_i ${OPTIONS_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
