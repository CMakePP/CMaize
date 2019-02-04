include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_from_module_ctor")

_cpp_add_test(
TITLE "Fails if module is not specified"
SHOULD_FAIL REASON "Module path must be set."
"include(find_recipe/find_from_module/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(handle \"\" \${kwargs} NAME name)"
)

_cpp_add_test(
TITLE "Basic usage"
"include(find_recipe/find_from_module/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_FindFromModule_ctor(handle \"a/path\" \${kwargs} NAME name)"
"_cpp_Object_get_value(\${handle} test module_path)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
