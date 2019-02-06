include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("is_not_defined")

_cpp_add_test(
TITLE "Not defined"
"include(logic/is_not_defined)"
"_cpp_is_not_defined(output NOT_A_DEFINED_VARIABLE)"
"_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Set to empty string is defined"
"include(logic/is_not_defined)"
"set(A_VARIABLE \"\")"
"_cpp_is_not_defined(output A_VARIABLE)"
"_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "Set to non-empty contents is defined"
"include(logic/is_not_defined)"
"set(A_VARIABLE \"Hello World!!!\")"
"_cpp_is_not_defined(output A_VARIABLE)"
"_cpp_assert_false(output)"
)
