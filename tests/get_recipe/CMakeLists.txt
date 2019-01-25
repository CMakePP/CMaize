add_subdirectory(get_from_github)
set(TESTS "")

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_recipe)
endforeach()
