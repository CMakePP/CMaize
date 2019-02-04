include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_recipe_ctor")

_cpp_add_test(
TITLE "No version defaults to latest"
"include(get_recipe/ctor)"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetRecipe_ctor(handle \${kwargs} NAME depend)"
"_cpp_Object_get_value(\${handle} test name)"
"_cpp_assert_equal(\"\${test}\" \"depend\")"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"latest\")"
)

_cpp_add_test(
TITLE "Can set version"
"include(get_recipe/ctor)"
"include(kwargs/kwargs)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_GetRecipe_ctor(handle \${kwargs} NAME depend VERSION 1.0)"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"1.0\")"
)
