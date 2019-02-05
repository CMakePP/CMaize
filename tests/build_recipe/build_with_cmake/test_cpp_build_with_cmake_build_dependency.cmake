include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_with_cmake_build_dependency")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic usage"
"include(build_recipe/build_with_cmake/build_with_cmake)"
"_cpp_Kwargs_ctor(kwargs)"
"_cpp_BuildWithCMake_ctor(handle \${kwargs} NAME dummy SOURCE_DIR \"${path}\")"
"_cpp_assert_does_not_exist(${path}/install)"
"_cpp_BuildWithCMake_build_dependency(\${handle} ${path}/install)"
"_cpp_assert_exists(${path}/install)"
)
