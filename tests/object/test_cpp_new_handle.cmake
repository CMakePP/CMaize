include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("new_handle")

_cpp_add_test(
TITLE "Basic usage"
"include(object/new_handle)"
"include(logic/is_target)"
"_cpp_Object_new_handle(test T)"
"string(SUBSTRING \${test} 0 5 prefix)"
"_cpp_assert_equal(\${prefix} _cpp_)"
"_cpp_is_target(is_target \${test})"
"_cpp_assert_true(is_target)"
)
