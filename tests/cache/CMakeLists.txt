set(
    CACHE_TESTS cache_add_build_recipe
                cache_add_find_module
                cache_add_find_recipe
                cache_add_get_recipe
                cache_add_source
                cache_add_tarball
                cache_build_dependency
                cache_build_recipe
                cache_build_recipe_path
                cache_find_module
                cache_find_module_path
                cache_find_recipe
                cache_find_recipe_path
                cache_get_recipe
                cache_get_recipe_path
                cache_install_path
                cache_sanitize_version
                cache_source
                cache_source_path
                cache_tarball
                cache_tarball_path
)

foreach(test_i ${CACHE_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
