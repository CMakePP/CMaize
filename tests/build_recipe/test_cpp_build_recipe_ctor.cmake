include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_recipe_ctor")

_cpp_add_test(
TITLE "Fails if source DNE"
SHOULD_FAIL REASON "The source directory: not/a/path does not exist."
"include(build_recipe/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_BuildRecipe_ctor(handle \${kwargs} NAME dummy SOURCE_DIR \"not/a/path\")"
)

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic usage"
"include(build_recipe/ctor)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_BuildRecipe_ctor(handle \${kwargs} NAME dummy SOURCE_DIR \"${path}\")"
"_cpp_Object_get_value(\${handle} test src)"
"_cpp_assert_equal(\"\${test}\" \"${path}\")"
"_cpp_Object_get_value(\${handle} test args)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)
