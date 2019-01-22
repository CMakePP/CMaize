include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("get_type")

_cpp_add_test(
TITLE "Basic usage"
"include(object/get_type)"
"_cpp_Object_get_type(test _cpp_12345_T)"
"_cpp_assert_equal(\${test} T)"
)
