include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_recipe_find_dependency")
_cpp_install_dummy_cxx_package(install_dir ${test_prefix}/${test_number})

_cpp_add_test(
TITLE "Dispatches to FindFromConfig correctly"
"include(find_recipe/find_from_config/find_from_config)"
"include(find_recipe/find_recipe)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromConfig_ctor(t \${kwargs} NAME dummy)"
"_cpp_FindRecipe_find_dependency(\${t} \"${install_dir}\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)

_cpp_install_naive_cxx_package(install_dir ${test_prefix}/${test_number})
_cpp_naive_find_module(module ${test_prefix}/${test_number})

_cpp_add_test(
TITLE "Dispatches to FindFromModule correctly"
"include(find_recipe/find_from_module/find_from_module)"
"include(find_recipe/find_recipe)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(t ${module} \${kwargs} NAME dummy)"
"_cpp_FindRecipe_find_dependency(\${t} \"${install_dir}\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Honors xxx_ROOT"
"include(find_recipe/find_from_module/find_from_module)"
"include(find_recipe/find_recipe)"
"set(dummy_ROOT ${install_dir})"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(t ${module} \${kwargs} NAME dummy)"
"_cpp_FindRecipe_find_dependency(\${t} \"\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Fails if xxx_ROOT is set, but dependency can't be found"
SHOULD_FAIL REASON "dummy_ROOT was set to not/a/path, but dummy was not found."
"include(find_recipe/find_from_module/find_from_module)"
"include(find_recipe/find_recipe)"
"set(dummy_ROOT not/a/path)"
"_cpp_kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(t ${module} \${kwargs} NAME dummy)"
"_cpp_FindRecipe_find_dependency(\${t} \"\")"
)
