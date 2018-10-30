include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("is_defined")

_cpp_add_test(
TITLE "Not defined"
CONTENTS
    "_cpp_is_defined(output NOT_A_DEFINED_VARIABLE)"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "Set to empty string"
CONTENTS
    "set(A_VARIABLE \"\")"
    "_cpp_is_defined(output A_VARIABLE)"
    "_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Set to real contents"
CONTENTS
    "set(A_VARIABLE \"Hi there\")"
    "_cpp_is_defined(output A_VARIABLE)"
    "_cpp_assert_true(output)"
)
