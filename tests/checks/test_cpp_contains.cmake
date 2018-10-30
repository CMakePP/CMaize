include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("contains")

_cpp_add_test(
TITLE "Is a substring"
CONTENTS
    "_cpp_contains(output \"Hell\" \"Hello World\")"
    "_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Is not a substring"
CONTENTS
    "_cpp_contains(output \"Nope\" \"Hello World\")"
    "_cpp_assert_false(output)"
)
