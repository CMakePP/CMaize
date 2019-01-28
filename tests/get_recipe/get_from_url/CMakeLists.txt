add_subdirectory(get_from_github)
set(TESTS get_from_url_ctor
          get_from_url_factory
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_from_url)
endforeach()
