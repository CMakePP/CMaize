set(
    BUILD_TESTS build_recipe_dispatch write_cmake_build
)

foreach(test_i ${BUILD_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
