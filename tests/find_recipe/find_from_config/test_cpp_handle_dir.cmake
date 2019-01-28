include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("handle_dir")

_cpp_add_test(
TITLE "Resets name_DIR if set to name_DIR-NOTFOUND"
"include(find_recipe/find_from_config/find_from_config)"
"include(find_recipe/find_from_config/handle_dir)"
"_cpp_FindFromConfig_ctor(t \"name\" \"\" \"\")"
"set(name_DIR name_DIR-NOTFOUND CACHE PATH \"\")"
"_cpp_assert_equal(\"\${name_DIR}\" \"name_DIR-NOTFOUND\")"
"_cpp_FindFromConfig_handle_dir(\${t})"
"_cpp_is_not_defined(test name_DIR)"
"_cpp_assert_true(test)"
"_cpp_Object_get_value(\${t} test config_path)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Leaves valid name_DIR alone."
"include(find_recipe/find_from_config/find_from_config)"
"include(find_recipe/find_from_config/handle_dir)"
"_cpp_FindFromConfig_ctor(t \"name\" \"\" \"\")"
"set(name_DIR a/path)"
"_cpp_FindFromConfig_handle_dir(\${t})"
"_cpp_is_defined(test name_DIR)"
"_cpp_assert_true(test)"
"_cpp_Object_get_value(\${t} test config_path)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
