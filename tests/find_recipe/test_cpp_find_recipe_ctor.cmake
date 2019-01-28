include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("find_recipe_ctor")

_cpp_add_test(
TITLE "Crashes if name is not provided"
SHOULD_FAIL REASON "Dependency name must be set."
"include(find_recipe/ctor)"
"_cpp_FindRecipe_ctor(handle \"\" \"\" \"\")"
)

_cpp_add_test(
TITLE "Basic usage"
"include(find_recipe/ctor)"
"_cpp_FindRecipe_ctor(handle \"name\" \"version\" \"comps\")"
"_cpp_Object_get_value(\${handle} test name)"
"_cpp_assert_equal(\"\${test}\" \"name\")"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"version\")"
"_cpp_Object_get_value(\${handle} test components)"
"_cpp_assert_equal(\"\${test}\" \"comps\")"
"_cpp_Object_get_value(\${handle} test root)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Defaults"
"include(find_recipe/ctor)"
"_cpp_FindRecipe_ctor(handle \"name\" \"\" \"\")"
"_cpp_Object_get_value(\${handle} test name)"
"_cpp_assert_equal(\"\${test}\" \"name\")"
"_cpp_Object_get_value(\${handle} test version)"
"_cpp_assert_equal(\"\${test}\" \"latest\")"
"_cpp_Object_get_value(\${handle} test components)"
"_cpp_assert_equal(\"\${test}\" \"\")"
"_cpp_Object_get_value(\${handle} test root)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)

_cpp_add_test(
TITLE "Detects xxx_ROOT"
"include(find_recipe/ctor)"
"set(name_ROOT a/path)"
"_cpp_FindRecipe_ctor(handle \"name\" \"\" \"\")"
"_cpp_Object_get_value(\${handle} test root)"
"_cpp_assert_equal(\"\${test}\" \"a/path\")"
)
