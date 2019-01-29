add_subdirectory(find_from_config)
add_subdirectory(find_from_module)
set(TESTS find_recipe_ctor
          find_recipe_factory
          find_recipe_find_dependency
          handle_find_module_var
          handle_target_vars
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} find_recipe)
endforeach()
