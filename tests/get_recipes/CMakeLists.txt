set(
    GET_RECIPES_TESTS get_gh_url
                      get_source_tarball
)

foreach(test_i ${GET_RECIPES_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
