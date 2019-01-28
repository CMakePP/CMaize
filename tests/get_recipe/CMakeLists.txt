add_subdirectory(get_from_disk)
add_subdirectory(get_from_url)
set(TESTS get_recipe_ctor
          get_recipe_factory
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} get_recipe)
endforeach()
