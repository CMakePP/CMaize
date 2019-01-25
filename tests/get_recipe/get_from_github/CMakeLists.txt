set(TESTS assemble_gh_url
          parse_gh_url
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_from_github)
endforeach()
