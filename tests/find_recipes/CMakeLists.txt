set(
    FIND_RECIPES_TESTS find_recipe_dispatch
)

foreach(test_i ${FIND_RECIPES_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
