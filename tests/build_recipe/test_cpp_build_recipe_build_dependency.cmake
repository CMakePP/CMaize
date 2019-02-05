include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_with_cmake_build_dependency")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Dispatches to BuildWithCMake correctly"
"include(build_recipe/build_with_cmake/ctor)"
"include(build_recipe/build_recipe)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_BuildWithCMake_ctor(handle \${kwargs} NAME dummy SOURCE_DIR \"${path}\")"
"_cpp_assert_does_not_exist(${path}/install)"
"_cpp_BuildRecipe_build_dependency(\${handle} ${path}/install)"
"_cpp_assert_exists(${path}/install)"
)

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_dummy_build_module(module ${test_prefix})
_cpp_add_test(
TITLE "Dispatches to BuildWithModule correctly"
"include(build_recipe/build_with_module/ctor)"
"include(build_recipe/build_recipe)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_BuildWithModule_ctor("
"   handle \"${module}\" \${kwargs} NAME dummy SOURCE_DIR \"${path}\""
")"
"_cpp_assert_does_not_exist(${path}/install)"
"_cpp_BuildRecipe_build_dependency(\${handle} ${path}/install)"
"_cpp_assert_exists(${path}/install)"
)
