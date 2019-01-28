set(TESTS find_from_config_ctor
          handle_dir
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} find_from_config)
endforeach()
