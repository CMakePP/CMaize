include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_recipe_dispatch")

set(src_dir ${test_prefix}/${test_number})
_cpp_install_naive_cxx_package(install_dir ${src_dir})
_cpp_naive_find_module(module ${src_dir})

_cpp_add_test(
TITLE "User provided module"
"include(recipes/cpp_find_recipe_dispatch)"
"_cpp_find_recipe_dispatch(found dummy \"\" \"\" ${install_dir} ${module})"
"_cpp_assert_true(found)"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Config file"
"include(recipes/cpp_find_recipe_dispatch)"
"_cpp_find_recipe_dispatch(found dummy \"\" \"\" ${src_dir}/install \"\")"
"_cpp_assert_true(found)"
)

_cpp_add_test(
TITLE "Fails to find config w/o path"
"include(recipes/cpp_find_recipe_dispatch)"
"_cpp_find_recipe_dispatch(found dummy \"\" \"\" \"\" \"\")"
"_cpp_assert_false(found)"
)
