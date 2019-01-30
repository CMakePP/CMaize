include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_with_cmake_build_dependency")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Dispatches to BuildWithCMake correctly"
"include(build_recipe/build_with_cmake/ctor)"
"include
"_cpp_BuildWithCMake_ctor(handle \"${path}\" \"${CMAKE_TOOLCHAIN_FILE}\" \"\")"
"_cpp_assert_does_not_exist(${path}/install)"
"_cpp_BuildWithCMake_build_dependency(\${handle} ${path}/install)"
"_cpp_assert_exists(${path}/install)"
)
