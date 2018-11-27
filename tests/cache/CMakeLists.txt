set(
    CACHE_TESTS cache_add_get_recipe
                cache_get_recipe
                cache_get_recipe_path
)

foreach(test_i ${CACHE_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
