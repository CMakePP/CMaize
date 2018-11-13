set(
        DEPEND_TESTS find_dependency
        find_or_build_dependency find_package
        record_find
)

foreach(test_i ${DEPEND_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
