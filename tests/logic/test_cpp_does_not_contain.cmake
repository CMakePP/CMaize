include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("does_not_contain")

_cpp_add_test(
TITLE "Is a substring"
"include(logic/does_not_contain)"
"_cpp_does_not_contain(output \"Hello\" \"Hello World\")"
"_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "Is not a substring"
"include(logic/does_not_contain)"
"_cpp_does_not_contain(output \"Nope\" \"Hello World\")"
"_cpp_assert_true(output)"
)
