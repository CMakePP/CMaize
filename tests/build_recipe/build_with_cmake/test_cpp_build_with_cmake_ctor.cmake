include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("build_with_module_ctor")

_cpp_dummy_cxx_package(path ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Basic usage"
"include(build_recipe/build_with_cmake/ctor)"
"_cpp_BuildWithCMake_ctor(handle \"${path}\" \"${CMAKE_TOOLCHAIN_FILE}\" \"\")"
"_cpp_Object_get_value(\${handle} test src)"
"_cpp_assert_equal(\"\${test}\" \"${path}\")"
"_cpp_Object_get_value(\${handle} test args)"
"_cpp_assert_equal(\"\${test}\" \"\")"
)
