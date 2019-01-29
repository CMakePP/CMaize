set(TESTS find_from_config_ctor
          find_from_config_find_dependency
          handle_dir
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} find_from_config)
endforeach()
