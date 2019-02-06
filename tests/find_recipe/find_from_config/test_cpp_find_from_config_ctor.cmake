include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_config_ctor")

_cpp_add_test(
TITLE "Defaults"
"include(find_recipe/find_from_config/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromConfig_ctor(handle \${kwargs} NAME name)"
"_cpp_Object_get_value(\${handle} test config_path)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Honors xxx_DIR"
"include(find_recipe/find_from_config/ctor)"
"set(name_DIR a/path)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromConfig_ctor(handle \${kwargs} NAME name)"
"_cpp_Object_get_value(\${handle} test config_path)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
