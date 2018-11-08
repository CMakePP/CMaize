set(
    FIND_RECIPES_TESTS find_using_path
                       find_using_user_recipe
)

foreach(test_i ${FIND_RECIPES_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
