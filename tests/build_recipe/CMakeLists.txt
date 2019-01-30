#add_subdirectory(build_with_autotools)
add_subdirectory(build_with_cmake)
add_subdirectory(build_with_module)
set(TESTS build_recipe_build_dependency
          build_recipe_ctor
          build_recipe_factory
)

foreach(test_i ${TESTS})
    cpp_cmake_unit_test(${test_i} build_recipe)
endforeach()
