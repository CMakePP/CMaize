set(TESTS assemble_gl_url
          get_from_gitlab_ctor
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_from_gitlab)
endforeach()
