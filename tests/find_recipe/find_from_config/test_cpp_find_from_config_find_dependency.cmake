include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_config_find_dependency")
_cpp_install_dummy_cxx_package(install_dir ${test_prefix})

_cpp_add_test(
TITLE "Can not find dummy w/o path"
"include(find_recipe/find_from_config/find_from_config)"
"_cpp_FindFromConfig_ctor(t dummy \"\" \"\")"
"_cpp_FindFromConfig_find_dependency(\${t} \"\" \"\" \"\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "Can find dummy w path"
"include(find_recipe/find_from_config/find_from_config)"
"_cpp_FindFromConfig_ctor(t dummy \"\" \"\")"
"_cpp_FindFromConfig_find_dependency(\${t} \"\" \"\" \"${install_dir}\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Can find dummy w/ dummy_DIR"
"include(find_recipe/find_from_config/find_from_config)"
"set(dummy_DIR ${install_dir})"
"_cpp_FindFromConfig_ctor(t dummy \"\" \"\")"
"_cpp_FindFromConfig_find_dependency(\${t} \"\" \"\" \"\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)

_cpp_add_test(
TITLE "Fails if dummy_DIR is set and dummy is not found"
SHOULD_FAIL REASON "dummy_DIR was set to not/a/path, but was not found."
"include(find_recipe/find_from_config/find_from_config)"
"set(dummy_DIR not/a/path)"
"_cpp_FindFromConfig_ctor(t dummy \"\" \"\")"
"_cpp_FindFromConfig_find_dependency(\${t} \"\" \"\" \"\")"
)

