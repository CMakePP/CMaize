include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("forward_list")

_cpp_add_test(
TEST "Basic usage"
CONTENTS
    "set(a_list one two three)"
    "_cpp_forward_list(output \"\${a_list}\")"
    "_cpp_assert_equal(\"one\\\\\;two\\\\\;three\" \"\${output}\")"
)
