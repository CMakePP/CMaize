include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_recipe_factory")

_cpp_add_test(
TITLE "Setting both URL and SOURCE_DIR is an error"
SHOULD_FAIL REASON "Please specify one (and only one) of SOURCE_DIR or URL"
"include(get_recipe/get_recipe_factory)"
"_cpp_GetRecipe_factory(test SOURCE_DIR a/path URL a/url)"
)

_cpp_add_test(
TITLE "Setting neither URL or SOURCE_DIR is an error"
SHOULD_FAIL REASON "Please specify one (and only one) of SOURCE_DIR or URL"
"include(get_recipe/get_recipe_factory)"
"_cpp_GetRecipe_factory(test)"
)

_cpp_add_test(
TITLE "Setting URL results in a GetFromURL object"
"include(get_recipe/get_recipe_factory)"
"_cpp_GetRecipe_factory(handle URL a/url)"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\${test} GetFromURL)"
)

_cpp_add_test(
TITLE "Setting SOURCE_DIR results in a GetFromDisk object"
"include(get_recipe/get_recipe_factory)"
"_cpp_GetRecipe_factory(handle SOURCE_DIR a/path)"
"_cpp_Object_get_type(\${handle} test)"
"_cpp_assert_equal(\${test} GetFromDisk)"
)
