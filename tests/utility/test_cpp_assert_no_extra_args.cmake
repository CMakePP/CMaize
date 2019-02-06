include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_test_env("assert_no_extra_args")

_cpp_add_test(
TITLE "Fails if non-empty"
SHOULD_FAIL REASON "Function received extra arguments: args."
"include(utility/assert_no_extra_args)"
"_cpp_assert_no_extra_args(args)"
)

_cpp_add_test(
TITLE "Does nothing if empty string."
"include(utility/assert_no_extra_args)"
"_cpp_assert_no_extra_args(\"\")"
)
