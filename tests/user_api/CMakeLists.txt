set(TESTS add_executable
          add_library
          find_dependency
          find_or_build_dependency
#                     get_dependency_root
#                     get_dependency_dir
#                     record_find
#                     sanitize_version
#                     special_find
#                     write_dependency_toolchain
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} user_api)
endforeach()
