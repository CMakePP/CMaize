include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("test_cpp_xor")

_cpp_add_test(
TITLE "False if no arguments"
CONTENTS
    "_cpp_xor(output)"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "One true argument"
CONTENTS
    "set(arg TRUE)"
    "_cpp_xor(output arg)"
    "_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "One false argument"
CONTENTS
    "set(arg FALSE)"
    "_cpp_xor(output arg)"
    "_cpp_assert_false(arg)"
)

_cpp_add_test(
TITLE "One true, one false"
CONTENTS
    "set(arg1 TRUE)"
    "set(arg2 FALSE)"
    "_cpp_xor(output arg1 arg2)"
    "_cpp_assert_true(output)"
)

_cpp_add_test(
TITLE "Two true"
CONTENTS
    "set(arg1 TRUE)"
    "set(arg2 TRUE)"
    "_cpp_xor(output arg1 arg2)"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "Two false"
CONTENTS
    "set(arg1 FALSE)"
    "set(arg2 FALSE)"
    "_cpp_xor(output arg1 arg2)"
    "_cpp_assert_false(output)"
)

_cpp_add_test(
TITLE "TRUE and empty string"
CONTENTS
    "set(arg1 \"\")"
    "set(arg2 TRUE)"
    "_cpp_xor(output arg1 arg2)"
    "_cpp_assert_true(output)"
)
