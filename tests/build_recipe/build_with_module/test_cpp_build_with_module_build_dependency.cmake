include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_with_module_build_dependency")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_dummy_build_module(module ${test_prefix})
_cpp_add_test(
TITLE "Basic usage"
"include(build_recipe/build_with_module/build_with_module)"
"_cpp_BuildWithModule_ctor("
"   handle \"${module}\" \"${path}\" \"${CMAKE_TOOLCHAIN_FILE}\" \"\""
")"
"_cpp_assert_does_not_exist(${path}/install)"
"_cpp_BuildWithModule_build_dependency(\${handle} ${path}/install)"
"_cpp_assert_exists(${path}/install)"
)
