include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("is_empty")

_cpp_add_test(
TITLE "Not defined"
"include(logic/is_empty)"
"_cpp_is_empty(output NOT_A_DEFINED_VARIABLE)"
"_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Set to empty string"
"include(logic/is_empty)"
"set(A_VARIABLE \"\")"
"_cpp_is_empty(output A_VARIABLE)"
"_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Set to real contents"
"include(logic/is_empty)"
"set(A_VARIABLE \"Hi there\")"
"_cpp_is_empty(output A_VARIABLE)"
"_cpp_assert_false(output)"
)
