include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("contains")

_cpp_add_test(
TITLE "Is a substring"
"include(logic/contains)"
"_cpp_contains(output \"Hello\" \"Hello World\")"
"_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Is not a substring"
"include(logic/contains)"
"_cpp_contains(output \"Nope\" \"Hello World\")"
"_cpp_assert_false(output)"
)
