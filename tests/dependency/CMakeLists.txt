set(
    DEPEND_TESTS find_dependency
                 find_or_build_dependency
                 get_gh_url
                 get_remote_dependency
                 get_source_tarball
                 record_find
                 untar_directory
)

foreach(test_i ${DEPEND_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
