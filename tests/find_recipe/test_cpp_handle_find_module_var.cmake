include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("handle_found_var")

_cpp_add_test(
TITLE "If xxx_FOUND is not set, found member is false"
"include(find_recipe/find_recipe)"
"include(find_recipe/handle_found_var)"
"_cpp_FindRecipe_ctor(t name \"\" \"\")"
"_cpp_FindRecipe_handle_found_var(\${t})"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_false(test)"
)

_cpp_add_test(
TITLE "If xxx_FOUND is true, found member is true"
"include(find_recipe/find_recipe)"
"include(find_recipe/handle_found_var)"
"_cpp_FindRecipe_ctor(t name \"\" \"\")"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_false(test)"
"set(name_FOUND TRUE)"
"_cpp_FindRecipe_handle_found_var(\${t})"
"_cpp_Object_get_value(\${t} test found)"
"_cpp_assert_true(test)"
)
