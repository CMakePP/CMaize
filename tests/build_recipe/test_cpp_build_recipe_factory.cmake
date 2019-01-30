include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_recipe_factory")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Correctly dispatches to BuildWithCMake"
"include(build_recipe/factory)"
"_cpp_BuildRecipe_factory(handle \"${path}\")"
"_cpp_Object_has_base(\${handle} test BuildWithCMake)"
"_cpp_assert_true(test)"
)

_cpp_dummy_build_module(module ${path})
_cpp_add_test(
TITLE "Correctly dispatches to BuildWithModule"
"include(build_recipe/factory)"
"_cpp_BuildRecipe_factory(handle \"${path}\" BUILD_MODULE ${module})"
"_cpp_Object_has_base(\${handle} test BuildWithModule)"
"_cpp_assert_true(test)"
)
