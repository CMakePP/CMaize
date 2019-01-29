include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_recipe_factory")

_cpp_add_test(
TITLE "No find module results in FindFromConfig"
"include(find_recipe/find_recipe_factory)"
"_cpp_FindRecipe_factory(handle NAME \"name\")"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\"\${test}\" \"FindFromConfig\")"
)

_cpp_add_test(
TITLE "Find module results in FindFromModule"
"include(find_recipe/find_recipe_factory)"
"_cpp_FindRecipe_factory(handle NAME \"name\" FIND_MODULE \"a/path\")"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\"\${test}\" \"FindFromModule\")"
)
