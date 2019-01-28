include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_recipe_ctor")

_cpp_add_test(
TITLE "No version defaults to latest"
"include(get_recipe/ctor)"
"_cpp_GetRecipe_ctor(handle \"\")"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"latest\")"
)

_cpp_add_test(
TITLE "Can set version"
"include(get_recipe/ctor)"
"_cpp_GetRecipe_ctor(handle \"1.0\")"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"1.0\")"
)
